# Neo4j Graph Designer

`Neo4j Graph Designer` は、Claude Codeでグラフの設計からサンプルグラフ作成までを自動化したツールです。

## 🚀 概要

すべての作業は、Claude Code上で「〇〇して」と指示するだけでグラフモデリングのエキスパートのようにデータモデリングし、サンプルグラフの作成・評価を実現できます。

* **Step 1:** AI駆動による「グラフ設計書（デザインドック）」の作成と評価
* **Step 2:** AI駆動による「グラフスキーマ」の作成
* **Step 3:** AI駆動による「グラフデータ」の抽出
* **Step 4:** Cypherクエリ生成・グラフ登録・評価

> ただし、ここで紹介している範囲は、**Step 1のみ**です。ご了承ください。

## 🛠 事前準備

* **AI ツール**: Claude Code

* **テンプレートのダウンロード**

```bash
git clone https://github.com/awk256/neo4j-lab-graph-designer.git
cd neo4j-lab-graph-designer
```

プロジェクトの構成は、以下の通りです。

```text
├── .claude 
├── .claude.json
├── README.md
├── inputs 
├── outputs 
├── logs 
└── settings.json
```

Claude Codeのテンプレートの構成は、以下の通りです。

```
.
├── .claude
│   ├── CLAUDE.md
│   ├── agents
│   │   └── graph-skill-designer.md
│   ├── hooks
│   │   ├── designdoc_backup.sh
│   │   └── log_agent_output.shhooks
│   ├── knowledge
│   │   └── graph-design-baseline.md
│   ├── settings.json
│   └── skills
│       └── graph-skill-designer
│           ├── SKILL.md
│           └── graph-skill-template.md
├──  inputs
│   └── sample-data
│       ├── baian-movie.com.txt
│       ├── blueboy-movie.jp.txt
│       ├── gobangiri-movie.com.txt
│       ├── inuoh-anime.com.txt
│       └── migawari-movie.jp.txt
└── outputs
     └──  design-doc
        ├──  design-doc.md
        └──  design-doc.md.sample
```

## 📖 使用方法

### デザインドックの自動作成と評価

- Claude Codeで **デザインドックを作成して** と指示します。
- outputs/design-doc/design-doc.mdの中身を確認してみてください。以下のように文字とおり、グラフDBの設計書になっているはずです。

<br>
<br>

---
グラフデータベース設計書 - 日本映画作品ドメイン
---

# 1. エンティティモデル

## 1-1. エンティティ定義

| ノード名 | 説明 |
|---------|------|
| Movie | 映画作品 |
| Person | 人物（監督、俳優、スタッフ） |
| Organization | 制作会社・配給会社 |
| Genre | ジャンル |
| Award | 受賞情報 |

## 1-2. エンティティの属性一覧

| ノード名 | 属性 | 型 | 必須 | 説明 |
|---------|------|----|----|------|
| Movie | unique_key | string | ✓ | ユニークキー（official_urlまたはtitle+release_yearから生成） |
| Movie | title | string | ✓ | 邦題 |
| Movie | title_en | string |  | 英題 |
| Movie | release_year | integer |  | 公開年 |
| Movie | duration | integer |  | 上映時間（分） |
| Movie | synopsis | string |  | あらすじ |
| Movie | jfdb_url | string |  | 日本映画データベースURL |
| Movie | official_url | string |  | 公式サイトURL |
| Person | unique_key | string | ✓ | ユニークキー（name） |
| Person | name | string | ✓ | 氏名 |
| Organization | unique_key | string | ✓ | ユニークキー（name） |
| Organization | name | string | ✓ | 組織名 |
| Organization | type | string |  | 組織種別（production/distributor） |
| Genre | unique_key | string | ✓ | ユニークキー（name） |
| Genre | name | string | ✓ | ジャンル名 |
| Award | unique_key | string | ✓ | ユニークキー（name+year+category） |
| Award | name | string | ✓ | 賞名 |
| Award | year | integer | ✓ | 受賞年 |
| Award | category | string |  | 部門・カテゴリ |

※注意:冪等性確保のための一意キーは、名称などの属性から選定する。

# 2. ドメインモデル

## 2-1. ドメイン定義（Cypher風記法）

```cypher
// 制作体制
(Movie)-[:DIRECTED_BY]->(Person)
(Movie)-[:PRODUCED_BY]->(Person)
(Person)-[:ACTED_IN {role: "役名"}]->(Movie)
(Person)-[:STAFF_OF {position: "職種"}]->(Movie)

// 制作・配給
(Movie)-[:PRODUCTION]->(Organization)
(Movie)-[:DISTRIBUTED_BY]->(Organization)

// ジャンル分類
(Movie)-[:BELONGS_TO]->(Genre)

// 受賞関係
(Movie)-[:WON]->(Award)
(Person)-[:WON]->(Award)
(Award)-[:FOR_MOVIE]->(Movie)
```

## 2-2. リレーションシップ一覧

| リレーションシップ名 | StartNode | EndNode | 説明 |
|-------------------|-----------|---------|------|
| DIRECTED_BY | Movie | Person | 監督 |
| PRODUCED_BY | Movie | Person | プロデューサー |
| ACTED_IN | Person | Movie | 出演 |
| STAFF_OF | Person | Movie | スタッフ |
| PRODUCTION | Movie | Organization | 製作会社 |
| DISTRIBUTED_BY | Movie | Organization | 配給会社 |
| BELONGS_TO | Movie | Genre | ジャンル分類 |
| WON | Movie | Award | 映画の受賞 |
| WON | Person | Award | 人物の受賞 |
| FOR_MOVIE | Award | Movie | 受賞対象映画 |

## 2-3. リレーションシップの属性一覧

| リレーションシップ名 | StartNode | EndNode | 属性 | 型 | 説明 |
|-------------------|-----------|---------|------|----|----|
| ACTED_IN | Person | Movie | role | string | 役名 |
| STAFF_OF | Person | Movie | position | string | 職種（脚本・音楽・撮影など） |

※詳細は、`design-doc.md`を参照してください。
---

<br>
<br>

- さらに、**データモデル図**を出力してみるといいでしょう。Claude Codeで「**デザインドックからデータモデル図をmermaidで出力して**」と指示してみてください。

```mermaid
graph LR
    %% 1. ノードの定義（タイトルを太字、属性は名称のみ）
    Genre["<b>Genre</b><br>name"]
    
    Movie["<b>Movie</b><br>title<br>title_en<br>release_year<br>duration<br>synopsis<br>jfdb_url<br>official_url"]
    
    Award["<b>Award</b><br>name<br>year<br>category"]
    
    Person["<b>Person</b><br>name"]
    
    Organization["<b>Organization</b><br>name<br>type"]

    %% 2. リレーションシップ（エラー防止のため極限までシンプルに）
    Movie -->|HAS_GENRE| Genre
    
    Movie -->|WON| Award
    Person -->|WON| Award
    Award -->|FOR_MOVIE| Movie
    
    Person -->|ACTED_IN| Movie
    Person -->|DIRECTED| Movie
    Person -->|PRODUCED| Movie
    
    Organization -->|PRODUCED| Movie
    Organization -->|DISTRIBUTED| Movie

    %% 3. デザイン調整（手書き風の白ベース）
    classDef default fill:#FAFAFA,stroke:#4A6572,stroke-width:1.5px,rx:10,ry:10;
    style Movie fill:#FFFFFF,stroke:#1A237E,stroke-width:2px;
```

- 一回目の実行で、はじめから100%期待どおりのグラフモデルを取得することはなかなか難しいものです。理想とする設計に近づけるために、デザインドックの改善を繰り返してください。

##### 1回目の指示(例)

```
グラフのデザインドックを作成して
```

##### 2回目の指示(例)

```
以下の内容をデザインドックに反映してください。

- 映画の内容を「ラッセルの感情円環モデル」を利用して感情分析し、その結果をプロパティに格納したい。感情は2次元空間（「快 - 不快」軸と「覚醒 - 睡眠」軸）で表現してください。
- 映画からタグ、タグからジャンル、映画からジャンルへの距離感をそれぞれスコアリング（0〜1）し、リレーションシップに格納してください。
- タグの例示は100種類用意してください。また、映画には3つ以上の複数のタグをマッピングしてください。
- ジャンルは30種類用意してください。各映画・タグからのジャンルへのマッピングは、最大3種類までに制限してください。
- アワード（Award）はエンティティから除外してください。
```

```mermaid
graph LR
    %% 1. ノードの定義（HTMLタグを使ってタイトルのみ太字に指定）
    Genre["<b>Genre</b><br>name"]
    
    Movie["<b>Movie</b><br>title<br>title_en<br>release_year<br>duration<br>synopsis<br>jfdb_url<br>official_url<br>emotion_valence<br>emotion_arousal"]
    
    Tag["<b>Tag</b><br>name"]
    
    Person["<b>Person</b><br>name"]
    
    Organization["<b>Organization</b><br>name<br>type"]

    %% 2. リレーションシップ
    Movie -->|HAS_GENRE| Genre
    Movie -->|HAS_TAG| Tag
    Tag -->|BELONGS_TO_GENRE| Genre
    
    Person -->|ACTED_IN| Movie
    Person -->|DIRECTED| Movie
    Person -->|PRODUCED| Movie
    
    Organization -->|PRODUCED| Movie
    Organization -->|DISTRIBUTED| Movie

    %% 3. デザイン調整（手書き風の白ベース）
    classDef default fill:#FAFAFA,stroke:#4A6572,stroke-width:1.5px,rx:10,ry:10;
    style Movie fill:#FFFFFF,stroke:#1A237E,stroke-width:2px;
```

##### 3回目の指示(例)
```
以下のような内容をデザインドックに反映してください。
- 感情分析のノードをグラフモデルに追加してください。
- 感情分析の結果は、リレーションシップの属性にしてください。
```

```mermaid
graph LR
      %% 1.ノードの定義（HTMLタグを使ってタイトルのみ太字に指定）

      Person["<b>Person</b><br>name"]
      Organization["<b>Organization</b><br>name<br>type"]

      Movie["<b>Movie</b><br>title<br>title_en<br>release_year<br>duration<br>synopsis<br>jfdb_url<br>official_url"]

      Emotion["<b>Emotion</b><br>name<br>description"]
      Tag["<b>Tag</b><br>name"]
      Genre["<b>Genre</b><br>name"]

      %% 2.リレーションシップ（制作体制）
    
      Person -->|DIRECTED| Movie
      Person -->|PRODUCED| Movie
      Person -->|WROTE_SCREENPLAY| Movie
      Person -->|COMPOSED_MUSIC| Movie
      Person -->|CINEMATOGRAPHY| Movie
      Person -->|EDITED| Movie
      Person -->|ART_DIRECTION| Movie
      Person -->|ACTED_IN| Movie

      %% 3.リレーションシップ（分類・感情）
      Movie -->|HAS_TAG| Tag
      Movie -->|HAS_EMOTION| Emotion
      Movie -->|HAS_GENRE| Genre
      Tag -->|BELONGS_TO_GENRE| Genre

      %% 4.リレーションシップ（組織）
      Organization -->|PRODUCED| Movie
      Organization -->|DISTRIBUTED| Movie

      %% 5.デザイン調整（手書き風の白ベース）
      classDef default fill:#FAFAFA,stroke:#4A6572,stroke-width:1.5px,rx:10,ry:10;
      style Movie fill:#FFFFFF,stroke:#1A237E,stroke-width:2px;
      style Emotion fill:#FFF3E0,stroke:#E65100,stroke-width:2px;
```

このように、AIと対話を重ねながら自分の期待や意図、設計の観点を伝えるだけで、理想のグラフデータモデルがみるみる出来上がっていく実感が得られるはずです。

## 📖 グラフ設計書（デザインドック）の用途

デザインドックは、総合的なグラフ設計書です。企画→PoC→評価→実装段階の設計ドキュメントを

- グラフモデルの設計・評価
- グラフスキーマ設計