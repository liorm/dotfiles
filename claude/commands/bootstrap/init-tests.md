Create a tests summary file under "docs/tests.md" with all the tests in the project.
* The summary file should list the tests files inspected.
* Look for files with extension of *.spec.ts or *.test.ts
* It should provide a name of a test and the description of it, just enough so the user could lookup if a certain flow is implemented.
* If the file already exists then update it.
* In order to preserve context, split the inspection into multiple subagents. Each subagent will be responsible to inspect a single spec file and update the tests.md directly (again - to preserve context)

The file format should be:

# Preface
** purpose of the file
# Test files
## Test file 1 (relative to the project root)
### Summary
** short summary of the test file and its purpose
### Tests
* Test Name - Test description (what it tests)
## Test file 2 (relative to the project root)
### Summary
** short summary of the test file and its purpose
### Tests
* Test Name - Test description (what it tests)
...
etc...
...
...

