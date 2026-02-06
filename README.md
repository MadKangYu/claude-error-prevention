<p align="center">
  <img src="https://img.shields.io/badge/patterns-67-blue?style=for-the-badge" alt="Patterns">
  <img src="https://img.shields.io/badge/auto--fix-45+-green?style=for-the-badge" alt="Auto-fix">
  <img src="https://img.shields.io/badge/version-2.6-orange?style=for-the-badge" alt="Version">
</p>

<h1 align="center">AI Agent Error Prevention</h1>

<p align="center">
  <strong>Systematic error detection, diagnosis, and auto-resolution for AI coding agents.</strong>
</p>

```
┌─────────────────────────────────────────────────────────────┐
│  $ ./error-engine.sh heal                                   │
│                                                             │
│  [OK] Scope: claude-code (v2.1.34)                          │
│  [OK] Scope: crush (v1.2.0)                                 │
│  [OK] Scope: obsidian                                       │
│                                                             │
│  Scanning 67 patterns...                                    │
│                                                             │
│  [FIX] claude-duplicate-install → removed npm version       │
│  [FIX] claude-settings-schema → added $schema               │
│  [OK] opencode-uint64-schema → safe to ignore               │
│                                                             │
│  ╔══════════════════════════════════════════════════════╗   │
│  ║  HEAL COMPLETE                                       ║   │
│  ║  Fixed: 2  |  Manual: 0  |  Healthy: 65              ║   │
│  ╚══════════════════════════════════════════════════════╝   │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Start

```bash
git clone https://github.com/MadKangYu/claude-error-prevention.git
cd claude-error-prevention
./src/error-engine.sh heal
```

---

## How It Works

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  DETECT  │ ──▶ │   SCAN   │ ──▶ │   FIX    │ ──▶ │  VERIFY  │
│  Scope   │     │ Patterns │     │  Auto    │     │  State   │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
     │                │                │                │
     ▼                ▼                ▼                ▼
  Claude           67 known        Backup +         Confirm
  Crush            error           Apply fix        success
  OpenClaw         patterns        or report        or rollback
  Obsidian                         manual
```

---

## Commands

| Command | Description |
|---------|-------------|
| `heal` | **Full auto:** detect → init → fix → verify |
| `scan` | Find all errors |
| `search <keyword>` | Find specific error |
| `fix <id>` | Fix one error |
| `fix-all` | Fix all auto-fixable |
| `scope` | Show detected tools |
| `doctor` | Run health checks |
| `list` | List all 67 patterns |

---

## Supported Tools

```
┌─────────────────────────────────────────────────────────────┐
│  SUPPORTED TOOLS                                            │
├─────────────────┬──────────┬────────────────────────────────┤
│  Claude Code    │ 10 patterns │ ████████████████████ 80%    │
│  Crush/OpenCode │  5 patterns │ ██████████████████   60%    │
│  OpenClaw       │  6 patterns │ ██████████           50%    │
│  Obsidian/QMD   │  4 patterns │ ██████████           50%    │
│  Oh My OpenCode │  5 patterns │ ████████████████     80%    │
│  System         │ 20 patterns │ ██████████████████   75%    │
│  Korean Errors  │  4 patterns │ ████                  0%    │
└─────────────────┴──────────┴────────────────────────────────┘
                               └── Auto-fix percentage
```

---

## Error Resolution Flow

```
     ┌─────────────────┐
     │  Error Detected │
     └────────┬────────┘
              ▼
     ┌─────────────────┐
     │  Pattern Match  │
     └────────┬────────┘
              ▼
        ┌─────┴─────┐
        ▼           ▼
   ┌────────┐  ┌────────┐
   │  Auto  │  │ Manual │
   │  Fix   │  │ Steps  │
   └───┬────┘  └────────┘
       ▼
   ┌────────┐
   │ Backup │
   └───┬────┘
       ▼
   ┌────────┐
   │ Apply  │
   └───┬────┘
       ▼
   ┌────────┐     ┌────────┐
   │ Verify │────▶│  Done  │
   └───┬────┘     └────────┘
       │ Fail
       ▼
   ┌────────┐
   │Rollback│
   └────────┘
```

---

## Examples

### Search for errors
```bash
$ ./error-engine.sh search "mcp"

[INFO] Searching for: mcp

[claude-code] mcp-server-crash
  Message: MCP server crashed or failed to start
  Fix: Check MCP config, verify command path exists

[claude-code] mcp-invalid-response  
  Message: MCP server returned invalid response
  Fix: Check MCP server logs, verify JSON output

[OK] Found 2 match(es)
```

### Check scope
```bash
$ ./error-engine.sh scope

[INFO] Detecting scope...

[OK] Scope: global
[OK] Scope: claude-code (v2.1.34)
[OK] Scope: crush (v1.2.0)
[OK] Scope: obsidian
[OK] Scope: iTerm2
[OK] Scope: Ghostty

Detected scopes: global claude crush obsidian iterm2 ghostty
```

---

## Pattern Categories

```
claude-*          ──▶  Installation, config, MCP, JSON
opencode-*        ──▶  Migration to Crush, providers  
openclaw-*        ──▶  Gateway, Telegram bots, security
obsidian-*        ──▶  Vault, QMD indexing, sync
oh-my-opencode-*  ──▶  Plugin, agents, Ollama
server-*          ──▶  Connection, timeout, SSL
quota-*           ──▶  Rate limits, context, daily
install-*         ──▶  Permissions, dependencies
patch-*           ──▶  Git conflicts, uncommitted
beginner-*        ──▶  sudo npm, .env in git
korean-*          ──▶  Ambiguous commands, implicit intent
```

---

## Korean User Support

Common commands that cause errors:

| Korean | Risk | Real Intent | AI Should |
|--------|------|-------------|-----------|
| 정리해 | ⚠️ HIGH | Organize OR Delete? | **ASK first** |
| 지워 | 🔴 DANGER | Which file exactly? | **CONFIRM target** |
| 다 바꿔 | 🔴 DANGER | Scope is unclear | **CLARIFY scope** |
| 안돼 | ℹ️ INFO | Wants FULL fix | Fix + Test + Verify |
| 확인해 | ℹ️ INFO | Wants action | Check + Fix if wrong |

📖 See [`docs/korean-errors.md`](docs/korean-errors.md) for full guide.

---

## Troubleshooting Flowchart

```
Start Here
    │
    ▼
┌─────────────────────────────────────┐
│ Run: ./error-engine.sh heal         │
└──────────────────┬──────────────────┘
                   ▼
         ┌─────────┴─────────┐
         │ Everything fixed? │
         └─────────┬─────────┘
              YES  │  NO
         ┌─────────┴─────────┐
         ▼                   ▼
    ┌────────┐     ┌──────────────────┐
    │  Done  │     │ Check error type │
    └────────┘     └────────┬─────────┘
                            │
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
   ┌──────────┐      ┌──────────┐      ┌──────────┐
   │ JSON err │      │ MCP err  │      │ Quota    │
   └────┬─────┘      └────┬─────┘      └────┬─────┘
        │                 │                 │
        ▼                 ▼                 ▼
   Validate at       Check path        Wait or
   jsonlint.com      in config         switch provider
```

---

## File Structure

```
claude-error-prevention/
├── src/
│   └── error-engine.sh       # Main engine (900+ lines)
├── lib/
│   ├── utils.sh              # Shared utilities
│   └── scope.sh              # Scope detection
├── patterns/
│   └── error-patterns.json   # 67 patterns
├── docs/
│   ├── error-examples.md     # Real error messages
│   ├── korean-errors.md      # Korean-specific guide
│   ├── glossary.md           # Korean→English (380+ terms)
│   ├── opencode-errors.md    # Crush migration guide
│   └── oh-my-opencode-errors.md
├── scripts/
│   └── daily-update.sh       # Auto-update cron
├── .github/workflows/
│   ├── daily-check.yml       # Daily verification
│   └── npm-publish.yml       # npm publishing
├── package.json              # npm package config
└── README.md
```

---

## Requirements

| Dependency | Required | Install |
|------------|----------|---------|
| `bash` | 3.2+ | Pre-installed |
| `jq` | Latest | `brew install jq` |
| `curl` | Any | Pre-installed |

---

## Auto-Update

### Cron (Local)
```bash
crontab -e
# Add:
0 9 * * * ~/claude-error-prevention/scripts/daily-update.sh
```

### GitHub Action
Runs daily at midnight UTC. See `.github/workflows/daily-check.yml`.

---

## Sources

All patterns verified against official documentation:

| Tool | Repository | Verified |
|------|------------|----------|
| Claude Code | [anthropics/claude-code](https://github.com/anthropics/claude-code) | ✅ 2026-02-07 |
| Crush | [charmbracelet/crush](https://github.com/charmbracelet/crush) | ✅ 2026-02-07 |
| Oh My OpenCode | [code-yeongyu/oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) | ✅ 2026-02-07 |
| QMD | [tobi/qmd](https://github.com/tobi/qmd) | ✅ 2026-02-07 |

---

## License

MIT

---

<p align="center">
  <strong>67 patterns · 45+ auto-fixes · Zero configuration</strong>
</p>

<p align="center">
  <sub>Built with care by <a href="https://github.com/MadKangYu">MadKangYu</a></sub>
</p>
