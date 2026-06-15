#!/bin/bash

# デザインドックのバックアップスクリプト（Edit/Write前に実行）
# PreToolUseフックから呼び出される

FILE_PATH="$1"

# design-doc.md の編集時のみバックアップを作成
if [[ "$FILE_PATH" == *"outputs/design-doc/design-doc.md"* ]]; then
    DESIGN_DOC="outputs/design-doc/design-doc.md"

    # ファイルが存在するか確認
    if [ -f "$DESIGN_DOC" ]; then
        BACKUP_DIR="outputs/design-doc"
        TIMESTAMP=$(date +%Y%m%d-%H%M%S)

        # バックアップディレクトリが存在することを確認
        mkdir -p "$BACKUP_DIR"

        # バックアップファイル名を生成（.bkN形式）
        # 既存のバックアップ番号を取得
        LAST_BK=$(ls -1 "$DESIGN_DOC".bk* 2>/dev/null | sed 's/.*\.bk//' | sort -n | tail -1)
        if [ -z "$LAST_BK" ]; then
            NEXT_BK=1
        else
            NEXT_BK=$((LAST_BK + 1))
        fi

        BACKUP_FILE="${DESIGN_DOC}.bk${NEXT_BK}"

        # バックアップを作成
        cp "$DESIGN_DOC" "$BACKUP_FILE"

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup created: $BACKUP_FILE (before Edit/Write)"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No existing design-doc.md found. Skipping backup."
    fi
fi
