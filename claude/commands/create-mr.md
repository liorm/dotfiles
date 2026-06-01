Create a merge request for the current branch using the GitLab CLI (`glab`).

## glab CLI Reference

`glab mr` help:
```!
glab mr --help 2>&1 || echo "glab not found"
```

`glab mr create` help:
```!
glab mr create --help 2>&1 || echo "glab not found"
```

## Steps

1. **Ensure build is passing**: Run the project's build command (e.g. `yarn build` or `npm run build`). **If it fails, stop** — do not proceed or try to fix.
2. **Ensure lint is fixed**: Run the project's lint command (e.g. `yarn lint` or `yarn lint:fix`). If there are errors, fix them (use the fix variant if available, e.g. `yarn lint:fix`) and re-run until it passes.
3. **Ensure code is properly formatted**: Run the project's format command (e.g. `yarn format` or `yarn format:check` then fix, or `prettier --write`). Fix any formatting issues and re-run until the format check passes.
4. Check the current git status and branch to understand what changes will be included.
5. Check if the current branch tracks a remote branch and push if needed (`git push -u origin <branch>`).
6. Analyze all commits that will be included in the MR (from when the branch diverged from the base branch).
7. Extract ticket number from branch name if present (e.g., `XXX-123` from branch names like `fix/XXX-123-description` or `feature/XXX-123-feature-name`). Tickets USUALLY start with `NFR-`. If you can't detect a ticket, use `NFR-000`.
8. Create a comprehensive MR summary based on all the commits.
9. Use `glab mr create --remove-source-branch` with `--title` and `--description` flags (refer to the help output above for exact flags and syntax).

## MR Description Format

**Title:** `fix(XXX-123): Description` or `feat(XXX-123): Description` (conventional commit, only `feat:` or `fix:`).

**Description body:**

## Overview
Short overview of the change performed.

## Key Changes
- List of key changes (1-3 bullet points)
- Focus on the most important changes
- Be realistic about scope - avoid overstating incremental changes as major features
- When package versions change, include their difference in the analysis
- Any relevant context or breaking changes

Keep it simple. A title, an overview and a short list of KEY changes. Don't add anything else.

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" or similar AI attribution lines.
**NEVER** use the word "Comprehensive" — be realistic and to the point.
