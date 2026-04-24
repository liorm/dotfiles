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

# Inside a cmux surface: CMUX_WORKSPACE_ID + CMUX_SURFACE_ID (see https://www.cmux.dev/docs/api#detecting-cmux)
IN_CMUX=0
if [ -n "${CMUX_WORKSPACE_ID:-}" ] && [ -n "${CMUX_SURFACE_ID:-}" ] && command -v cmux &>/dev/null; then
  IN_CMUX=1
fi

# Find our tmux target (alerter "Show" + click-to-focus); also determines IN_TMUX
TMUX_BIN=$(command -v tmux 2>/dev/null)
TMUX_TARGET=""
TMUX_WINDOW_NAME=""
IN_TMUX=0

if [ -n "$TMUX_BIN" ] && [ -n "$TMUX_PANE" ]; then
  IN_TMUX=1
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
  if [ -n "$TMUX_TARGET" ]; then
    IN_TMUX=1
    TMUX_WINDOW_NAME=$("$TMUX_BIN" display-message -t "$TMUX_TARGET" -p '#{window_name}' 2>/dev/null)
  fi
fi

# Only notify from cmux or tmux sessions
if [ "$IN_CMUX" -eq 0 ] && [ "$IN_TMUX" -eq 0 ]; then
  exit 0
fi

if [ -n "$MATRIX_SESSION_ID" ] && [ -n "$MATRIX_CORE_URL" ]; then
  NOTIFY_PAYLOAD=$(jq -n --arg text "$MSG" '{"text": $text}')
  curl -s -X POST "$MATRIX_CORE_URL/api/terminal/$MATRIX_SESSION_ID/notify" \
    -H "Content-Type: application/json" \
    -d "$NOTIFY_PAYLOAD" &
fi

# cmux: native notification; skip alerter (even if tmux runs inside cmux)
if [ "$IN_CMUX" -eq 1 ]; then
  (
    cmux notify --title "CC - $DIR" --subtitle "${TMUX_WINDOW_NAME:-$SESSION_ID}" --body "$MSG"
  ) </dev/null >/dev/null 2>&1 &
  disown
  exit 0
fi

(
  RESULT=$(alerter \
    --title "CC - $DIR" \
    --subtitle "${TMUX_WINDOW_NAME:-$SESSION_ID}" \
    --message "$MSG" \
    --sound Glass \
    --timeout 10 \
    --actions "Show")

  if [ "$RESULT" = "@CONTENTCLICKED" ] || [ "$RESULT" = "@ACTIONCLICKED" ] || [ "$RESULT" = "Show" ]; then
    [ -n "$TMUX_TARGET" ] && [ -n "$TMUX_BIN" ] && "$TMUX_BIN" switch-client -t "$TMUX_TARGET"
    open -a Ghostty
  fi
) </dev/null >/dev/null 2>&1 &
disown
