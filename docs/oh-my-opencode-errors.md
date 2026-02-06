# Oh My OpenCode Error Patterns & Troubleshooting

> Official error patterns and solutions for Oh My OpenCode plugin

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗                                   ║
║  ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝                                   ║
║  ██║   ██║███████║    ██╔████╔██║ ╚████╔╝                                    ║
║  ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝                                     ║
║  ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║                                      ║
║   ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝                                      ║
║    ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗       ║
║   ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝       ║
║   ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║     ██║   ██║██║  ██║█████╗         ║
║   ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║     ██║   ██║██║  ██║██╔══╝         ║
║   ╚██████╔╝██║     ███████╗██║ ╚████║╚██████╗╚██████╔╝██████╔╝███████╗       ║
║    ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝       ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 10 | Source: Official GitHub     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| Repository | https://github.com/code-yeongyu/oh-my-opencode |
| Installation | https://github.com/code-yeongyu/oh-my-opencode/blob/master/docs/guide/installation.md |
| Configuration | https://github.com/code-yeongyu/oh-my-opencode/blob/master/docs/configurations.md |
| Features | https://github.com/code-yeongyu/oh-my-opencode/blob/master/docs/features.md |
| Contributing | https://github.com/code-yeongyu/oh-my-opencode/blob/master/CONTRIBUTING.md |
| Discord | https://discord.gg/PUwSMR9XNk |

> **⚠️ SECURITY WARNING:** `ohmyopencode.com` is NOT affiliated with this project.
> Only download from official GitHub releases.

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        OH MY OPENCODE QUICK FIX                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "JSON Parse error: EOF"          │ Set stream: false for Ollama             │
│  "Config parsing failed"          │ Upgrade OpenCode to 1.0.150+             │
│  Plugin not loaded                │ bunx oh-my-opencode install              │
│  "No AGENTS.md found"             │ Run /init-deep                           │
│  "Context window exceeded"        │ Enable auto_resume in config             │
│  "No binary for darwin-arm64"     │ npx playwright install chromium          │
│  Category model not applied       │ Add category to config explicitly        │
│  UI reload failed                 │ Check OpenCode version compatibility     │
│  LSP tools blocked (Windows)      │ Known issue with embedded Bun            │
│  Tmux agents not visible          │ Run with --port flag                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                       OH MY OPENCODE ARCHITECTURE                            │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                            OPENCODE CLI                                 │ │
│  │                                                                        │ │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │ │
│  │  │                     OH MY OPENCODE PLUGIN                        │  │ │
│  │  │                                                                  │  │ │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │  │ │
│  │  │  │ Sisyphus │  │ Oracle   │  │Librarian │  │ Explore  │        │  │ │
│  │  │  │  (Main)  │  │ (Debug)  │  │  (Docs)  │  │ (Search) │        │  │ │
│  │  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘        │  │ │
│  │  │       │             │             │             │               │  │ │
│  │  │       └─────────────┴──────┬──────┴─────────────┘               │  │ │
│  │  │                            │                                    │  │ │
│  │  │  ┌─────────────────────────┼─────────────────────────────────┐ │  │ │
│  │  │  │                    AGENT SYSTEM                            │ │  │ │
│  │  │  │  • Background tasks  • Session management  • Concurrency  │ │  │ │
│  │  │  └────────────────────────────────────────────────────────────┘ │  │ │
│  │  │                                                                  │  │ │
│  │  │  ┌─────────────────────────────────────────────────────────────┐│  │ │
│  │  │  │  Skills   │  Hooks (25+)  │  Commands  │  MCPs (builtin)   ││  │ │
│  │  │  └─────────────────────────────────────────────────────────────┘│  │ │
│  │  └──────────────────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Installation

### Quick Install
```bash
bunx oh-my-opencode install   # recommended
npx oh-my-opencode install    # alternative
```

### Non-Interactive (CI/Agents)
```bash
bunx oh-my-opencode install --no-tui \
  --claude=max20 \
  --openai=yes \
  --gemini=yes \
  --copilot=no \
  --opencode-zen=no \
  --zai-coding-plan=no
```

### Verify Installation
```bash
opencode --version  # Should be 1.0.150+
cat ~/.config/opencode/opencode.json | jq '.plugin'
# Should include "oh-my-opencode"
```

### Uninstall
```bash
jq '.plugin = [.plugin[] | select(. != "oh-my-opencode")]' \
    ~/.config/opencode/opencode.json > /tmp/oc.json && \
    mv /tmp/oc.json ~/.config/opencode/opencode.json

# Optional: Remove config files
rm -f ~/.config/opencode/oh-my-opencode.json
rm -f .opencode/oh-my-opencode.json
```

---

## Configuration

### File Locations (Priority Order)

| Priority | Path | Scope |
|----------|------|-------|
| 1 | `.opencode/oh-my-opencode.json` | Project |
| 2 | `~/.config/opencode/oh-my-opencode.json` | User |

**JSONC supported** - Comments and trailing commas allowed.
`.jsonc` files take priority over `.json`.

### Schema Autocomplete
```json
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"
}
```

### Complete Example
```jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  
  // Agent configuration
  "agents": {
    "oracle": {
      "model": "openai/gpt-5.2",
      "temperature": 0.3,
      "thinking": {
        "type": "enabled",
        "budgetTokens": 200000
      }
    },
    "explore": {
      "model": "anthropic/claude-haiku-4-5",
      "stream": false  // Required for Ollama
    },
    "multimodal-looker": {
      "disable": true
    }
  },
  
  // Category configuration (CRITICAL)
  "categories": {
    "visual-engineering": { "model": "google/gemini-3-pro-preview" },
    "ultrabrain": { "model": "openai/gpt-5.3-codex", "variant": "xhigh" },
    "quick": { "model": "anthropic/claude-haiku-4-5" },
    "unspecified-low": { "model": "anthropic/claude-sonnet-4-5" },
    "unspecified-high": { "model": "anthropic/claude-opus-4-6", "variant": "max" }
  },
  
  // Background task concurrency
  "background_task": {
    "defaultConcurrency": 5,
    "staleTimeoutMs": 180000,
    "providerConcurrency": {
      "anthropic": 3,
      "openai": 5,
      "google": 10
    }
  },
  
  // Tmux integration
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",
    "main_pane_size": 60
  },
  
  // Disable specific hooks
  "disabled_hooks": [
    "comment-checker",
    "auto-update-checker"
  ]
}
```

---

## Built-in Agents

| Agent | Purpose | Default Model |
|-------|---------|---------------|
| **Sisyphus** | Main orchestrator with extended thinking | (configurable) |
| **Hephaestus** | Autonomous deep worker | (configurable) |
| **oracle** | Architecture decisions, code review, debugging | (configurable) |
| **librarian** | Multi-repo analysis, official docs, OSS examples | (configurable) |
| **explore** | Fast codebase exploration, contextual grep | (configurable) |
| **multimodal-looker** | Visual content analysis (PDFs, images) | (configurable) |
| **Prometheus** | Strategic planner with interview mode | (configurable) |
| **Metis** | Pre-planning consultant (hidden requirements) | (configurable) |
| **Momus** | Plan reviewer (clarity, verifiability) | (configurable) |

> Models are configured in `oh-my-opencode.json`. See Configuration section above.

**Invoking Agents:**
```
Ask @oracle to review this design
Ask @librarian how this is implemented
Ask @explore for the policy on this feature
```

---

## Error Patterns

### 1. Ollama JSON Parse Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: JSON Parse error: Unexpected EOF                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Ollama returns NDJSON when streaming enabled, but SDK expects single JSON.

**Solution:**
```json
{
  "agents": {
    "explore": {
      "model": "ollama/qwen3-coder",
      "stream": false
    }
  }
}
```

---

### 2. OpenCode Version Too Old

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Config parsing failed                                                       │
│  Or: Plugin initialization error                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** OpenCode < 1.0.150 has config bugs fixed in [PR #5040](https://github.com/sst/opencode/pull/5040)

**Solution:**
```bash
opencode --version  # Check version

# Upgrade OpenCode
curl -fsSL https://opencode.ai/install | bash
```

---

### 3. Plugin Not Loaded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  No oh-my-opencode features available                                        │
│  Agents not responding                                                       │
│  Commands like /init-deep not found                                          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Check:**
```bash
cat ~/.config/opencode/opencode.json | jq '.plugin'
```

**Solution:**
```bash
bunx oh-my-opencode install
```

---

### 4. Category Model Not Applied

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  delegate_task(category="visual-engineering") uses wrong model               │
│  Category configuration appears to be ignored                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Categories DO NOT use built-in defaults unless explicitly configured.

**Model Resolution Priority:**
1. User-configured model (in oh-my-opencode.json)
2. Category's built-in default (if added to config)
3. System default model (from opencode.json)

**Solution:** Explicitly configure categories:
```json
{
  "categories": {
    "visual-engineering": { "model": "google/gemini-3-pro-preview" },
    "ultrabrain": { "model": "openai/gpt-5.3-codex" },
    "quick": { "model": "anthropic/claude-haiku-4-5" }
  }
}
```

---

### 5. Context Window Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Context window exceeded                                                     │
│  Maximum tokens: 200000, Current: 245000                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```json
{
  "experimental": {
    "auto_resume": true,
    "aggressive_truncation": true
  }
}
```

---

### 6. Agent-Browser / Playwright Installation Failure

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  No binary found for darwin-arm64                                            │
│  browserType.launch: Executable doesn't exist                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
npx playwright install chromium
```

---

### 7. Tmux Integration Not Working

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Background agents not visible in separate panes                             │
│  Tmux layout not applied                                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Requirements:**
1. Must run inside tmux session
2. OpenCode must run with `--port` flag (server mode)

**Solution:**
```bash
# Run OpenCode with port flag inside tmux
tmux new-session -s dev "opencode --port 4096"
```

**Config:**
```json
{
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",
    "main_pane_size": 60,
    "main_pane_min_width": 120,
    "agent_pane_min_width": 40
  }
}
```

---

### 8. UI Reload Failed (OpenCode 1.1.53+)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Failed to reload ui                                                         │
│  Plugin crashes OpenCode                                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Status:** Known issue [#1559](https://github.com/code-yeongyu/oh-my-opencode/issues/1559)

**Workaround:**
```bash
# Use previous stable version
bunx oh-my-opencode@3.1.6 install
```

---

### 9. LSP Tools Blocked (Windows)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  LSP tools blocked                                                           │
│  Embedded Bun 1.3.5 compatibility issue                                      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Status:** Known issue [#1558](https://github.com/code-yeongyu/oh-my-opencode/issues/1558)

**Workaround:** Use WSL or wait for fix.

---

### 10. /init-deep Command Fails

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  /init-deep command fails on opus-4.6 model                                  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Status:** Known issue [#1566](https://github.com/code-yeongyu/oh-my-opencode/issues/1566)

**Workaround:** Try with different model or create AGENTS.md manually.

---

## Skills

### Locations
```
.opencode/skills/*/SKILL.md           # Project
~/.config/opencode/skills/*/SKILL.md  # User
.claude/skills/*/SKILL.md             # Claude Code compat
~/.claude/skills/*/SKILL.md           # Claude Code user
```

### Built-in Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| **playwright** | Browser tasks | Browser automation via Playwright MCP |
| **frontend-ui-ux** | UI/UX tasks | Designer-turned-developer persona |
| **git-master** | Git operations | Atomic commits, rebase/squash, history search |

### Disable Skills
```json
{
  "disabled_skills": ["playwright"]
}
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/init-deep` | Initialize hierarchical AGENTS.md knowledge base |
| `/ralph-loop` | Self-referential development loop until completion |
| `/ulw-loop` | Ultrawork loop with maximum performance |
| `/cancel-ralph` | Cancel active Ralph Loop |
| `/refactor` | Intelligent refactoring with LSP, AST-grep, TDD |
| `/start-work` | Start Sisyphus work session from Prometheus plan |

---

## Magic Keywords

| Keyword | Effect |
|---------|--------|
| `ultrawork` / `ulw` | Maximum performance mode |
| `search` / `find` | Parallel exploration |
| `analyze` / `investigate` | Deep analysis mode |
| `ultrathink` / `think deeply` | Extended thinking |

---

## Verification Commands

```bash
# Version
opencode --version

# Plugin status
cat ~/.config/opencode/opencode.json | jq '.plugin'

# Config validation
bunx oh-my-opencode doctor --verbose

# AGENTS.md check
ls -la ./AGENTS.md

# Check hooks
cat ~/.config/opencode/oh-my-opencode.json | jq '.disabled_hooks'
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [OpenCode Errors](./opencode-errors.md) | OpenCode/Crush CLI |
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI |
| [Ghostty Errors](./ghostty-errors.md) | Terminal emulator |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Complete rewrite with official docs, 10 patterns |
| 2.6 | 2024-02-06 | Initial patterns |

---

*Last updated: 2026-02-07 | Source: github.com/code-yeongyu/oh-my-opencode*
*Maintainer: claude-error-prevention | License: MIT*
