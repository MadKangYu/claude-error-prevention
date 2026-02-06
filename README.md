# AI Agent Error Prevention Guide

**Version**: 1.0.0 (2026-02-07)
**Status**: Production Ready

Systematic error detection and auto-resolution for AI coding agents (Claude Code, OpenCode, OpenClaw).

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/MadKangYu/claude-error-prevention.git
cd claude-error-prevention

# 2. Scan for errors
./src/error-engine.sh scan

# 3. Auto-fix all errors
./src/error-engine.sh fix-all

# 4. Verify
./src/error-engine.sh verify
```

---

## Features

| Feature | Description |
|---------|-------------|
| **Detect** | Pattern-based error detection |
| **Resolve** | Automatic fixes with verification |
| **Verify** | Pre/post fix validation |
| **Report** | JSON reports for tracking |

---

## Requirements

- macOS / Linux / WSL
- `jq` (JSON processor)
- `curl` (HTTP client)

```bash
# Install jq (macOS)
brew install jq

# Install jq (Ubuntu/Debian)
sudo apt-get install jq
```

---

## Commands

```bash
# Scan for all errors
./src/error-engine.sh scan

# Fix specific error
./src/error-engine.sh fix <error-id>

# Fix all auto-fixable errors
./src/error-engine.sh fix-all

# Verify system state
./src/error-engine.sh verify

# Generate JSON report
./src/error-engine.sh report

# List all error patterns
./src/error-engine.sh list
```

---

## Supported Tools

### Claude Code

| Error | ID | Auto-Fix |
|-------|-----|----------|
| Multiple installations | `claude-duplicate-install` | Yes |
| Deprecated npm install | `claude-npm-deprecated` | Yes |
| Invalid settings schema | `claude-settings-schema` | Yes |
| Deprecated config location | `claude-deprecated-mcp-location` | Yes |
| Invalid JSON | `claude-invalid-json-*` | Manual |

### OpenCode

| Error | ID | Auto-Fix |
|-------|-----|----------|
| No provider configured | `opencode-no-provider` | Manual |
| Schema warnings (uint64) | `opencode-uint64-schema` | N/A (safe) |

### OpenClaw

| Error | ID | Auto-Fix |
|-------|-----|----------|
| Gateway down | `openclaw-gateway-down` | Yes |
| .env exposure | `openclaw-env-exposed` | Yes |

---

## Directory Structure

```
claude-error-prevention/
├── README.md
├── LICENSE
├── src/
│   └── error-engine.sh      # Main engine
├── patterns/
│   └── error-patterns.json  # Error definitions
├── docs/
│   ├── installation.md
│   ├── common-errors.md
│   ├── opencode-errors.md
│   ├── openclaw-errors.md
│   └── oh-my-opencode-errors.md
└── scripts/
    ├── verify-all.sh
    ├── verify-install.sh
    ├── verify-local.sh
    └── compare-docs.sh
```

---

## Error Pattern Format

```json
{
  "id": "error-id",
  "tool": "claude-code",
  "category": "installation",
  "detect": {
    "command": "shell command returning value",
    "condition": "eq|neq|gt|lt",
    "value": "expected value"
  },
  "message": "Human readable error message",
  "severity": "error|warning|info",
  "fix": {
    "command": "shell command to fix",
    "description": "What the fix does"
  }
}
```

---

## Adding Custom Patterns

Edit `patterns/error-patterns.json`:

```json
{
  "id": "my-custom-error",
  "tool": "my-tool",
  "category": "config",
  "detect": {
    "command": "test -f ~/.my-config && echo 1 || echo 0",
    "condition": "eq",
    "value": 0
  },
  "message": "Config file missing",
  "severity": "error",
  "fix": {
    "command": "touch ~/.my-config",
    "description": "Create config file"
  }
}
```

---

## Integration with CLAUDE.md

Add to your `~/.claude/CLAUDE.md`:

```markdown
## Error Prevention

Run before starting work:
\`\`\`bash
~/claude-error-prevention/src/error-engine.sh scan
\`\`\`

Auto-fix if needed:
\`\`\`bash
~/claude-error-prevention/src/error-engine.sh fix-all
\`\`\`
```

---

## Logs and Reports

- Logs: `~/.claude/error-logs/`
- Reports: `~/.claude/error-logs/report-*.json`
- Backups: `~/.claude/error-logs/backups/`

---

## Troubleshooting

### "jq: command not found"

```bash
brew install jq  # macOS
apt-get install jq  # Linux
```

### "Permission denied"

```bash
chmod +x src/error-engine.sh
chmod +x scripts/*.sh
```

### "Patterns file not found"

Ensure you're running from the repo root directory.

---

## Contributing

1. Fork the repository
2. Add error patterns to `patterns/error-patterns.json`
3. Test with `./src/error-engine.sh scan`
4. Submit PR

---

## License

MIT License - Use freely, attribution appreciated.

---

## Sources

- [Claude Code Official Docs](https://code.claude.com/docs/en/setup)
- [OpenCode Docs](https://opencode.ai/docs/)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [OpenCode GitHub](https://github.com/anomalyco/opencode)
