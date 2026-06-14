---
グラフ設計書(デザインドック)を生成するためのベースラインであり、特定ドメインに依存しない汎用ルールの定義。
---

# 1. エンティティモデル

ソースデータを分析し、グラフのノードとして使うエンティティと属性を抽出する。

## 1-1. エンティティ定義

| ノード名 | 説明 |
|---------|------|
| Movie   | 映画作品 |

## 1-2. エンティティの属性一覧

| ノード名 | 属性 | 型 | 必須 | 説明 |
|---------|------|----|----|------|
| Movie | unique_key | string | ✓ | ユニークキー |

※注意:冪等性確保のための一意キーは、名称などの属性から選定する。

---

# 2. ドメインモデル

抽出したエンティティに対し、ノード間のリレーションシップを定義する。

## 2-1. ドメイン定義（Cypher風記法）

```cypher
// 制作体制
(Movie)-[:DIRECTED_BY]->(Person)
```

## 2-2. リレーションシップ一覧

抽出したエンティティに対し、ノード間のリレーションシップを定義する。

| リレーションシップ名 | StartNode | EndNode | 説明 |
|-------------------|-----------|---------|------|
| DIRECTED_BY | Movie | Person | 監督 |

## 2-3. リレーションシップの属性一覧

| リレーションシップ名 | StartNode | EndNode | 属性 | 型 | 説明 |
|-------------------|-----------|---------|------|----|----|
| ACTED_IN | Person | Movie | role | string | 役名 |

---

# 3. インデックス＆制約

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

# 設計メモ

## 特記事項

| 対象 | 規則 | 例 |
|------|------|-----|
| ノードラベル | 大文字始まり→CamelCase | `Movie`, `Person` |
| リレーションシップ | 大文字→SNAKE_CASE | `DIRECTED_BY`, `ACTED_IN` |
| プロパティ名 | 小文字→snake_case | `title`, `name` |
| 空間データ | point型を使用 | `point({latitude: 35.6, longitude: 139.7})` |
| 時間データ | date/datetime型を使用 | `date("2024-01-01")` |

## データの特徴・制約
-

## 今後の拡張可能性
-
