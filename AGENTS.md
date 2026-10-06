# Global agent instructions

- Never use the em dash "—". Use a plain hyphen "-" instead.
- Never automatically add your agent name as a co-author to commit messages.

## Language

Keep communication and implementation languages independent.

- Implementation artifacts must always be written in English, regardless of the user's language.
- This includes code, comments, names, commit messages, documentation, tests, and logs.
- User-facing content must use the language of the application.

## Code style

- Do not add comments to explain code that is already self-explanatory.
- Do not add comments that explain implementation decisions, logic, or context that has already been discussed in the conversation.
- Prefer clear naming and simple code over explanatory comments.
- Do not add comments merely to describe what the following code does.
- Add comments only when they provide information that cannot be reasonably understood from the code itself.
- Use JSDoc or equivalent documentation when documenting public functions, classes, constants, types, or APIs where documentation is useful.
- Keep comments concise and focused on the intent, contract, constraints, or non-obvious behavior rather than restating the implementation.

@RTK.md
