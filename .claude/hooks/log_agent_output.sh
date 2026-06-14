#!/bin/bash
# エージェント実行の出力をログファイルにキャプチャするhook

# 標準入力全体を読み込む（一度しか読めないため変数に保存）
INPUT=$(cat)

# JSONからagent_typeを抽出
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"' 2>/dev/null)

# agent_typeが空の場合はデフォルト値
if [ -z "$AGENT_TYPE" ] || [ "$AGENT_TYPE" = "null" ]; then
    AGENT_TYPE="unknown"
fi

# agent_idを抽出
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"' 2>/dev/null)

# eventを抽出
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"' 2>/dev/null)

# ログディレクトリ作成
mkdir -p logs

# タイムスタンプ付きログファイル名（エージェントID付き）
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/${AGENT_ID}_${TIMESTAMP}.log"

# ログヘッダー
{
    echo "============================================================"
    echo "Agent Execution Log"
    echo "Agent Type: $AGENT_TYPE"
    echo "Agent ID: $AGENT_ID"
    echo "Event: $EVENT"
    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================================================"
    echo ""
    echo "$INPUT" | jq '.'
    echo ""
} > "$LOG_FILE"

# 標準出力にも出力（パイプラインで繋げるため）
echo "$INPUT"
