# AI Agent Error Prevention System

<p align="center">
  <strong>Version 2.0.0</strong> · <strong>2026-02-07</strong> · <strong>Production Ready</strong>
</p>

<p align="center">
  <em>A systematic approach to detecting, diagnosing, and resolving errors<br/>in AI-powered coding assistants and development environments.</em>
</p>

---

## Overview

In the ever-expanding landscape of AI-assisted software development, developers increasingly rely on intelligent coding agents—Claude Code, Crush (formerly OpenCode), OpenClaw, and their integrations with knowledge management systems like Obsidian. Yet with this power comes complexity: misconfigured installations, deprecated dependencies, conflicting versions, and subtle configuration errors that silently degrade the developer experience.

This repository presents a comprehensive error prevention framework. Rather than waiting for errors to manifest at inopportune moments, we proactively scan, detect, and resolve issues before they interrupt your workflow. The architecture draws inspiration from the fail-fast, verify-often philosophy championed by industry luminaries.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Philosophy](#philosophy)
- [Architecture](#architecture)
- [Installation](#installation)
- [Commands](#commands)
- [Supported Tools](#supported-tools)
  - [Claude Code](#claude-code)
  - [Crush (OpenCode)](#crush-opencode)
  - [OpenClaw](#openclaw)
  - [Obsidian](#obsidian)
  - [System Dependencies](#system-dependencies)
- [Error Pattern Format](#error-pattern-format)
- [Search Functionality](#search-functionality)
- [Integration](#integration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Sources](#sources)
- [License](#license)

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/MadKangYu/claude-error-prevention.git
cd claude-error-prevention

# Scan for errors
./src/error-engine.sh scan

# Search for a specific error by keyword
./src/error-engine.sh search "uint64"

# Auto-fix all resolvable errors
./src/error-engine.sh fix-all

# Verify system state
./src/error-engine.sh verify

# Generate a comprehensive report
./src/error-engine.sh report
```

---

## Philosophy

The error prevention system operates on four foundational principles:

### 1. Proactive Detection
Rather than reacting to errors after they disrupt your work, the system continuously monitors for known error patterns. A stitch in time saves nine.

### 2. Verified Resolution
Every fix undergoes pre-verification (confirming the error exists) and post-verification (confirming the fix succeeded). No silent failures, no false confidence.

### 3. Searchable Knowledge
When you encounter an unfamiliar error message, you should be able to search for it instantly. The system indexes all patterns by keywords, error messages, and tool names.

### 4. Source of Truth
All documentation is verified against official GitHub repositories. We copy verbatim; we do not summarize, paraphrase, or translate unless explicitly requested.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ERROR ENGINE v2.0                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐  │
│  │ DETECT  │ → │ RESOLVE │ → │ VERIFY  │ → │ REPORT  │  │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘  │
│       │              │              │              │        │
│       ▼              ▼              ▼              ▼        │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐  │
│  │ Pattern │    │ Pre/Post│    │ State   │    │  JSON   │  │
│  │ Matching│    │ Checks  │    │ Confirm │    │  Logs   │  │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │   patterns/error-patterns.json │
              │   (18 patterns, 5 tools)       │
              └───────────────────────────────┘
```

---

## Installation

### Prerequisites

| Dependency | Purpose | Installation |
|------------|---------|--------------|
| `jq` | JSON processing | `brew install jq` |
| `curl` | HTTP requests | Pre-installed on most systems |
| `bash` 4+ | Script execution | Pre-installed on macOS/Linux |

### Setup

```bash
# Clone
git clone https://github.com/MadKangYu/claude-error-prevention.git

# Make executable
chmod +x claude-error-prevention/src/error-engine.sh
chmod +x claude-error-prevention/scripts/*.sh

# Optional: Add to PATH
echo 'export PATH="$PATH:$HOME/claude-error-prevention/src"' >> ~/.zshrc
```

---

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `scan` | Detect all errors across all tools | `./error-engine.sh scan` |
| `fix <id>` | Apply fix for specific error | `./error-engine.sh fix claude-duplicate-install` |
| `fix-all` | Fix all auto-fixable errors | `./error-engine.sh fix-all` |
| `verify` | Verify current system state | `./error-engine.sh verify` |
| `report` | Generate JSON report | `./error-engine.sh report` |
| `list` | List all error patterns | `./error-engine.sh list` |
| `search <kw>` | Search patterns by keyword | `./error-engine.sh search gateway` |

---

## Supported Tools

### Claude Code

Anthropic's official CLI for Claude—an agentic coding tool that lives in your terminal.

| Error ID | Description | Severity | Auto-Fix |
|----------|-------------|----------|----------|
| `claude-duplicate-install` | Multiple installations detected (npm + native) | Error | ✅ |
| `claude-npm-deprecated` | Deprecated npm installation exists | Error | ✅ |
| `claude-settings-schema` | Invalid or missing `$schema` in settings.json | Error | ✅ |
| `claude-deprecated-mcp-location` | Deprecated `~/.mcp.json` exists | Warning | ✅ |
| `claude-invalid-json-settings` | Invalid JSON syntax in settings.json | Error | Manual |
| `claude-invalid-json-mcp` | Invalid JSON syntax in claude_code_config.json | Error | Manual |

#### Official Installation

```bash
# macOS/Linux (Recommended)
curl -fsSL https://claude.ai/install.sh | bash

# Homebrew
brew install --cask claude-code

# Windows
irm https://claude.ai/install.ps1 | iex
```

**Source:** [anthropics/claude-code](https://github.com/anthropics/claude-code)

---

### Crush (OpenCode)

> **Note:** OpenCode has been renamed to **Crush** by Charmbracelet. The original repository is archived.

| Error ID | Description | Severity | Auto-Fix |
|----------|-------------|----------|----------|
| `opencode-uint64-schema` | MCP schema uses non-standard uint64 format | Info | N/A |
| `opencode-no-provider` | No AI provider configured | Warning | Manual |
| `opencode-old-version` | Old OpenCode version conflict | Error | ✅ |

#### Official Installation

```bash
# Homebrew (Recommended)
brew install charmbracelet/tap/crush

# npm
npm install -g @charmland/crush

# Windows
winget install charmbracelet.crush
```

**Source:** [charmbracelet/crush](https://github.com/charmbracelet/crush)

---

### OpenClaw

A multi-agent gateway system with Telegram integration, supporting multiple AI providers.

| Error ID | Description | Severity | Auto-Fix |
|----------|-------------|----------|----------|
| `openclaw-gateway-down` | Gateway not responding on port 18789 | Warning | ✅ |
| `openclaw-env-exposed` | `.env` file in OpenClaw directory (security risk) | Error | ✅ |
| `openclaw-browserless-down` | Browserless service not running | Warning | ✅ |

#### Service Verification

```bash
# Gateway health
curl -s http://localhost:18789/health

# Browserless
curl -s http://localhost:3000

# Start gateway
launchctl start openclaw.gateway
```

---

### Obsidian

Local-first knowledge management with powerful linking and graph visualization.

| Error ID | Description | Severity | Auto-Fix |
|----------|-------------|----------|----------|
| `obsidian-vault-not-found` | Vault not found at default location | Warning | Manual |
| `obsidian-qmd-not-indexed` | QMD index missing (vault not searchable by AI) | Warning | ✅ |
| `obsidian-sync-conflict` | Sync conflict files detected | Warning | Manual |
| `obsidian-orphaned-notes` | Notes with no incoming/outgoing links | Info | Manual |

#### QMD Integration

QMD provides local semantic search for your Obsidian vault, enabling AI agents to search your notes.

```bash
# Install QMD (requires bun)
bun install -g https://github.com/tobi/qmd

# Add vault collection
qmd collection add ~/Obsidian/Vault --name vault --mask "**/*.md"

# Build index and embeddings
qmd update && qmd embed

# Test search
qmd search "your query"
```

**Source:** [tobi/qmd](https://github.com/tobi/qmd)

---

### System Dependencies

| Error ID | Description | Severity | Auto-Fix |
|----------|-------------|----------|----------|
| `env-missing-jq` | jq not installed | Error | ✅ |
| `env-missing-qmd` | qmd not installed | Info | ✅ |

---

## Error Pattern Format

Each error pattern is defined in `patterns/error-patterns.json`:

```json
{
  "id": "unique-error-id",
  "tool": "claude-code|opencode|openclaw|obsidian|system",
  "category": "installation|config|service|security|dependency",
  "keywords": ["searchable", "terms"],
  "detect": {
    "command": "shell command that returns a value",
    "condition": "eq|neq|gt|lt|contains",
    "value": "expected value for error condition"
  },
  "message": "Human-readable description of the error",
  "severity": "error|warning|info",
  "fix": {
    "command": "shell command to resolve the error",
    "description": "Explanation of what the fix does"
  }
}
```

### Detection Types

| Type | Description | Example |
|------|-------------|---------|
| Command-based | Execute shell command, compare result | `which -a claude \| wc -l` |
| Log-pattern | Match against log output | `"unknown format \"uint64\""` |
| File-pattern | Check for file existence patterns | `*.sync-conflict-*` |

---

## Search Functionality

The search command enables rapid lookup of errors by keyword, message text, or tool name.

```bash
# Search by error message content
./error-engine.sh search "uint64"

# Search by tool name
./error-engine.sh search "obsidian"

# Search by symptom
./error-engine.sh search "gateway"

# Search by category
./error-engine.sh search "security"
```

### Search Scope

The search examines:
- Error ID
- Error message
- Fix description
- Keywords array

---

## Integration

### CLAUDE.md Integration

Add to your `~/.claude/CLAUDE.md` for automatic error checking:

```markdown
## Error Prevention

Before starting work, run:
```bash
~/claude-error-prevention/src/error-engine.sh scan
```

If errors found:
```bash
~/claude-error-prevention/src/error-engine.sh fix-all
```
```

### Git Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

errors=$(~/claude-error-prevention/src/error-engine.sh scan 2>&1)
if [ $? -ne 0 ]; then
  echo "Error prevention check failed:"
  echo "$errors"
  exit 1
fi
```

### CI/CD Integration

```yaml
# .github/workflows/error-check.yml
name: Error Prevention Check
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install jq
        run: sudo apt-get install -y jq
      - name: Clone error prevention
        run: git clone https://github.com/MadKangYu/claude-error-prevention.git
      - name: Run scan
        run: ./claude-error-prevention/src/error-engine.sh scan
```

---

## Troubleshooting

### "jq: command not found"

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Arch Linux
sudo pacman -S jq
```

### "Permission denied"

```bash
chmod +x src/error-engine.sh
chmod +x scripts/*.sh
```

### "Patterns file not found"

Run commands from the repository root directory, or set `PATTERNS_FILE` environment variable.

### "Fix did not resolve the error"

Some fixes require additional steps:
1. Restart your terminal
2. Source your shell profile: `source ~/.zshrc`
3. Check the fix description for manual steps

---

## Directory Structure

```
claude-error-prevention/
├── README.md                    # This document
├── LICENSE                      # MIT License
├── src/
│   └── error-engine.sh          # Main detection/resolution engine
├── patterns/
│   └── error-patterns.json      # Error definitions (18 patterns)
├── docs/
│   ├── installation.md          # Installation guides
│   ├── common-errors.md         # Common error patterns
│   ├── opencode-errors.md       # Crush/OpenCode specific
│   ├── openclaw-errors.md       # OpenClaw specific
│   ├── obsidian-errors.md       # Obsidian specific
│   └── oh-my-opencode-errors.md # Oh My OpenCode specific
└── scripts/
    ├── verify-all.sh            # Full verification suite
    ├── verify-install.sh        # Installation verification
    ├── verify-local.sh          # Local config verification
    └── compare-docs.sh          # Documentation comparison
```

---

## Contributing

1. **Fork** the repository
2. **Add** error patterns to `patterns/error-patterns.json`
3. **Test** with `./src/error-engine.sh scan`
4. **Document** in the appropriate `docs/*.md` file
5. **Submit** a pull request

### Pattern Guidelines

- Use descriptive, unique IDs
- Include relevant keywords for searchability
- Provide clear, actionable fix descriptions
- Test detection commands on multiple systems
- Mark manual-only fixes appropriately

---

## Sources

All documentation verified against official sources on 2026-02-07:

| Tool | Official Repository |
|------|---------------------|
| Claude Code | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| Crush | [charmbracelet/crush](https://github.com/charmbracelet/crush) |
| OpenCode (Archived) | [opencode-ai/opencode](https://github.com/opencode-ai/opencode) |
| QMD | [tobi/qmd](https://github.com/tobi/qmd) |

---

## License

MIT License

Copyright (c) 2026 MadKangYu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

<p align="center">
  <em>Built with precision. Verified against source. Ready for production.</em>
</p>
