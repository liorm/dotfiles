#!/bin/bash

INPUT=$(cat)

STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
CWD=$(echo "$INPUT" | jq -r '.cwd')
DIR=$(basename "$CWD")
MSG=$(echo "$INPUT" | jq -r '.last_assistant_message // "Task complete"' | cut -c1-100)

EVENT_TYPE=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ -n "$MATRIX_SESSION_ID" ] && [ -n "$MATRIX_CORE_URL" ]; then
  NOTIFY_PAYLOAD=$(jq -n --arg text "$MSG" '{"text": $text}')
  curl -s -X POST "$MATRIX_CORE_URL/api/terminal/$MATRIX_SESSION_ID/notify" \
    -H "Content-Type: application/json" \
    -d "$NOTIFY_PAYLOAD" &
  disown
  exit 0
fi

# Inside a cmux surface: CMUX_WORKSPACE_ID + CMUX_SURFACE_ID (see https://www.cmux.dev/docs/api#detecting-cmux)
if [ -n "${CMUX_WORKSPACE_ID:-}" ] && [ -n "${CMUX_SURFACE_ID:-}" ] && command -v cmux &>/dev/null; then
  # Run synchronously — cmux notify returns immediately and needs the live session context
  cmux notify --title "CC - $DIR" --subtitle "$SESSION_ID" --body "$MSG"
  exit 0
fi

# Find tmux target for alerter click-to-focus
TMUX_BIN=$(command -v tmux 2>/dev/null)
TMUX_TARGET=""
TMUX_WINDOW_NAME=""

if [ -n "$TMUX_BIN" ] && [ -n "$TMUX_PANE" ]; then
  TMUX_TARGET=$("$TMUX_BIN" display-message -t "$TMUX_PANE" -p '#{session_name}:#{window_index}' 2>/dev/null)
  TMUX_WINDOW_NAME=$("$TMUX_BIN" display-message -t "$TMUX_PANE" -p '#{window_name}' 2>/dev/null)
elif [ -n "$TMUX_BIN" ] && pgrep -x tmux &>/dev/null; then
  PID=$$
  while [ "$PID" -gt 1 ]; do
    PID=$(ps -o ppid= -p "$PID" | tr -d ' ')
    TMUX_TARGET=$("$TMUX_BIN" list-panes -a -F '#{session_name}:#{window_index} #{pane_pid}' 2>/dev/null \
      | awk -v pid="$PID" '$2 == pid {print $1}')
    [ -n "$TMUX_TARGET" ] && break
  done
  [ -n "$TMUX_TARGET" ] && \
    TMUX_WINDOW_NAME=$("$TMUX_BIN" display-message -t "$TMUX_TARGET" -p '#{window_name}' 2>/dev/null)
fi

if [ -n "$TMUX_TARGET" ]; then
  (
    RESULT=$(alerter \
      --title "CC - $DIR" \
      --subtitle "${TMUX_WINDOW_NAME:-$SESSION_ID}" \
      --message "$MSG" \
      --sound Glass \
      --timeout 10 \
      --actions "Show")

    if [ "$RESULT" = "@CONTENTCLICKED" ] || [ "$RESULT" = "@ACTIONCLICKED" ] || [ "$RESULT" = "Show" ]; then
      "$TMUX_BIN" switch-client -t "$TMUX_TARGET"
      open -a Ghostty
    fi
  ) </dev/null >/dev/null 2>&1 &
  disown
fi
