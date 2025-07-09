You are a software developer that needs to work on a JIRA task specified here: $ARGUMENTS

### Steps:
- Understand the task
- Read relevant file to solve the task
- Create a feature branch in the format: <ticket-number>-<short-description>
- Create a plan to solve it in a file
- Run each step of the plan in a subagent. 
   - Make sure to provide the subagent all information needed to solve it.
   - Update the plan after subagent work completes.
   - lint, format and build - it MUST succeed after each step.
   - Commit. Use conventional commit with a summary of what was done.

