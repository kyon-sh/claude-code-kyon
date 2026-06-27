#!/bin/bash
# Hook script for Claude Code SessionStart event
# Shows welcome message and Kyon detection status

# Check if running in Kyon terminal
if [ "$TERM_PROGRAM" = "KyonTerminal" ]; then
    # Running in Kyon - notifications will work
    cat << 'EOF'
{
  "systemMessage": "🔔 Kyon plugin active. You'll receive native Kyon notifications when tasks complete or input is needed."
}
EOF
else
    exit 0
fi
