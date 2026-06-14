# プロジェクトコンテキスト
非定型テキストからNeo4jベースのナレッジグラフを設計・構築する。

# 技術スタック
- データベース: Neo4j（ポート7687）、v 5.24
- 言語: Python 3.12
- ライブラリ: neo4j-driver

# 実行指示(Instructions)
- エラー時は即停止して報告する
- 既存ファイルを上書きする前に確認を取る
- **重要**: グラフデータの抽出と登録には必ず `.claude/skills/graph-importer/scripts/graph_importer.py` を使用する
- **MCP制限**: Neo4j MCPツールは検索クエリのみに使用し、データ登録には使用しない

# サブエージェント(Agents)構成
- スキル設計-->`.claude/agents/graph-skill-designer.md`を実行
- スキーマ設計-->`.claude/agents/graph-schema-designer.md`を実行
- グラフデータ抽出-->`.claude/agents/graph-extractor.md`を実行
- Cypher作成&グラフ登録-->`.claude/agents/graph-importer.md`を実行（graph_importer.pyを使用）

# プロジェクト構成

```
project/
├── .claude/
│　 ├──settings.json                # プロジェクトの環境設定 
│   ├── agents/
│   │   └── {agent-name}.md         # サブエージェントの定義
│   └── skills/
│       ├── {agent-name}/
│       │   ├── SKILL.md            # 具体的な指示
│       │   ├── xxxx.md             # 出力フォーマット、サンプルなど
│       │   └── scripts/            # エージェントの実行スクリプト
│       └── shared/
│           └── xxxx.md             # 複数のエージェントが共有するスキルなど
├── hooks/                          # イベント自動実行スクリプト
├── scripts/                        # パイプラインスクリプト（エージェント横断）
├── inputs/                         # 読み取り専用の入力データ
│　 ├── sample-data/                # デザインドック抽出対象のデータ
│   └── source-data/                # グラフ抽出対象のソースデータ
├── outputs/                        # 生成物の出力先
│   ├── design-doc/                 # グラフ設計書
│   ├── graph-data/                 # 抽出されたグラフデータ（JSON）
│   ├── queries/                    # クエリ定義ファイル（Cypher文）
│   └── schema/                     # グラフスキーマ定義
│       └── schema.json             # グラフ定義（ノード / 関係性）
├── logs/                           # 実行ログ
└── settings.json                   # プロジェクトの設定ファイル
```