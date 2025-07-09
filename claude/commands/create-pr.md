Create a pull request for the current branch using the GitHub CLI. Follow these steps:

1. Check the current git status and branch to understand what changes will be included
2. Check if the current branch tracks a remote branch and push if needed
3. Analyze all commits that will be included in the PR (from when the branch diverged from the base branch)
4. Create a comprehensive PR summary based on all the commits
5. Use `gh pr create` to create the pull request with an appropriate title and description

The PR description should include:
- Summary of changes (1-3 bullet points)
- Any relevant context or breaking changes
- Follow conventional commit format when possible (feat:, fix:, docs:, etc.)

Make sure to push the branch to remote with `-u` flag if it's not already tracking a remote branch.

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" clause or similar AI attribution lines in commit messages.
