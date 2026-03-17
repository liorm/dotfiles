#!/usr/bin/env bash
# Claude Code status line: git branch + dirty indicator

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

if [ -z "$cwd" ]; then
  exit 0
fi

# Resolve git branch and dirty state from the cwd
branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "$branch" ]; then
  exit 0
fi

# Check for uncommitted changes (staged + unstaged + untracked)
dirty=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)

if [ -n "$dirty" ]; then
  printf '\033[33m%s *\033[0m' "$branch"
else
  printf '\033[32m%s\033[0m' "$branch"
fi
