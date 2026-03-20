#!/bin/bash
# Post message to Mattermost via bot API
# Usage: ./post-mattermost.sh "message text"

MESSAGE="$1"
CHANNEL_NAME="papers-reports"
BOT_TOKEN="[REDACTED]"
MM_URL="http://10.198.127.160:8065"

# Get team ID (huawei team)
TEAM_RESPONSE=$(curl -s -X GET "$MM_URL/api/v4/teams/name/huawei" \
  -H "Authorization: Bearer $BOT_TOKEN")

TEAM_ID=$(echo "$TEAM_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$TEAM_ID" ]; then
  echo "Failed to get team ID: $TEAM_RESPONSE"
  exit 1
fi

# Get channel ID
CHANNEL_RESPONSE=$(curl -s -X GET "$MM_URL/api/v4/teams/$TEAM_ID/channels/name/$CHANNEL_NAME" \
  -H "Authorization: Bearer $BOT_TOKEN")

CHANNEL_ID=$(echo "$CHANNEL_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$CHANNEL_ID" ]; then
  echo "Failed to get channel ID: $CHANNEL_RESPONSE"
  echo "Make sure bot @soulless-machine is added to #$CHANNEL_NAME"
  exit 1
fi

# Escape message for JSON
ESCAPED_MESSAGE=$(echo "$MESSAGE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# Post message via bot API
RESPONSE=$(curl -s -X POST "$MM_URL/api/v4/posts" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"channel_id\": \"$CHANNEL_ID\",
    \"message\": $ESCAPED_MESSAGE
  }")

if echo "$RESPONSE" | grep -q '"id"'; then
  echo "Posted to #$CHANNEL_NAME as @soulless-machine"
else
  echo "Error posting: $RESPONSE"
  exit 1
fi
