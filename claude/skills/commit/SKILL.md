---
name: commit
description: Review, stage, and commit all current repository changes with a concise conventional commit message. Use when the user asks to commit the working tree, optionally with a supplied subject or focus.
---

# Commit changes

Commit the repository's current changes, using any subject or context supplied by the user to guide the message.

## Workflow

1. Inspect `git status --short`, staged and unstaged diffs, and every untracked file that would be included. Do not overlook already-staged changes.
2. Check the proposed commit for credentials, private keys, tokens, `.env` files, or other sensitive material. Stop and explain remediation if any are found; never stage them.
3. Write a clear conventional commit message when practical (`feat:`, `fix:`, `docs:`, and so on). Keep it faithful to the complete staged scope and focus it on the user's supplied subject when present.
4. Stage all safe changes, including untracked files, and verify that nothing intended remains unstaged.
5. Commit. If a pre-commit hook fails, fix the underlying lint, formatting, or other in-scope issue, stage the fixes, and retry. Do not bypass hooks.
6. Report the commit hash and one-line summary, plus any files deliberately excluded.

Never add AI attribution such as `Generated with Claude Code` or `Co-Authored-By: Claude`.
