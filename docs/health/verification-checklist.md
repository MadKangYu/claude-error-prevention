# System Verification Checklist

> Complete health check for Claude Code, Crush, OpenCode, OpenClaw ecosystem.
> Run these checks after installation or when troubleshooting.

---

## Quick Health Check

```bash
# One-liner health check
./src/error-engine.sh scan
```

---

## Claude Code

### Installation

| Check | Command | Expected |
|-------|---------|----------|
| Version | `claude --version` | Version number |
| Single install | `which -a claude \| wc -l` | `1` |
| Doctor | `claude doctor` | All checks pass |

### Configuration

| Check | Command | Expected |
|-------|---------|----------|
| Settings exists | `ls ~/.claude/settings.json` | File exists |
| Settings valid | `jq empty ~/.claude/settings.json` | No error |
| Global CLAUDE.md | `ls ~/.claude/CLAUDE.md` | File exists |

### Extensions

| Check | Command | Expected |
|-------|---------|----------|
| Skills count | `ls ~/.claude/skills/ \| wc -l` | Number (e.g., 95) |
| Agents dir | `ls ~/.claude/agents/` | Directory exists |
| Rules dir | `ls ~/.claude/rules/` | Directory exists |

### Environment

| Check | Command | Expected |
|-------|---------|----------|
| API Key | `echo ${ANTHROPIC_API_KEY:+SET}` | `SET` |

---

## Crush

### Installation

| Check | Command | Expected |
|-------|---------|----------|
| Version | `crush --version` | Version number |
| Config exists | `ls ~/.config/crush/crush.json` | File exists |
| Config valid | `jq empty ~/.config/crush/crush.json` | No error |

### Provider

| Check | Command | Expected |
|-------|---------|----------|
| Connect | `crush` → `/connect` | Connection success |
| Logs | `crush logs --tail 10` | No errors |

---

## OpenCode

| Check | Command | Expected |
|-------|---------|----------|
| Version | `opencode --version` | Version number |
| Config | `ls ~/.config/opencode/opencode.json` | File exists |

---

## OpenClaw

### Service

| Check | Command | Expected |
|-------|---------|----------|
| Gateway loaded | `launchctl list \| grep openclaw` | Entry exists |
| HTTP health | `curl -s http://127.0.0.1:18789/health` | HTML response |
| WS health | `timeout 5 openclaw status --json` | JSON response |

### Configuration

| Check | Command | Expected |
|-------|---------|----------|
| Config exists | `ls ~/.openclaw/openclaw.json` | File exists |
| Config valid | `jq empty ~/.openclaw/openclaw.json` | No error |
| Agents | `ls ~/.openclaw/agents/` | Directories |

### Optional Services

| Check | Command | Expected |
|-------|---------|----------|
| Browserless | `curl -s http://localhost:3000` | HTML response |

---

## QMD

| Check | Command | Expected |
|-------|---------|----------|
| Version | `qmd --version` | Version number |
| Status | `qmd status` | Collections listed |
| Collections | `qmd collection list` | At least one |
| Embeddings | `qmd status \| grep chunks` | Number > 0 |

---

## MCP Servers

| Check | Command | Expected |
|-------|---------|----------|
| Claude MCP | `cat ~/.claude.json \| jq '.mcpServers'` | Server list |
| Project MCP | `cat .mcp.json \| jq '.mcpServers'` | Server list |

---

## Automated Verification Script

```bash
#!/bin/bash
# save as verify-system.sh

echo "=== System Verification ==="

# Claude Code
echo -n "Claude Code: "
claude --version 2>/dev/null && echo "OK" || echo "NOT FOUND"

# Crush
echo -n "Crush: "
crush --version 2>/dev/null && echo "OK" || echo "NOT FOUND"

# OpenClaw
echo -n "OpenClaw Gateway: "
curl -sf http://127.0.0.1:18789/health >/dev/null && echo "OK" || echo "NOT RUNNING"

# QMD
echo -n "QMD: "
qmd --version 2>/dev/null && echo "OK" || echo "NOT FOUND"

# API Keys
echo -n "ANTHROPIC_API_KEY: "
[[ -n "$ANTHROPIC_API_KEY" ]] && echo "SET" || echo "NOT SET"

echo -n "OPENAI_API_KEY: "
[[ -n "$OPENAI_API_KEY" ]] && echo "SET" || echo "NOT SET"

echo "=== Done ==="
```

---

## Troubleshooting by Check Result

| Check Failed | See Document |
|--------------|--------------|
| Claude install | [errors/claude-code-errors.md](../errors/claude-code-errors.md) |
| Crush install | [errors/opencode-errors.md](../errors/opencode-errors.md) |
| OpenClaw gateway | [errors/openclaw-errors.md](../errors/openclaw-errors.md) |
| MCP servers | [errors/mcp-server-errors.md](../errors/mcp-server-errors.md) |
| QMD | [guides/installation.md](../guides/installation.md#qmd) |

---

*Last updated: 2026-02-07*
*Source: Karpathy-level verification protocol*
