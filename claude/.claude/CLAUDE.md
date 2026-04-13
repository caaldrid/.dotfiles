# Global Claude Instructions

## Obsidian Integration

Before using any `obsidian` CLI commands, check both conditions:

```bash
# 1. CLI available?
which obsidian

# 2. .brain symlink exists in current repo?
test -d .brain
```

Only proceed with obsidian CLI calls if **both** pass. If either fails, skip all obsidian-related steps silently — do not warn or mention it unless the user asks.

When both pass:
- Vault: **metalbrain** — get path dynamically with `obsidian vault info=path`
- Daily note commands: `obsidian daily:read`, `obsidian daily:append`, `obsidian daily:path`
- Project docs live in `.brain/` — read them for context when starting work
