---
name: mr-summary
description: Generate and independently validate mr-summary.md for the current branch's GitLab merge request. Use when the user asks for an MR summary file based on branch changes and optional context.
---

# Generate an MR summary

Create `mr-summary.md` from the complete change set on the current branch, using any context supplied by the user as emphasis rather than as evidence.

## Analyze

1. Determine the remote default branch, accounting for both `main` and `master`, and inspect the merge-base diff and commits from that base to `HEAD`. Include relevant working-tree changes if the user intends them to be summarized.
2. Verify that the diff direction captures changes introduced by the current branch.
3. When dependency versions changed, identify the exact old and new versions and summarize only behaviorally relevant upgrade effects. Consult authoritative release notes when needed.
4. Extract a Jira issue key from the branch name when present. Do not invent one.

## Write

Write only the following structure to `mr-summary.md`:

```markdown
# <conventional title, including issue key when available>

## Overview
<short, realistic overview>

## Key Changes

### <key change>
- <important change>
```

Keep the list short and focused. Do not add test plans, implementation-detail dumps, or unrelated sections. Never call the work “comprehensive,” overstate incremental changes, or add AI attribution.

## Validate

Use an independent review subagent to compare the draft against the actual diff, commit history, branch context, and dependency versions. Give it the raw evidence and ask it to correct `mr-summary.md` directly when claims are inaccurate or overstated. Review the corrected file yourself before reporting completion.
