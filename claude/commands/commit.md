Commit the current code changes with a meaningful commit message.

Use provided subject: $ARGUMENTS

## Instructions

1. **Review Changes**: First, show me what files have been modified using `git status` and `git diff`, include untracked files, include staged and unstaged files.
2. **Generate Message**: Create a clear, concise commit message that describes the changes. If the user provided a subject, then focus the message on that.
3. **Stage and Commit**: Stage all changes, including untracked files and commit them with the generated message. If there are issues (due to precommit hooks, such as lint, format, etc...), fix them. **Make sure everything is staged** before commit !!!
4. **Confirmation**: Show the commit hash and summary

Please follow conventional commit format when possible (feat:, fix:, docs:, etc.)

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" clause or similar AI attribution lines in commit messages.
