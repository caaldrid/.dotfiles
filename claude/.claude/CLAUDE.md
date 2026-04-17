# Global Claude Instructions

## Obsidian Integration

Before using any `obsidian` CLI commands, check that the CLI is available:

```bash
which obsidian
```

Only proceed with obsidian CLI calls if it passes. If it fails, skip all obsidian-related steps silently — do not warn or mention it unless the user asks.

When available:
- Vault: **metalbrain** — get path dynamically with `obsidian vault info=path`
- Daily note commands: `obsidian daily:read`, `obsidian daily:append`, `obsidian daily:path`
- Project docs live in `docs/` inside the repo — read them for context when starting work
- Architecture decisions (ADRs) go in `docs/designs/decisions/` — create them there, not inline in CLAUDE.md files
- When creating new ADRs, design docs, or investigation notes, use `obsidian templater:create-from-template` so Templater fills frontmatter. Templates are in `Resources/Templates/Project/` (adr.md, design.md, investigation.md)
