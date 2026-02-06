# OpenCode / Crush Error Patterns

> **IMPORTANT:** OpenCode has been renamed to **Crush** by Charmbracelet (2026).
> The old `opencode-ai/opencode` repository is archived.

---

## Installation

### Crush (Current - Charmbracelet)

```bash
# Homebrew (recommended)
brew install charmbracelet/tap/crush

# npm
npm install -g @charmland/crush

# Windows
winget install charmbracelet.crush
```

### Legacy OpenCode (Archived)

```bash
# No longer maintained
brew install opencode-ai/tap/opencode
```

**Source:** https://github.com/charmbracelet/crush

---

## Configuration

### Config File Locations

```
$HOME/.crush.json                       # New Crush config
$HOME/.config/crush/.crush.json         # XDG location
./.crush.json                           # Project-specific

# Legacy OpenCode locations
$HOME/.config/opencode/opencode.json    # Old config
$HOME/.config/opencode/.mcp.json        # Old MCP
```

### Environment Variables

```bash
# Required (at least one)
ANTHROPIC_API_KEY=      # Claude
OPENAI_API_KEY=         # OpenAI
GEMINI_API_KEY=         # Google
GROQ_API_KEY=           # Groq
GITHUB_TOKEN=           # GitHub Copilot

# Optional
VERTEXAI_PROJECT=       # Google Cloud
AWS_ACCESS_KEY_ID=      # AWS Bedrock
AZURE_OPENAI_ENDPOINT=  # Azure OpenAI
```

---

## Common Errors

### 1. Provider Connection

**Error:**
```
Error: No API key found
```

**Fix:** Set environment variable or configure in config file:
```json
{
  "providers": {
    "anthropic": {
      "apiKey": "sk-ant-..."
    }
  }
}
```

---

### 2. Old Version Conflict

**Error:**
```
Error: Incompatible version
```

**Fix:**
```bash
# Remove old OpenCode
npm uninstall -g opencode-ai
rm -rf ~/.config/opencode

# Install Crush
brew install charmbracelet/tap/crush
```

---

### 3. MCP Server Issues

**Error:**
```
Error: MCP connection failed
```

**Fix:** Check MCP config format and paths:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "path/to/server",
      "args": []
    }
  }
}
```

---

### 4. uint64 Schema Warning

**Warning:**
```
unknown format "uint64" ignored in schema at path "#/properties/lastModifiedTime"
```

**Cause:** MCP server uses non-standard JSON Schema format

**Impact:** Warning only, functionality not affected

**Action:** Safe to ignore. MCP server author should use `"type": "integer"` instead.

---

## Migration: OpenCode → Crush

### Steps

1. **Backup old config:**
   ```bash
   cp -r ~/.config/opencode ~/.config/opencode.bak
   ```

2. **Uninstall OpenCode:**
   ```bash
   brew uninstall opencode-ai/tap/opencode
   # or
   npm uninstall -g opencode-ai
   ```

3. **Install Crush:**
   ```bash
   brew install charmbracelet/tap/crush
   ```

4. **Migrate config:**
   ```bash
   # Config format is similar, may need minor adjustments
   mv ~/.config/opencode/.opencode.json ~/.crush.json
   ```

---

## Verification

```bash
# Check installation
crush --version

# Verify config
cat ~/.crush.json | jq '.providers | keys'

# Test connection
crush
# Then type: /connect
```

---

## Features Comparison

| Feature | OpenCode (Archived) | Crush (Current) |
|---------|---------------------|-----------------|
| Multi-Model | Yes | Yes |
| MCP Support | Yes | Yes (http, stdio, sse) |
| LSP Integration | Yes | Yes |
| Session Management | Yes | Yes |
| Active Development | No | Yes |

---

## Sources

- [Crush GitHub](https://github.com/charmbracelet/crush)
- [OpenCode GitHub (Archived)](https://github.com/opencode-ai/opencode)
