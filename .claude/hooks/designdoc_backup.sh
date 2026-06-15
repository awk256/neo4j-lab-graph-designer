#!/bin/bash

# デザインドックのバックアップスクリプト
# graph-skill-designerエージェント起動時に実行される

DESIGN_DOC="outputs/design-doc/design-doc.md"
BACKUP_DIR="outputs/design-doc"
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)

# デザインドックファイルが存在するか確認
if [ -f "$DESIGN_DOC" ]; then
    # バックアップディレクトリが存在することを確認
    mkdir -p "$BACKUP_DIR"

    # バックアップファイル名を生成
    BACKUP_FILE="${DESIGN_DOC}.${TIMESTAMP}"

    # バックアップを作成
    cp "$DESIGN_DOC" "$BACKUP_FILE"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup created: $BACKUP_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No existing design-doc.md found. Skipping backup."
fi
