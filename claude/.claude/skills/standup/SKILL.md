# Standup

Daily briefing for the current repo. Tells you where you left off and what's next.

## Usage

- `/standup` — generate today's briefing

## Instructions

When invoked:

1. Run the following commands to gather context:
   - `git log --oneline -10` — recent commits
   - `git status` — any uncommitted work
   - Read `TODO.md` in the repo root if it exists
   - Read `SPRINT.md` in the repo root if it exists

2. Output a briefing with four sections:

**Blocked** (only if TODO.md has a "## Blocked" section with items)
List blocked tasks and their reasons. Surface these first — they need attention before anything else.

**Where you left off**
Summarize the last 1-3 commits in plain language. If there's uncommitted work, mention it.

**What's open**
Pull from TODO.md In Progress and Up Next. List the most relevant next tasks. Keep it short — 3-5 items max.

**Pick one**
Recommend the single best next task to start on. If there are blocked tasks, recommend addressing one of those first. Be direct — don't list options, just pick one and say why.

Keep the whole briefing tight. This is a terminal read, not a document.
