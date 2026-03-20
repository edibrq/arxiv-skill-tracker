#!/bin/bash
# Post message to Mattermost via webhook with bot username
# Usage: ./post-mattermost.sh "message text"

MESSAGE="$1"
WEBHOOK_URL="http://10.198.127.160:8065/hooks/[REDACTED]"
BOT_USERNAME="soulless-machine"
BOT_ICON="https://arxiv.org/static/browse/0.3.4/images/arxiv-logo.svg"

# Post message with bot username override
curl -s -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d "{
    \"username\": \"$BOT_USERNAME\",
    \"icon_url\": \"$BOT_ICON\",
    \"text\": $(echo "$MESSAGE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  }"

echo ""
echo "Posted to Mattermost as @$BOT_USERNAME"
