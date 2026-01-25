Create a merge request for the current branch using the GitLab CLI. Follow these steps:

1. Check the current git status and branch to understand what changes will be included
2. Check if the current branch tracks a remote branch and push if needed
3. Analyze all commits that will be included in the MR (from when the branch diverged from the base branch)
4. Extract ticket number from branch name if present (e.g., `XXX-123` from branch names like `fix/XXX-123-description` or `feature/XXX-123-feature-name`)
5. Create a comprehensive MR summary based on all the commits
6. Use `glab mr create --delete-source-branch` to create the merge request and automatically delete the source branch after merging

The MR description should follow this format:

## Title
- Include ticket number if detected from branch name (e.g., `fix(XXX-123): Description`)
- Follow conventional commit format when possible (feat:, fix:, docs:, etc.)

## Overview
Short overview of the change performed.

## Key Changes
- List of key changes (1-3 bullet points)
- Focus on the most important changes
- Be realistic about scope - avoid overstating incremental changes as major features
- When package versions change, include their difference in the analysis
- Any relevant context or breaking changes

Keep it simple. A title, an overview and a short list of KEY changes.
Don't add anything else. No technical details, etc.

Make sure to push the branch to remote with `-u` flag if it's not already tracking a remote branch.

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" clause or similar AI attribution lines in commit messages.
**NEVER** use phrases that say the changes are Comprehensive - it sounds fake. It's NEVER Comprehensive. Be realistic and to the point.