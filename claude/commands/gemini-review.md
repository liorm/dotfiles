Perform a Gemini-powered code review on the current changes, then fix the issues found.

Target: $ARGUMENTS (if empty, review the current git diff against main/HEAD)

## Instructions

### Step 1: Determine what to review
- If `$ARGUMENTS` is provided, treat it as a file path or glob pattern to review
- Otherwise, get the current staged+unstaged diff: `git diff HEAD`
- If the diff is empty, get the diff against the main branch: `git diff main...HEAD`
- If still empty, tell the user there is nothing to review and stop

### Step 2: Run Gemini code review
Run the following command to get a structured review from Gemini:

```
git diff HEAD | agent -p --model gemini-3-flash --trust "You are a senior code reviewer. Review the provided git diff carefully.

For each issue found, output in this exact format:
FILE: <filepath>
ISSUE: <brief title>
SEVERITY: <critical|high|medium|low>
DESCRIPTION: <detailed explanation>
SUGGESTION: <concrete fix or improvement>
---

IMPORTANT: Only review the changes shown in the diff. Do not comment on pre-existing code that was not modified. Focus exclusively on: bugs, security issues, performance problems, bad patterns, missing error handling, and logic errors introduced by these changes. Skip style nitpicks unless they are significant. If no issues are found, say 'NO ISSUES FOUND'."
```

Capture the full output.

### Step 3: Present the review
Display the Gemini review output clearly to the user. Group issues by severity (critical first).

### Step 4: Fix the issues
For each issue identified (starting with critical/high severity):
1. Read the relevant file(s)
2. Understand the context around the issue
3. Apply a fix using the Edit tool
4. Verify the fix makes sense and doesn't introduce new problems

After fixing all issues, run a build/lint cycle if applicable (check `package.json` for relevant scripts) to confirm nothing is broken.

### Step 5: Summary
Report what was fixed, what was skipped (and why), and any issues that require manual attention or user decision.
