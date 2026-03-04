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
3. **Issue Type**: Choose based on the nature of the change:
   - `Task` - for general work items, improvements, or refactoring
   - `Bug` - for fixes to existing functionality
   - `Story` - for new features or user-facing functionality

### Step 4: Create the Jira ticket

Use the Atlassian MCP to create the ticket with these parameters:
- **Cloud ID**: `74c77072-b566-48d4-9510-0e16c54b26a5`
- **Project Key**: `NFR`
- **Issue Type**: (determined from Step 3)
- **Summary**: (determined from Step 3)
- **Description**: Include:
  - Change overview
  - Files modified (summarized)
  - Branch name
  - Key technical details from the diff
- **Assignee Account ID**: `621f395fc88f1000682e60c2`

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
