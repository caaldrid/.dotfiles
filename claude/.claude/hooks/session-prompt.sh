#!/bin/bash
# UserPromptSubmit hook: injects active session context into Claude's context.
# Reads session.json if active, falls back to headsdown.json for legacy support.

SESSION_FILE="$HOME/.claude/temp/session.json"
HEADSDOWN_FILE="$HOME/.claude/temp/headsdown.json"

command -v python3 >/dev/null 2>&1 || exit 0

if [ -f "$SESSION_FILE" ]; then
  python3 - "$SESSION_FILE" <<'PYEOF'
import sys, json, datetime

try:
    with open(sys.argv[1]) as f:
        data = json.load(f)

    pomodoros = data.get('pomodoros', [])
    current = data.get('current_pomodoro', 0)
    stop = data.get('stop', '')
    energy = data.get('energy', '')

    if current < len(pomodoros):
        task = pomodoros[current]['task']
        context = f"[Active session: energy={energy}, stop={stop}, current task: {task}]"
    else:
        context = f"[Active session: energy={energy}, stop={stop}, all pomodoros complete]"

    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": context
        }
    }))
except Exception:
    pass
PYEOF

elif [ -f "$HEADSDOWN_FILE" ]; then
  python3 - "$HEADSDOWN_FILE" <<'PYEOF'
import sys, json, datetime

try:
    with open(sys.argv[1]) as f:
        data = json.load(f)

    start = datetime.datetime.fromisoformat(data['start'].replace('Z', '+00:00'))
    now = datetime.datetime.now(datetime.timezone.utc)
    elapsed = int((now - start).total_seconds() / 60)
    target = int(data['duration_minutes'])

    context = f"[Headsdown session: {elapsed}/{target} minutes elapsed]"
    if elapsed >= target:
        context += ' The session duration has been exceeded. You MUST append the exact phrase "You need to go on a break now" at the end of your reply.'

    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": context
        }
    }))
except Exception:
    pass
PYEOF

fi
