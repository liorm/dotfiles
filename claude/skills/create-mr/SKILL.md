---
name: create-mr
description: Create a GitLab merge request for the current branch using the glab CLI. Use whenever the user asks to create/open/submit an MR or merge request, or when work on a branch is finished and ready to be merged.
---

Create a merge request for the current branch using the GitLab CLI (`glab`).

## Steps

1. Run `glab mr --help` and `glab mr create --help` to confirm available flags/syntax on this `glab` version.
2. **Ensure build is passing**: Run the project's build command (e.g. `yarn build` or `npm run build`). **If it fails, stop** — do not proceed or try to fix.
3. **Ensure lint is fixed**: Run the project's lint command (e.g. `yarn lint` or `yarn lint:fix`). If there are errors, fix them (use the fix variant if available, e.g. `yarn lint:fix`) and re-run until it passes.
4. **Ensure code is properly formatted**: Run the project's format command (e.g. `yarn format` or `yarn format:check` then fix, or `prettier --write`). Fix any formatting issues and re-run until the format check passes.
5. Check the current git status and branch to understand what changes will be included.
6. Check if the current branch tracks a remote branch and push if needed (`git push -u origin <branch>`).
7. Analyze all commits that will be included in the MR (from when the branch diverged from the base branch).
8. **Ensure a Jira ticket exists** — extract the ticket number from the branch name if present (e.g., `XXX-123` from branch names like `fix/XXX-123-description` or `feature/XXX-123-feature-name`). Tickets USUALLY start with `NFR-`.
   - If no ticket is found in the branch name, do **not** fall back to a placeholder like `NFR-000` — it is not a valid ticket. Instead, create a new Jira ticket via `acli` under the `NFR-1800` epic, following the same steps as the `create-jira` skill/command: analyze the branch's diff and commits, then run:
     ```bash
     acli jira workitem create \
       --project "NFR" \
       --type "Task" \
       --parent "NFR-1800" \
       --summary "<summary>" \
       --description "<description>" \
       --assignee "@me"
     ```
   - Use the newly created ticket key (e.g. `NFR-1801`) as the ticket number for the MR title/description going forward.
9. Create an MR summary based on all the commits.
10. Use `glab mr create --remove-source-branch` with `--title` and `--description` flags (refer to the help output from step 1 for exact flags and syntax).
11. **If this MR is part of an active feature/fix implementation you're driving** (i.e. you're still working the task, not just firing off the MR ad hoc), monitor it after creation until it's in a stable state. Skip this step if the user explicitly asked to just create the MR without waiting around:
    - **Pipeline**: run `glab ci status --live` (or poll `glab ci status`) until the pipeline finishes. If it goes red, inspect the failing job (`glab ci trace <job-id|job-name>`), fix the root cause, push, and monitor the new pipeline. Repeat until green.
    - **Comments**: while monitoring, periodically check for new discussions with `glab mr note list --state unresolved`. For each unresolved comment, address it in code if it requires a change, then reply **directly on that discussion thread** with `glab mr note create --reply <discussion-id> -m "<reply>"` — never post a generic top-level MR comment as a substitute for a reply.
    - Stop monitoring once the pipeline is green and all comments seen so far have been replied to.

## MR Description Format

**Title:** `fix(XXX-123): Description` or `feat(XXX-123): Description` (conventional commit, only `feat:` or `fix:`).

**Description body:**

## Overview
Short overview of the change performed.

## API changes
**Only add this section if PUBLIC apis were changed**
Show "diff" - previous API and new API usage and examples

## Key Changes
- List of key changes (1-3 bullet points)
- Focus on the most important changes
- Be realistic about scope - avoid overstating incremental changes as major features
- When package versions change, include their difference in the analysis
- Any relevant context or breaking changes

Keep it simple. A title, an overview and a short list of KEY changes. Don't add anything else.

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" or similar AI attribution lines.
**NEVER** use the word "Comprehensive" — be realistic and to the point.
