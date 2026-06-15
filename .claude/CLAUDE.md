# プロジェクトコンテキスト
非定型のデータからNeo4jベースのナレッジグラフを設計・構築する。

# 技術スタック
- データベース: Neo4j（ポート7687）、v 5.24+
- 言語: Python 3.12+
- ライブラリ: neo4j-driver

# 実行指示(Instructions)
- エラー時は即停止して報告する
- 既存ファイルを上書きする前に確認を取る

# サブエージェント(Agents)構成
- グラフ設計エージェント-->`.claude/agents/graph-skill-designer.md`
- グラフスキーマ設計エージェント-->`.claude/agents/graph-schema-designer.md`
- グラフデータ抽出エージェント-->`.claude/agents/graph-extractor.md`
- グラフ登録エージェント-->`.claude/agents/graph-importer.md`

# プロジェクト構成

```
project/
├── .claude/
│　 ├──settings.json                # プロジェクトの環境設定 
│   ├── agents/                     # サブエージェントの定義
│   │   └── {agent-name}.md         
│   ├── knowledge/                  # 汎用的なナレッジ
│   │   └── xxxx.md                 
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