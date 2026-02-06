# Claude Code Configuration Structure

> Official ~/.claude/ directory structure based on Claude Code documentation
> Source: https://code.claude.com/docs/en/settings.md, memory.md, keybindings.md, hooks.md, sub-agents.md, skills.md

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗                              ║
║  ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝                              ║
║  ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗                             ║
║  ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║                             ║
║  ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝                             ║
║   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝                              ║
║              ███████╗████████╗██████╗ ██╗   ██╗ ██████╗████████╗            ║
║              ██╔════╝╚══██╔══╝██╔══██╗██║   ██║██╔════╝╚══██╔══╝            ║
║              ███████╗   ██║   ██████╔╝██║   ██║██║        ██║               ║
║              ╚════██║   ██║   ██╔══██╗██║   ██║██║        ██║               ║
║              ███████║   ██║   ██║  ██║╚██████╔╝╚██████╗   ██║               ║
║              ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝               ║
║                                                                              ║
║   Error Prevention System v3.2 | Category: Configuration                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## Official Directory Structure

```
~/.claude/
├── CLAUDE.md                    # User memory (global preferences)
├── settings.json                # User settings
├── settings.local.json          # Local overrides (gitignored)
├── keybindings.json             # Custom keyboard shortcuts
├── rules/                       # User-level rules (*.md)
│   └── *.md                     # Auto-loaded as user rules
├── agents/                      # User subagents
│   └── *.md                     # Custom subagent definitions
├── skills/                      # User skills
│   └── <skill-name>/
│       └── SKILL.md             # Skill definition
├── commands/                    # Legacy commands (deprecated, use skills)
│   └── *.md
├── plugins/                     # Installed plugins
│   ├── installed_plugins.json
│   └── cache/
├── hooks/                       # Hook scripts
│   └── *.sh                     # Hook implementations
├── agent-memory/                # Subagent persistent memory
│   └── <agent-name>/
│       └── MEMORY.md
└── ... (cache, history, etc.)

~/.claude.json                   # OAuth, MCP servers, theme, preferences
```

---

## Configuration Files Reference

### 1. CLAUDE.md (User Memory)

**Location:** `~/.claude/CLAUDE.md`

**Purpose:** Personal preferences for all projects

**Features:**
- `@import` syntax for including other files
- Max depth: 5 hops for recursive imports
- Relative/absolute paths supported

**Example:**
```markdown
# User Memory

## Preferences
- Korean language preferred
- Verify with GitHub raw, not WebFetch

## Imports
- @~/.claude/rules/common-errors.md
- @~/.claude/rules/installation.md
```

---

### 2. settings.json (User Settings)

**Location:** `~/.claude/settings.json`

**Schema:** `https://json.schemastore.org/claude-code-settings.json`

**Key Settings:**

| Setting | Description | Example |
|---------|-------------|---------|
| `$schema` | JSON schema for validation | `"https://json.schemastore.org/..."` |
| `permissions.allow` | Allowed tool patterns | `["Bash(*)", "Read(*)"]` |
| `permissions.deny` | Denied file patterns | `["Read(./.env)"]` |
| `model` | Default model | `"claude-opus-4-5-20251101"` |
| `language` | Response language | `"korean"` |
| `cleanupPeriodDays` | Session cleanup period | `30` |
| `showTurnDuration` | Show response time | `true` |
| `autoUpdatesChannel` | Update channel | `"stable"` or `"latest"` |
| `hooks` | Lifecycle hooks | See hooks section |

**Example:**
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(*)", "Read(*)", "Write(*)", "Edit(*)"],
    "deny": ["Read(./.env)", "Read(./secrets/**)"]
  },
  "model": "claude-opus-4-5-20251101",
  "language": "korean",
  "cleanupPeriodDays": 30,
  "autoUpdatesChannel": "stable"
}
```

---

### 3. keybindings.json

**Location:** `~/.claude/keybindings.json`

**Schema:** `https://www.schemastore.org/claude-code-keybindings.json`

**Contexts:**
- `Global` - Everywhere
- `Chat` - Main input
- `Autocomplete` - Completion menu
- `Confirmation` - Permission dialogs

**Example:**
```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor"
      }
    }
  ]
}
```

---

### 4. rules/*.md (User Rules)

**Location:** `~/.claude/rules/`

**Behavior:**
- All `.md` files auto-loaded as user-level rules
- Lower priority than project rules
- Supports symlinks

**Path-specific rules (optional):**
```yaml
---
paths:
  - "src/api/**/*.ts"
---

# API Rules
- All endpoints must include validation
```

---

### 5. agents/*.md (Subagents)

**Location:** `~/.claude/agents/`

**Structure:**
```yaml
---
name: code-reviewer
description: Reviews code for quality
tools: Read, Grep, Glob
model: sonnet
---

You are a code reviewer...
```

**Fields:**
| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier |
| `description` | Yes | When to use |
| `tools` | No | Allowed tools |
| `model` | No | Model to use |
| `permissionMode` | No | Permission level |
| `memory` | No | Persistent memory scope |

---

### 6. skills/<name>/SKILL.md

**Location:** `~/.claude/skills/<skill-name>/SKILL.md`

**Structure:**
```yaml
---
name: my-skill
description: What this skill does
disable-model-invocation: true
allowed-tools: Read, Grep
---

Skill instructions...
```

**Fields:**
| Field | Description |
|-------|-------------|
| `name` | Skill name (becomes /slash-command) |
| `description` | When to use |
| `disable-model-invocation` | User-only invocation |
| `user-invocable` | Show in /menu |
| `allowed-tools` | Tools without permission |
| `context` | `fork` for subagent execution |

---

### 7. hooks/ (Hook Scripts)

**Location:** `~/.claude/hooks/`

**Configure in:** `settings.json`

**Events:**
| Event | When |
|-------|------|
| `SessionStart` | Session begins |
| `UserPromptSubmit` | Prompt submitted |
| `PreToolUse` | Before tool execution |
| `PostToolUse` | After tool execution |
| `Stop` | Response complete |
| `SessionEnd` | Session ends |

**Example settings.json hooks:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/validate-bash.sh"
          }
        ]
      }
    ]
  }
}
```

---

### 8. agent-memory/<name>/

**Location:** `~/.claude/agent-memory/<agent-name>/`

**Purpose:** Persistent memory for subagents across sessions

**Usage:** Set `memory: user` in agent frontmatter

---

### 9. ~/.claude.json (Global Config)

**Location:** `~/.claude.json` (NOT inside ~/.claude/)

**Contains:**
- OAuth session
- MCP server configurations
- Theme preferences
- Notification settings
- Per-project state

---

## Common Configuration Errors

| Error | Problem | Fix |
|-------|---------|-----|
| `~/.mcp.json` | Deprecated path | Use `~/.claude/claude_code_config.json` |
| `~/.config/claude/` | Wrong path | Use `~/.claude/` |
| Import not loading | File doesn't exist | Check `@import` paths |
| Rules not applying | Wrong directory | Use `~/.claude/rules/` |
| Hooks not running | Missing executable | `chmod +x script.sh` |

---

## Scope Precedence

| Scope | Location | Priority |
|-------|----------|----------|
| Managed | System-level | 1 (highest) |
| CLI args | Command line | 2 |
| Local | `.claude/settings.local.json` | 3 |
| Project | `.claude/settings.json` | 4 |
| User | `~/.claude/settings.json` | 5 (lowest) |

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Memory](https://code.claude.com/docs/en/memory.md) | CLAUDE.md and rules |
| [Settings](https://code.claude.com/docs/en/settings.md) | settings.json |
| [Keybindings](https://code.claude.com/docs/en/keybindings.md) | Keyboard shortcuts |
| [Hooks](https://code.claude.com/docs/en/hooks.md) | Lifecycle automation |
| [Subagents](https://code.claude.com/docs/en/sub-agents.md) | Custom agents |
| [Skills](https://code.claude.com/docs/en/skills.md) | Custom commands |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.2 | 2026-02-07 | Initial structure documentation |

---

*Last updated: 2026-02-07 | Maintainer: claude-error-prevention*
