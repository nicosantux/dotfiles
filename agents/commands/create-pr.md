---
description: Generate a PR/MR description from the current branch commits and optionally create it via CLI
---

Generate a pull request / merge request description based on the commits of the current branch, then offer to create it using the available CLI tool.

## Step 1 - Parse arguments

`$ARGUMENTS` may contain zero or more whitespace-separated tokens, in any order. Classify each token:

- **Template**: the token is an existing file path.
- **Range**: the token contains `..` (e.g. `abc123..def456`). Verify both ends with `git rev-parse --verify --quiet "<ref>^{commit}"`.
- **Start commit**: the token resolves with `git rev-parse --verify --quiet "<token>^{commit}"`. The PR covers that commit (inclusive) up to `HEAD`, i.e. the range `<token>^..HEAD`.

If a token matches none of these, or more than one range/start commit is given, report it and stop.

## Step 2 - Check the current branch

```bash
git branch --show-current
```

If the output is empty (detached HEAD), report it and stop.

## Step 3 - Determine the base branch

The base branch is the branch the PR/MR will target. Resolve it in this order:

1. **Saved base**: `git config branch.<current>.pr-base`. If set, use it without asking.
2. **Closest remote branch**: run `git fetch --prune --quiet origin`, then for every branch in `refs/remotes/origin/` (excluding `origin/HEAD` and `origin/<current>`) count the commits that are in `HEAD` but not in it:

   ```bash
   git for-each-ref --format='%(refname:short)' refs/remotes/origin/ \
     | grep -v -x -e origin -e origin/HEAD -e "origin/<current>" \
     | while read -r ref; do
         echo "$(git rev-list --count "$ref..HEAD") $ref"
       done \
     | awk '$1 > 0' | sort -n | head -5
   ```

   The branch with the lowest count is the one the current branch was created from. On a tie, prefer the repository default branch (`git symbolic-ref --short refs/remotes/origin/HEAD`).
3. Show the detected base and the other candidates, and ask the user to confirm or pick another one.
4. Once confirmed, save it so the next run skips the question:

   ```bash
   git config branch.<current>.pr-base <base>
   ```

## Step 4 - Collect commits

- If a range or start commit was given in Step 1, use it.
- Otherwise use `origin/<base>..HEAD`.

```bash
git log --no-merges --format='%h %s%n%b' <range>
```

If a range or start commit was given, verify its commits belong to the current branch with `git merge-base --is-ancestor <commit> HEAD` and warn the user if they don't.

If no commits are found, report it and stop.

## Step 5 - Determine the template

Check in this order:

1. If a template was given in Step 1, use it.
2. Look for templates in the repository:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/`: list all `.md` files inside
   - `.gitlab/merge_request_templates/`: list all `.md` files inside
3. If multiple template files are found, ask the user which one to use before continuing.
4. If no template is found, use the following default body structure:

```
## Summary

Brief description of the changes being introduced.

## Changes

Concise list of changes. Should be as clear and non-repetitive as possible.
```

## Step 6 - Generate the PR/MR description

Using the commits from Step 4 and the template from Step 5, produce:

- **Title**: follows the [Conventional Commits](https://www.conventionalcommits.org/) format and summarizes the overall change. Use lowercase for all words except proper nouns such as component names, class names, or file names, and wrap those in backticks (e.g. 'feat: add Button component' → 'feat: add `Button` component').
- **Body**: fill in the template sections based on the commit messages and bodies. Be concise and avoid repeating the same information across sections. Remove template HTML comments and keep checklists.

## Step 7 - Present the result

Display the generated content with the title and body clearly separated, along with the base branch:

```
**Base:** <base>
**Title:** <generated title>

---

<generated body>
```

## Step 8 - Offer CLI creation

Detect the platform from `git remote get-url origin`:

- Contains `github.com` → **GitHub**, CLI is `gh`
- Contains `gitlab` → **GitLab**, CLI is `glab`
- Otherwise (e.g. a self-hosted instance) → ask the user whether it is GitHub, GitLab, or neither. If neither, skip CLI creation and end here.

Verify the CLI is installed with `which gh` / `which glab`. If it isn't, inform the user and end here, letting them know they can create the PR/MR manually using the displayed description.

Check whether a PR/MR already exists for the current branch (`gh pr view --json url` / `glab mr view`). If one exists, show its URL and end here.

Ask the user if they want to create the PR/MR. If they confirm:

1. If the branch has no upstream or has unpushed commits (`git rev-list --count @{u}..HEAD`), push it with `git push -u origin HEAD`.
2. Create the PR/MR, passing the body through a quoted heredoc so backticks and quotes are not interpreted by the shell:

   ```bash
   gh pr create --base <base> --title '<title>' --body-file - <<'EOF'
   <body>
   EOF
   ```

   ```bash
   glab mr create --yes --target-branch <base> --title '<title>' --description "$(cat <<'EOF'
   <body>
   EOF
   )"
   ```

If any command fails, show the error and let the user know they can create the PR/MR manually using the displayed description.
