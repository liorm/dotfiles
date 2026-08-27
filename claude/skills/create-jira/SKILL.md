---
name: create-jira
description: Create an NFR Jira task from the current Git branch and changes using acli, with an optional parent and additional user context. Use when the user asks to turn current repository work into a Jira ticket.
---

# Create a Jira task from current changes

Use `acli` for every Jira operation. Create exactly one `Task` in project `NFR` and assign it to `lmualem@fireblocks.com`; do not allow those values to be overridden.

## Gather the change scope

1. Read the current branch, upstream configuration, remote origin, and status.
2. Determine the repository's base branch from remote metadata, preferring the remote default branch rather than assuming `main` or `master`.
3. On a feature branch, inspect commits and the merge-base diff against the base branch. On the base branch, inspect unpushed commits and working-tree changes. Include staged, unstaged, and relevant untracked files in the analysis.
4. If there is no meaningful change context, ask the user to describe the task instead of inventing a ticket.
5. Derive an actionable summary of at most 100 characters and a description covering the purpose, implementation highlights, branch, and important changed files. Incorporate any additional context supplied by the user.

## Create the ticket

Format the description as Atlassian Document Format (ADF), with useful headings, bullet lists, and inline code marks. Write the ADF to a temporary JSON file excluded from version control, validate that it is valid JSON, and pass it with `--description-file`. Do not place ticket content into shell-interpolated command strings.

Before creation, run `acli jira workitem create --help` to confirm the installed syntax. Then create the item with:

```text
acli jira workitem create --project NFR --type Task --summary <summary> --description-file <adf-file> --assignee lmualem@fireblocks.com --json
```

If the user supplied a parent such as `parent: NFR-1234`, include `--parent NFR-1234` in the create command. A parent must be set at creation time; do not try to add it afterward.

Do not attempt to delete or cancel a mistakenly created ticket. Verify all fields before the single create call.

## Report

Return the ticket key, `https://fireblocks.atlassian.net/browse/<ticket-key>`, and a short summary of what the ticket captures.
