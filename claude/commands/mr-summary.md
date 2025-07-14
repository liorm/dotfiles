Generate a summary for merge request of the current code changes.

## Instructions

1. **Review Changes**: First, show me what files have been modified from the base of the current branch.
2. **Generate Message**: Create a clear, concise message that describes the changes with a header. Use markdown formatting for clarity. May it "copy friendly" for easy pasting into a merge request (i.e. wrap in backticks).
3. **Confirmation**: Show the commit hash and summary

- Please follow conventional commit format when possible (feat:, fix:, docs:, etc.).
- Include relevant issue numbers or references if applicable in the title.

**NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" clause or similar AI attribution lines in them messages.
