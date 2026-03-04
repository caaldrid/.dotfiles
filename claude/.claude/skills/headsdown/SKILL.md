# Headsdown Focus Session Timer

Manage a heads-down focus session timer.

## Usage

- `/headsdown <minutes>` — Start (or restart) a focus session for the given duration
- `/headsdown clear` — End the current focus session

## Instructions

Parse the argument after `/headsdown`.

**If the argument is a positive integer (e.g. `45`):**

1. Run this single bash command (substitute the actual number for `<N>`):
   ```bash
   mkdir -p ~/.claude/temp && printf '{\n  "start": "%s",\n  "duration_minutes": <N>\n}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > ~/.claude/temp/headsdown.json
   ```
2. Confirm: "Focus session started. Duration: <N> minutes. Good luck!"

**If the argument is `clear`:**

1. Run: `rm -f ~/.claude/temp/headsdown.json`
2. Confirm: "Focus session cleared."

**Otherwise:** explain usage. Do nothing else.
