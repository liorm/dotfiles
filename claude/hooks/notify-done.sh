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

# Find our tmux target
TMUX_BIN=$(which tmux)
TMUX_TARGET=""

if [ -n "$TMUX_PANE" ]; then
  # We're inside tmux — TMUX_PANE is inherited by child processes
  TMUX_TARGET=$("$TMUX_BIN" display-message -t "$TMUX_PANE" -p '#{session_name}:#{window_index}' 2>/dev/null)
  TMUX_WINDOW_NAME=$("$TMUX_BIN" display-message -t "$TMUX_PANE" -p '#{window_name}' 2>/dev/null)
elif pgrep -x tmux > /dev/null; then
  # Fallback: walk up process tree to find the tmux pane that spawned us
  PID=$$
  while [ "$PID" -gt 1 ]; do
    PID=$(ps -o ppid= -p "$PID" | tr -d ' ')
    TMUX_TARGET=$("$TMUX_BIN" list-panes -a -F '#{session_name}:#{window_index} #{pane_pid}' 2>/dev/null \
      | awk -v pid="$PID" '$2 == pid {print $1}')
    [ -n "$TMUX_TARGET" ] && break
  done
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
    [ -n "$TMUX_TARGET" ] && "$TMUX_BIN" switch-client -t "$TMUX_TARGET"
    open -a Ghostty
  fi
) </dev/null >/dev/null 2>&1 &
disown
