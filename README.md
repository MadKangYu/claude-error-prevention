<p align="center">
  <img src="https://img.shields.io/badge/patterns-62-blue?style=for-the-badge" alt="Patterns">
  <img src="https://img.shields.io/badge/auto--fix-40+-green?style=for-the-badge" alt="Auto-fix">
  <img src="https://img.shields.io/badge/version-2.4-orange?style=for-the-badge" alt="Version">
</p>

# AI Agent Error Prevention

> Systematic error detection, diagnosis, and auto-resolution for AI coding agents.

```bash
git clone https://github.com/MadKangYu/claude-error-prevention.git
./claude-error-prevention/src/error-engine.sh heal
```

---

## Why This Exists

AI coding agents fail silently. Duplicate installations, wrong config paths, deprecated packages, invalid JSON—these issues waste hours. This tool finds and fixes them automatically.

---

## Quick Start

```bash
# One command does everything
./src/error-engine.sh heal
```

**What `heal` does:**
1. Detects your environment (Claude, Crush, OpenClaw, etc.)
2. Initializes missing configs
3. Scans for 62 known error patterns
4. Auto-fixes what it can
5. Reports what needs manual attention

---

## Commands

| Command | Description |
|---------|-------------|
| `heal` | Full auto: detect → init → fix → verify |
| `scan` | Find all errors |
| `search <keyword>` | Find specific error |
| `fix <id>` | Fix one error |
| `fix-all` | Fix all auto-fixable |
| `scope` | Show detected tools |
| `doctor` | Run health checks |
| `list` | List all patterns |

---

## Supported Tools

| Tool | Patterns | Auto-Fix |
|------|----------|----------|
| Claude Code | 10 | 8 |
| Crush (OpenCode) | 5 | 3 |
| OpenClaw + Telegram | 6 | 3 |
| Obsidian + QMD | 4 | 2 |
| System (npm, git, ssh) | 20 | 15 |
| Server/Network | 8 | 2 |
| Quota/Limits | 5 | 1 |
| Korean Errors | 4 | 0 |

---

## Pattern Categories

```
claude-*          Installation, config, MCP, JSON
opencode-*        Migration to Crush, providers
openclaw-*        Gateway, Telegram bots, security
obsidian-*        Vault, QMD indexing, sync
server-*          Connection, timeout, SSL
quota-*           Rate limits, context, daily
install-*         Permissions, dependencies
patch-*           Git conflicts, uncommitted
beginner-*        sudo npm, .env in git
korean-*          Ambiguous commands, implicit intent
```

---

## Examples

### Search for errors
```bash
./error-engine.sh search "mcp"
./error-engine.sh search "duplicate"
./error-engine.sh search "quota"
```

### Check specific scope
```bash
./error-engine.sh scope claude
./error-engine.sh scope openclaw
```

### Fix specific error
```bash
./error-engine.sh fix claude-duplicate-install
```

---

## Korean User Support

Common Korean commands that cause errors:

| Korean | Risk | Meaning |
|--------|------|---------|
| 정리해 | ⚠️ | Delete or organize? |
| 지워 | 🔴 | Which file? Confirm first |
| 다 바꿔 | 🔴 | Scope unclear |
| 안돼 | ℹ️ | Expects full fix, not diagnosis |

See [`docs/korean-errors.md`](docs/korean-errors.md) for full guide.

---

## Auto-Update

### Local (cron)
```bash
crontab -e
# Add:
0 9 * * * ~/claude-error-prevention/scripts/daily-update.sh
```

### GitHub Action
Runs daily at midnight UTC. See `.github/workflows/daily-check.yml`.

---

## File Structure

```
├── src/error-engine.sh       # Main engine
├── patterns/
│   └── error-patterns.json   # 62 patterns
├── docs/
│   ├── installation.md       # Official install guides
│   ├── glossary.md           # Korean→English terms
│   ├── korean-errors.md      # Korean-specific errors
│   └── scope-guide.md        # Universal vs personal
└── scripts/
    └── daily-update.sh       # Cron script
```

---

## Requirements

- `bash` 3.2+
- `jq` (JSON processor)
- `curl`

```bash
brew install jq  # macOS
apt install jq   # Linux
```

---

## Sources

All patterns verified against official documentation:

- [Claude Code](https://github.com/anthropics/claude-code)
- [Crush](https://github.com/charmbracelet/crush)
- [QMD](https://github.com/tobi/qmd)
- [Oh My OpenCode](https://github.com/code-yeongyu/oh-my-opencode)

---

## License

MIT

---

<p align="center">
  <strong>62 patterns · 40+ auto-fixes · Zero configuration</strong>
</p>
