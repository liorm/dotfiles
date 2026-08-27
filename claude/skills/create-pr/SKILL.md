---
name: create-pr
description: Create a GitHub pull request for the current branch with gh after reviewing its full change set and pushing when needed. Use only for GitHub pull requests; use the create-mr skill for GitLab merge requests.
---

# Create a GitHub pull request

Use the GitHub CLI (`gh`) to create a pull request for the current branch.

1. Inspect the remote origin and confirm the repository is hosted on GitHub. If it is GitLab, stop and use the `create-mr` workflow instead.
2. Check status, current branch, upstream tracking, and the remote default/base branch.
3. Analyze all commits and the merge-base diff from where the branch diverged from the base branch. Include any relevant breaking changes or migration context.
4. If the branch is not published or is ahead, push it. Use `git push -u origin <branch>` when no upstream is configured. Do not force-push.
5. Create a concise conventional title when practical and a description containing:
   - a `Summary` section with one to three bullets;
   - relevant context or breaking changes, only when applicable.
6. Run `gh pr create` with the selected base, title, and description, then report the PR URL.

Never add AI attribution such as `Generated with Claude Code` or `Co-Authored-By: Claude` to commits or PR text.
