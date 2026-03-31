Create a Jira ticket in the NFR project based on the current git changes and assign it to Lior Mualem.

## Instructions

### Step 1: Determine the current branch and change scope

Run these git commands to understand the context:

```bash
# Get current branch name
git rev-parse --abbrev-ref HEAD

# Check if there's a remote tracking branch
git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo "no-upstream"
```

### Step 2: Get the relevant diff based on branch

**If on `main` or `master` branch:**
- Check for unpushed commits: `git log @{upstream}..HEAD --oneline 2>/dev/null || git log -5 --oneline`
- Get the diff of unpushed changes: `git diff @{upstream}..HEAD 2>/dev/null || git diff HEAD~1`

**If on any other branch:**
- Determine the main branch (check if `main` or `master` exists): `git rev-parse --verify main 2>/dev/null && echo "main" || echo "master"`
- Get the diff from main: `git diff <main-branch>...HEAD`
- Get the commit messages: `git log <main-branch>..HEAD --oneline`

### Step 3: Analyze the changes

From the diff and commit messages, determine:
1. **Summary**: A concise title describing the change (max 100 chars)
2. **Description**: What the change does, why it's needed, and key implementation details

### Step 4: Create the Jira ticket

Use the `acli` CLI to create the ticket.

**If a parent ticket is specified in the arguments** (e.g. `parent: NFR-1234`), include `--parent` in the create command — this is the ONLY way to set the parent, as `acli jira workitem edit` does not support it:

```bash
acli jira workitem create \
  --project "NFR" \
  --type "Task" \
  --parent "<parent-key>" \
  --summary "<summary>" \
  --description "<description>" \
  --assignee "@me"
```

**Without a parent:**

```bash
acli jira workitem create \
  --project "NFR" \
  --type "Task" \
  --summary "<summary>" \
  --description "<description>" \
  --assignee "@me"
```

Parameters:
- **Project**: `NFR` (always)
- **Type**: always `Task`
- **Parent**: set via `--parent` at create time if provided — cannot be changed after creation via acli
- **Summary**: determined from Step 3 (max 100 chars)
- **Description**: plain text including change overview, files modified, branch name, and key technical details
- **Assignee**: `@me` (self-assign to the authenticated user)

### Step 5: Report the result

After creating the ticket, provide:
- The ticket key (e.g., NFR-123)
- Direct link to the ticket: `https://fireblocks.atlassian.net/browse/<ticket-key>`
- Summary of what was captured

## Additional Context

If arguments are provided below, incorporate them into the ticket description as additional context or requirements:

<additional_context>
$ARGUMENTS
</additional_context>

## Notes

- Always use the NFR project - do not allow overrides
- Always assign to Lior Mualem (accountId 621f395fc88f1000682e60c2)
- If there are no git changes to analyze, ask the user to describe the task manually
- Keep the summary concise and actionable
- Include the branch name in the description for traceability
- **`acli jira workitem edit` does not support `--parent`** — parent must be set at creation time via `--parent`
- **Do not attempt to delete tickets** — permissions do not allow it; create correctly the first time
- **Tickets cannot be cancelled via acli** — transitioning from Backlog requires an Epic Link (custom field), which acli edit does not support. Orphaned tickets can only be linked as duplicates (`acli jira workitem link create --out <new> --in <orphan> --type "Duplicate" --yes`), but not closed programmatically
