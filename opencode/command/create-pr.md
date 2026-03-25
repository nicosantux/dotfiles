---
description: Generate a PR/MR description from branch commits and optionally create it via CLI
---

Generate a pull request / merge request description based on the commits in the current branch, then offer to create it using the available CLI tool.

## Step 1 — Collect branch commits

Run the following to get commits not yet in the remote:

```bash
git log --oneline --no-merges @{u}..HEAD
```

If the command fails (no upstream configured), fall back to:

```bash
git log --oneline --no-merges HEAD
```

In the fallback case, walk the log top-to-bottom and stop at the first merge commit found. Use all commits listed before that merge commit. If no merge commit is found, use all commits.

## Step 2 — Determine the template

Check in this order:

1. If `$ARGUMENTS` is not empty, treat it as a file path and read that file as the template.
2. Look for templates in the repository:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/` — list all `.md` files inside
   - `.gitlab/merge_request_templates/` — list all `.md` files inside
3. If multiple template files are found across any of those locations, ask the user which one to use before continuing.
4. If no template is found anywhere, use the following default body structure:

```
## Summary

Brief description of the changes being introduced.

## Changes

Concise list of changes. Should be as clear and non-repetitive as possible.
```

## Step 3 — Generate the PR/MR description

Using the commits collected in Step 1 and the template determined in Step 2, produce two separate pieces of content:

- **Title**: plain text, derived from the branch name or the overall theme of the commits. Convert branch naming conventions (e.g. `feature/user-auth`) into a readable title. Use lowercase for all words except proper nouns such as component names, class names, or file names — wrap those in backticks (e.g. 'feat: add Button component' → 'feat: add `Button` component').
- **Body**: fill in the template sections based on the actual commit messages. Be concise and avoid repeating the same information across sections.

## Step 4 — Present the result

Display the generated content to the user with the title and body clearly separated:

```
**Title:** <generated title>

---

<generated body>
```

## Step 5 — Offer CLI creation

Detect the platform from the remote URL:

```bash
git remote get-url origin
```

- If the URL contains `github.com` → platform is **GitHub**, CLI is `gh`
- If the URL contains `gitlab` → platform is **GitLab**, CLI is `glab`
- If the platform cannot be determined → skip CLI creation and inform the user

Then verify the corresponding CLI is installed:

```bash
which gh    # for GitHub
which glab  # for GitLab
```

- If the CLI is installed: ask the user if they want to create the PR/MR using it.
- If the CLI is not installed: inform the user and end here, letting them know they can create it manually using the displayed description.

If the user confirms, create the PR/MR using the appropriate command:

- **gh**: `gh pr create --title "<title>" --body "<body>"`
- **glab**: `glab mr create --title "<title>" --description "<body>"`

If the CLI command fails, show the error and let the user know they can create it manually using the displayed description.
