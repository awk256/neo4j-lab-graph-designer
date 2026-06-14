---
name: graph-skill-designer
description: ナレッジグラフ設計の自動化スキル
---

# 実行指示

1. グラフ設計のベースライン知識を取得する。
- `.claude/skills/knowledge/graph-design-baseline.md` 

2. デザインドックの出力フォーマットを把握する。
- `.claude/graph-skill-designer/graph-skill-template.md` 

3. サンプルデータ（生データ / ドメインナレッジ / ガイドラインなど）を読み込んでグラフの構成を分析する。
- `inputs/sample-data/*.*` 

4. 既存のデザインドック（グラフ設計書）の存在を確認し、出力の準備を行う。
- `outputs/design-doc/design-doc.md`
- **存在する場合**: 改善ベースの更新を行う
- **存在しない場合**: 初期作成を行う。

5. 既存のデザインドックファイルが存在する場合、更新の前にバックアップファイルを作成する。
  - `design-doc.md` から `.outputs/design-doc/design-doc.md.YYYYMMDD_HHMMSS` 形式の複製を作成する。

6. デザインドックを出力する。
- **出力先**: `outputs/design-doc/design-doc.md`
- **重要**: ユーザの指示に含まれているドメインナレッジや設計メモなどをまとめて反映する。 

7. 完了報告
- アップデートが完了したら、「どのような設計変更が発生したか」の要点を簡潔に報告する。


# 設計指示

## 1. ノード

サンプルデータを分析し、エンティティと属性を抽出する。

### 1-1. エンティティ一覧

| ノード名 | 説明 |
|---------|------|
| Movie   | 映画作品 |

### 1-2. エンティティの属性一覧

| ノード名 | 属性 | 型 | 必須 | 説明 |
|---------|------|----|----|------|
| Movie | name | string | ✓ | ユニークキー |

**重要**: 冪等性確保のための一意キーは、名称などの属性から選定する。


## 2. リレーションシップ

サンプルデータを分析し、グラフの基本構成とリレーションシップ、リレーションシップの属性を抽出する。

### 2-1. ドメインの定義（Cypher風記法）

```cypher
// 制作体制
(Movie)-[:DIRECTED_BY]->(Person)
```

### 2-2. リレーションシップの定義

| リレーションシップ名 | StartNode | EndNode | 説明 |
|-------------------|-----------|---------|------|
| DIRECTED_BY | Movie | Person | 監督 |

### 2-3. リレーションシップの属性定義

| リレーションシップ名 | StartNode | EndNode | 属性 | 型 | 説明 |
|-------------------|-----------|---------|------|----|----|
| ACTED_IN | Person | Movie | role | string | 役名 |

---

## 3. インデックス＆制約

Neo4j 5.24+の構文を想定する。

**インデックス（クエリパフォーマンス向上）**
```cypher
CREATE INDEX movie_title_idx FOR (m:Movie) ON (m.title)
CREATE INDEX person_name_idx FOR (p:Person) ON (p.name)
```

**制約（データ一貫性確保）**
```cypher
CREATE CONSTRAINT movie_title_unique FOR (m:Movie) REQUIRE m.title IS UNIQUE
CREATE CONSTRAINT person_name_unique FOR (p:Person) REQUIRE p.name IS UNIQUE
```

## 設計メモ

### 特記事項

| 対象 | 規則 | 例 |
|------|------|-----|
| ノードラベル | 大文字始まり→CamelCase | `Movie`, `Person` |
| リレーションシップ | 大文字→SNAKE_CASE | `DIRECTED_BY`, `ACTED_IN` |
| プロパティ名 | 小文字→snake_case | `title`, `name` |
| 空間データ | point型を使用 | `point({latitude: 35.6, longitude: 139.7})` |
| 時間データ | date/datetime型を使用 | `date("2024-01-01")` |

### データの特徴・制約
-

### 今後の拡張可能性
-

