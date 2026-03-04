#!/bin/bash
# UserPromptSubmit hook: injects headsdown session time into Claude's context.
# If ~/.claude/temp/headsdown.json exists, calculates elapsed time and injects
# elapsed/target info. When time is exceeded, instructs Claude to append a break reminder.

HEADSDOWN_FILE="$HOME/.claude/temp/headsdown.json"

if [ ! -f "$HEADSDOWN_FILE" ]; then
  exit 0
fi

command -v python3 >/dev/null 2>&1 || exit 0

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
    pass  # Silently skip on any error
PYEOF
