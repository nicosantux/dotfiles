---
description: Plan and execute atomic commits following Conventional Commits
---

Analyze the changes to be committed and create a numbered plan of atomic commits following the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Step 1 - Collect changes

Run `git status --porcelain` and `git diff HEAD` to see staged and unstaged changes, and read untracked files directly.

If `$ARGUMENTS` is not empty, restrict the plan to only the files listed in `$ARGUMENTS`. Otherwise, consider all changes, including untracked files.

If a file has both staged and unstaged changes, warn the user that the whole file will be committed, not only the staged part.

## Step 2 - Plan the commits

For each commit, specify:

- **Commit message**:
  - Format: `<type>[optional scope][!]: <description>`.
  - Type is one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
  - Mark breaking changes with `!` after the type/scope and a `BREAKING CHANGE: <description>` footer.
  - Use lowercase for all words except proper nouns such as component names, class names, or file names, and wrap those in backticks (e.g. 'feat: add Button component' → 'feat: add `Button` component').
  - The title must not exceed 72 characters. If the change requires more context, add a body explaining why the change was made.
  - The body must be word-wrapped at 72 characters: when the next word would exceed the limit, insert a newline before it.
- **Files**: exact list of files to include in that commit. For renames, include both the old and the new path.

Present the plan and ask the user for confirmation before proceeding.

## Step 3 - Execute

After confirmation, execute each commit sequentially:

1. Stage the untracked files of this commit, if any: `git add -- <untracked files>`
2. Commit only this commit's files, passing the message through a quoted heredoc so backticks and quotes are not interpreted by the shell. `--only` ignores anything else that was already staged:

   ```bash
   git commit --only -F - -- <files> <<'EOF'
   <title>

   <body>
   EOF
   ```

Never use `--no-verify`. If a step fails (including a hook), stop, show the error, and report which commits were already created.
