# OpenCode / Crush Migration Guide

> **IMPORTANT:** OpenCode has been renamed to **Crush** by Charmbracelet.
> The old `opencode-ai/opencode` repository is archived.

**Source:** https://github.com/charmbracelet/crush

---

## Installation (Verified 2026-02-07)

### Crush (Current)

| Platform | Command |
|----------|---------|
| **Homebrew** | `brew install charmbracelet/tap/crush` |
| **npm** | `npm install -g @charmland/crush` |
| **Winget** | `winget install charmbracelet.crush` |
| **Scoop** | `scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git && scoop install crush` |
| **Arch** | `yay -S crush-bin` |
| **Go** | `go install github.com/charmbracelet/crush@latest` |

### Debian/Ubuntu

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install crush
```

### Legacy OpenCode (Archived)

```bash
# NO LONGER MAINTAINED
brew install opencode-ai/tap/opencode
```

---

## Configuration

### Config Locations (Priority Order)

| Priority | Path | Scope |
|----------|------|-------|
| 1 | `.crush.json` | Project |
| 2 | `crush.json` | Project |
| 3 | `~/.config/crush/crush.json` | Global (Unix) |
| 4 | `%LOCALAPPDATA%\crush\crush.json` | Global (Windows) |

### Environment Variables

```bash
# Override config location
CRUSH_GLOBAL_CONFIG=/path/to/config.json
CRUSH_GLOBAL_DATA=/path/to/data

# Provider keys (at least one required)
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
GROQ_API_KEY=...
GITHUB_TOKEN=...
```

### Config Schema

```json
{
  "$schema": "https://charm.land/crush.json",
  "providers": {
    "anthropic": {
      "type": "anthropic",
      "api_key": "$ANTHROPIC_API_KEY"
    }
  },
  "mcp": {
    "server-name": {
      "type": "stdio",
      "command": "path/to/server",
      "args": []
    }
  },
  "lsp": {
    "typescript": {
      "command": "typescript-language-server",
      "args": ["--stdio"]
    }
  }
}
```

---

## Migration: OpenCode → Crush

### Step-by-Step

```bash
# 1. Backup
cp -r ~/.config/opencode ~/.config/opencode.bak

# 2. Uninstall old
brew uninstall opencode-ai/tap/opencode 2>/dev/null
npm uninstall -g opencode-ai 2>/dev/null

# 3. Install Crush
brew install charmbracelet/tap/crush

# 4. Migrate config
mkdir -p ~/.config/crush
cp ~/.config/opencode/opencode.json ~/.config/crush/crush.json

# 5. Update schema reference
# Change: "$schema": "..." 
# To:     "$schema": "https://charm.land/crush.json"

# 6. Migrate project files
mv .opencode.json .crush.json 2>/dev/null
mv .opencodeignore .crushignore 2>/dev/null

# 7. Update environment variables
# OPENCODE_* → CRUSH_*

# 8. Verify
crush --version
```

### File Renames

| Old | New |
|-----|-----|
| `~/.config/opencode/` | `~/.config/crush/` |
| `opencode.json` | `crush.json` |
| `.opencode.json` | `.crush.json` |
| `.opencodeignore` | `.crushignore` |
| `OPENCODE_*` env vars | `CRUSH_*` env vars |

---

## Common Errors

### 1. No API Key

```
Error: No API key found
```

**Fix:** Set provider in config or environment:
```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

### 2. Old Version Conflict

```
Error: Incompatible version
```

**Fix:**
```bash
npm uninstall -g opencode-ai
rm -rf ~/.config/opencode
brew install charmbracelet/tap/crush
```

### 3. MCP Connection Failed

```
Error: MCP connection failed
```

**Fix:** Verify MCP config:
```json
{
  "mcp": {
    "server": {
      "type": "stdio",
      "command": "/absolute/path/to/server"
    }
  }
}
```

### 4. uint64 Schema Warning

```
unknown format "uint64" ignored
```

**Status:** Safe to ignore. MCP server uses non-standard format.

---

## Verification

```bash
# Version
crush --version

# Config check
cat ~/.config/crush/crush.json | jq '.providers | keys'

# Provider test
crush
# Then: /connect
```

---

## Features

| Feature | Crush |
|---------|-------|
| Multi-Model | ✅ Claude, OpenAI, Gemini, Groq |
| MCP | ✅ http, stdio, sse |
| LSP | ✅ Full integration |
| Sessions | ✅ Persistent |
| Development | ✅ Active |
