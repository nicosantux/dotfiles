---
description: Plan and execute atomic commits following Conventional Commits
---

Analyze the changes to be committed and create a numbered plan of atomic commits following the [Conventional Commits](https://www.conventionalcommits.org/) specification. If `$ARGUMENTS` is not empty, restrict the plan to only the files listed in `$ARGUMENTS`. Otherwise, consider all available changes including untracked files by reading their content directly.

For each commit in the plan, specify:

- **Commit message**: follow these rules:
  - Use lowercase for all words except proper nouns such as component names, class names, or file names — wrap those in backticks (e.g. 'feat: add Button component' → 'feat: add `Button` component').
  - The title must not exceed 72 characters. If the change requires more context, add a body.
  - The body, if needed, must be word-wrapped at 72 characters — when the next word would exceed the limit, insert a newline before it. The last line may be shorter than 72 characters.
- **Files**: exact list of files to include in that commit

Once you present the plan, ask the user for confirmation before proceeding.

After confirmation, execute each commit sequentially:

1. `git add <files for this commit>`
2. `git commit -m "<title>"` or `git commit -m "<title>" -m $'<line1>\n<line2>'` if a body is needed

Proceed commit by commit, stopping if any step fails.
