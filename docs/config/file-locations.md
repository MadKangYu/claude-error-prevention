# Configuration File Locations

> Official file locations for Claude Code, Crush, OpenCode, and OpenClaw.
> Source: code.claude.com/docs/en/settings

---

## Claude Code

### Configuration Scopes

| Scope | Location | Who it affects | Shared? |
|-------|----------|----------------|---------|
| **Managed** | System-level `managed-settings.json` | All users on machine | Yes (IT deployed) |
| **User** | `~/.claude/` directory | You, across all projects | No |
| **Project** | `.claude/` in repository | All collaborators | Yes (git) |
| **Local** | `.claude/*.local.*` files | You, in this repo only | No (gitignored) |

### File Locations

| File | Purpose | Scope |
|------|---------|-------|
| `~/.claude/settings.json` | User settings | User |
| `~/.claude/CLAUDE.md` | Global memory/instructions | User |
| `~/.claude/skills/` | User skills directory | User |
| `~/.claude/agents/` | User subagents | User |
| `~/.claude/rules/` | User rules (imports) | User |
| `~/.claude/hooks/` | User hooks | User |
| `~/.claude/keybindings.json` | Keyboard shortcuts | User |
| `~/.claude.json` | OAuth, theme, MCP servers | User |
| `.claude/settings.json` | Project settings | Project |
| `.claude/settings.local.json` | Local project settings | Local |
| `.claude/agents/` | Project subagents | Project |
| `.mcp.json` | Project MCP servers | Project |
| `CLAUDE.md` | Project memory | Project |
| `CLAUDE.local.md` | Local memory | Local |

### Managed Settings (Enterprise)

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/` |
| Linux/WSL | `/etc/claude-code/` |
| Windows | `C:\Program Files\ClaudeCode\` |

---

## Crush (Charmbracelet)

| Priority | Path |
|----------|------|
| 1 | `.crush.json` (project) |
| 2 | `crush.json` (project) |
| 3 | `~/.config/crush/crush.json` (Unix global) |
| 4 | `%LOCALAPPDATA%\crush\crush.json` (Windows) |

### Additional Locations

| File | Purpose |
|------|---------|
| `.crushignore` | Files to ignore (like .gitignore) |
| `~/.config/crush/skills/` | Skills directory |
| `.crush/logs/crush.log` | Log files |

---

## OpenCode (anomalyco)

| Priority | Path |
|----------|------|
| 1 | `.opencode.json` (project) |
| 2 | `~/.config/opencode/opencode.json` (global) |

---

## OpenClaw

| File | Purpose |
|------|---------|
| `~/.openclaw/openclaw.json` | Main config |
| `~/.openclaw/agents/` | Agent configurations |
| `~/.openclaw/auth-profiles.json` | Authentication profiles (optional) |
| `~/Library/LaunchAgents/ai.openclaw.gateway.plist` | macOS service |

---

## QMD

| File | Purpose |
|------|---------|
| `~/.qmd/config.json` | Main config |
| `~/.qmd/collections/` | Collection data |
| `~/.cache/qmd/models/` | GGUF models |

---

## Verification Commands

```bash
# Claude Code
ls -la ~/.claude/
cat ~/.claude/settings.json | jq .
claude doctor

# Crush
ls -la ~/.config/crush/
cat ~/.config/crush/crush.json | jq .

# OpenClaw
ls -la ~/.openclaw/
cat ~/.openclaw/openclaw.json | jq .

# QMD
qmd status
qmd collection list
```

---

*Last updated: 2026-02-07*
*Source: code.claude.com/docs/en/settings*
