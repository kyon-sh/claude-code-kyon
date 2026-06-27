#!/bin/bash
# Hook script for Claude Code Notification event (idle_prompt only)
# Sends a structured Kyon notification when Claude has been idle

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/should-use-structured.sh"

# Legacy fallback for old Kyon versions
if ! should_use_structured; then
    [ "$TERM_PROGRAM" = "KyonTerminal" ] && exec "$SCRIPT_DIR/legacy/on-notification.sh"
    exit 0
fi

source "$SCRIPT_DIR/build-payload.sh"

# Read hook input from stdin
INPUT=$(cat)

# Extract notification-specific fields
NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "unknown"' 2>/dev/null)
MSG=$(echo "$INPUT" | jq -r '.message // "Input needed"' 2>/dev/null)
[ -z "$MSG" ] && MSG="Input needed"

BODY=$(build_payload "$INPUT" "$NOTIF_TYPE" \
    --arg summary "$MSG")

"$SCRIPT_DIR/kyon-notify.sh" "kyon://cli-agent" "$BODY"
