Generate a summary for merge request of the current code changes.

Context: $ARGUMENTS

## Instructions

1. **Review Changes**: First, Check what files have been modified from the base of the current branch (i.e. the current branch is meant to be merged back to 'main' branch - so we need to diff against that. Sometimes, there is no 'main' but a 'master' branch - to account for that as well).
  * Double check that you run the diff correctly (i.e. changes since main to HEAD: `git diff origin/main..HEAD`)
2. **Analyze**: When package versions change, include their difference in the analysis. Use external tools if needed for it.
3. **Generate Message**: Create a clear, concise message that describes the changes with a header, according to the changed file. Use markdown formatting for clarity. Write it to a file called "mr-summary.md"
4. **Use context**: If context is specified, focus on it in the generated message.
5. **Validate & Auto-Fix**: Use a subagent to validate the summary against actual changes and automatically apply any corrections without asking for approval:
   * Check accuracy of version numbers and package upgrades
   * Verify all major features mentioned are actually implemented
   * Ensure scope matches the actual commit history and context provided
   * Automatically rewrite the summary if significant inaccuracies are found
   * Focus on being realistic about the scope - avoid overstating incremental changes as major features

**Additional notes:**
- Please follow conventional commit format when possible (feat:, fix:, docs:, etc.).
- Include relevant issue numbers or references if applicable in the title.
- Dont use phrases that say the changes are Comprehensive - it sounds fake. It's NEVER Comprehensive. Be realistic and to the point.
- **NEVER** include "🤖 Generated with Claude Code", "Co-Authored-By: Claude" clause or similar AI attribution lines in them messages.
