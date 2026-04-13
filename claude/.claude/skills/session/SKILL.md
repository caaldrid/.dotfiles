# Session

ADHD-aware focus session planner. Works in any repo. Breaks tasks into pomodoro-sized chunks, builds a realistic plan, and notifies you when to focus and when to break.

## Usage

- `/session start energy=<low|medium|high> stop=<time>` — plan and start a session
- `/session next` — back from break and task is done, start next pomodoro
- `/session extend` — back from break but not done, re-plan remaining time on current task
- `/session status` — show current session state
- `/session end` — wrap up, log what got done

## Session state file

`~/.claude/temp/session.json`:

```json
{
  "start": "<ISO timestamp>",
  "stop": "<HH:MM 24h>",
  "energy": "<low|medium|high>",
  "current_pomodoro": 0,
  "pomodoros": [
    { "duration": 20, "break": 5, "task": "task description", "done": false }
  ],
  "extend_streak": 0
}
```

`extend_streak` tracks consecutive extends on the same task. Reset to 0 on `/session next`.

## Timer script

The background timer at `~/.claude/temp/session-timer.sh` handles ONE pomodoro at a time:
- Sleep for the current pomodoro duration
- Send "Break time! X min — done with [task]? Come back and run /session next or /session extend" notification
- Exit

It is re-launched by Claude on each `/session next` or `/session extend` call for the next pomodoro.

---

## Instructions

### `/session start energy=<level> stop=<time>`

**Step 1 — Calculate available time**

Run `date` to get current time. Calculate minutes until stop time by hand — do not run python3. If less than 30 minutes, tell user and stop.

**Step 1b — Handle energy parameter**

- If `energy` param provided: use it and set the `energy` frontmatter property on today's daily note via `obsidian property:set name="energy" value="<level>"`.
- If not provided: check today's daily note via `obsidian daily:read`. If it exists, read energy via `obsidian property:read name="energy"`. If empty or no daily note exists, tell user to open today's daily note in Obsidian first, then re-run `/session start`.

**Step 2 — Get tasks**

Check if `TODO.md` exists in current directory.
- Exists: read "In Progress". If empty, take top item from "Up Next".
- Doesn't exist: ask "What are you working on today?" and use the answer.

**Step 3 — Break tasks into pomodoro-sized subtasks**

Break each task into concrete single-pomodoro subtasks. One specific thing per subtask.

Pomodoro duration by energy:
- Low: 20 min
- Medium: 25 min
- High: 35 min

Realistic estimates (account for ramp-up, walls, reading docs):
- Simple (single file, config, docs): 1 pomodoro
- Medium (new feature following existing pattern): 2 pomodoros
- Complex (new pattern, unfamiliar territory): 3 pomodoros

**Step 4 — Update TODO.md**

Replace parent tasks with their subtasks in "In Progress". Create TODO.md if it doesn't exist.

**Step 5 — Build and display the plan**

Fit pomodoros within available time. Reserve 10 min buffer before hard stop.

```
Session Plan
─────────────────────────────
Energy: low | Stop: 8:30pm | ~58min available

Pomodoro 1 — 20 min  → Add Area storage interface
Break      —  5 min
Pomodoro 2 — 20 min  → Add Project storage interface
Break      —  5 min
─────────────────────────────
Ends ~8:22pm. 8 min buffer before stop.
```

Ask: "Start this plan? (yes / adjust)"

**Step 6 — Start the session**

If yes:
1. Write `~/.claude/temp/session.json` with `current_pomodoro: 0`
2. Launch timer for pomodoro 0 (see Timer Script section above)
3. Confirm started. Show first task.

**IMPORTANT: Never tell the user to take a break.** The timer handles that. Claude's job during a pomodoro is to assist with work. Only `/session next` or `/session extend` (triggered by the user after the timer fires) should advance the session state.

---

### `/session next`

User is back from break. Current task is done.

1. Read session.json
2. Mark current pomodoro `done: true`
3. Increment `current_pomodoro`
4. Check if any pomodoros remain:
   - If yes: launch timer for next pomodoro. Tell user what the next task is.
   - If no: tell user all pomodoros complete. Ask if they want to end the session or add more time.
5. Update session.json

---

### `/session extend`

User is back from break. Current task is NOT done. Re-plan remaining time.

1. Read session.json
2. Increment `extend_streak` by 1
3. If `extend_streak` >= 3:
   - Stop. Do not launch another pomodoro.
   - Say: "You've extended [task] 3 times. Sounds like you might be blocked. What's getting in the way?"
   - Listen to the response. Help them either:
     a. Break the task down further into something smaller and more concrete
     b. Identify what they need (docs, a decision, help from someone) before they can proceed
     c. Move the task to Blocked in TODO.md and move on to the next task
   - If moved to Blocked: add a "## Blocked" section to TODO.md, move task there with a note about why
   - Resume session with next task if one exists, or end session
4. If `extend_streak` < 3:
   - Run `date`. Calculate minutes remaining until stop.
   - Keep current task — add another pomodoro for it at the front of the remaining plan
   - Trim plan to fit remaining time (keep 10 min buffer)
   - Show updated plan
   - Update session.json
   - Launch timer for the extended pomodoro

---

### `/session status`

Read session.json. Show:
- Current task
- Current pomodoro number out of total
- Time remaining until stop

If no file — say no active session.

---

### `/session end`

1. `kill $(cat ~/.claude/temp/session-timer.pid) 2>/dev/null`
2. Ask what actually got done
3. Update TODO.md — move completed subtasks to Done, leave unfinished in In Progress
4. Ask: "Blocked on anything?"
   - If yes: ask which task and why. Add a "## Blocked" section to TODO.md if it doesn't exist. Move the task there with a one-line note about the blocker.
   - If no: skip
5. Append completed tasks to today's daily note via `obsidian daily:append`
6. Set `struggled` property on today's daily: `true` if any task hit extend_streak >= 2, `false` otherwise.
   - Get path first: `obsidian daily:path`
   - Set property: `obsidian property:set name="struggled" value="<true|false>" path="<daily-path>"`
7. `rm -f ~/.claude/temp/session.json ~/.claude/temp/session-timer.sh ~/.claude/temp/session-timer.pid`
8. Confirm session ended

---

## Timer script generation

When launching a timer for a pomodoro, generate and run this script:

```
mkdir -p ~/.claude/temp

Write ~/.claude/temp/session-timer.sh as a bash script that:
1. Reads the current pomodoro from session.json using python3
2. Sleeps for duration * 60 seconds
3. Sends notification: "Break time! [break]min — done with [task]? Run /session next or /session extend"
4. Exits

Notification logic:
- Mac: osascript -e 'display notification "MSG" with title "Session" sound name "default"'
- Linux: notify-send "Session" "MSG"
- Fallback: printf '\033]9;MSG\033\\' > /dev/tty

chmod +x the script, run with nohup in background, save PID to ~/.claude/temp/session-timer.pid
```
