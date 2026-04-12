# Todo

Manage TODO.md in the current repo root.

## Usage

- `/todo` — list all open todos
- `/todo add <task>` — add a new todo
- `/todo done <task>` — mark a todo as done (moves to Done section)
- `/todo remove <task>` — delete a todo entirely
- `/todo move <partial> <section>` — move a task to a different section (`in-progress`, `up-next`)
- `/todo suggest` — analyze the codebase and suggest what's missing or next

## TODO.md format

```markdown
# TODO

## In Progress
- [ ] task

## Up Next
- [ ] task

## Done
- [x] task
```

If TODO.md does not exist, create it with this structure when the first todo is added.

## Instructions

**`/todo` (no args)**
Read TODO.md and display all open items grouped by section. Skip Done section.

**`/todo add <task>`**
Add the task as `- [ ] <task>` under the "Up Next" section. Create TODO.md if it doesn't exist.

**`/todo done <task>`**
Find the matching task, mark it `- [x]`, move it to the Done section.

**`/todo remove <task>`**
Delete the matching line from TODO.md entirely.

**`/todo move <partial> <section>`**
Find the first task whose text contains the partial string (case-insensitive). Move it to the matching section.
Valid sections: `in-progress` → "In Progress", `up-next` → "Up Next".
If no match found, say so and do nothing.

**`/todo suggest`**
Read the current TODO.md, then read the codebase to understand what's built and what's missing.
Cross-reference against TODO.md and the project context in CLAUDE.md.
Suggest up to 5 tasks that are not already in TODO.md — things that are genuinely missing, broken, or logically next.
Present the suggestions and ask Carlos which ones to add. Do not add anything without confirmation.

After any write operation, confirm what changed in one line.
