# OpenCode & Crush Error Patterns

> Migration guide and error patterns for OpenCode and its successor Crush

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗       ║
║   ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝       ║
║   ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║     ██║   ██║██║  ██║█████╗         ║
║   ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║     ██║   ██║██║  ██║██╔══╝         ║
║   ╚██████╔╝██║     ███████╗██║ ╚████║╚██████╗╚██████╔╝██████╔╝███████╗       ║
║    ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝       ║
║                                                                              ║
║            ██████╗██████╗ ██╗   ██╗███████╗██╗  ██╗                          ║
║           ██╔════╝██╔══██╗██║   ██║██╔════╝██║  ██║                          ║
║           ██║     ██████╔╝██║   ██║███████╗███████║                          ║
║           ██║     ██╔══██╗██║   ██║╚════██║██╔══██║                          ║
║           ╚██████╗██║  ██║╚██████╔╝███████║██║  ██║                          ║
║            ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝                          ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 8 | Migration Guide Included     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Project Status

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           PROJECT RELATIONSHIP                               │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ⚠️  IMPORTANT: OpenCode and Crush are SEPARATE projects                     │
│                                                                              │
│  ┌────────────────────────────┐     ┌────────────────────────────┐          │
│  │        OPENCODE            │     │         CRUSH              │          │
│  │                            │     │                            │          │
│  │  Repo: anomalyco/opencode  │     │  Repo: charmbracelet/crush │          │
│  │  Lang: TypeScript          │     │  Lang: Go                  │          │
│  │  Stars: 99k+               │     │  Stars: 19k+               │          │
│  │  Status: Active            │     │  Status: Active            │          │
│  │                            │     │                            │          │
│  │  Features:                 │     │  Features:                 │          │
│  │  • Client/Server           │     │  • Single binary           │          │
│  │  • Desktop app (BETA)      │     │  • Terminal-first          │          │
│  │  • MIT License             │     │  • Auto-updating providers │          │
│  │                            │     │  • Charm ecosystem         │          │
│  └────────────────────────────┘     └────────────────────────────┘          │
│                                                                              │
│  NOT a rename/fork - different projects with similar goals                   │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Official Documentation Sources

| Project | URL |
|---------|-----|
| OpenCode | https://opencode.ai |
| OpenCode GitHub | https://github.com/anomalyco/opencode |
| Crush | https://github.com/charmbracelet/crush |
| Charm Discord | https://charm.land/discord |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         OPENCODE / CRUSH QUICK FIX                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "No API key found"               │ Set ANTHROPIC_API_KEY or config          │
│  "transport not started yet"      │ Update Crush to v0.2.0+                  │
│  "Incompatible version"           │ Uninstall old, install fresh             │
│  "MCP connection failed"          │ Check absolute path in config            │
│  "uint64 format ignored"          │ Safe to ignore (MCP schema)              │
│  "401 Unauthorized"               │ Verify API key in env or config          │
│  "LSP server failed"              │ Check LSP binary in PATH                 │
│  "Permission denied: bash"        │ Add to allowed_tools or use --yolo       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Installation

### OpenCode (anomalyco)

```bash
# YOLO install
curl -fsSL https://opencode.ai/install | bash

# Package managers
npm i -g opencode-ai@latest
brew install anomalyco/tap/opencode
scoop install opencode  # Windows
```

### Crush (Charmbracelet)

| Platform | Command |
|----------|---------|
| **Homebrew** | `brew install charmbracelet/tap/crush` |
| **npm** | `npm install -g @charmland/crush` |
| **Winget** | `winget install charmbracelet.crush` |
| **Scoop** | `scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git && scoop install crush` |
| **Arch** | `yay -S crush-bin` |
| **Go** | `go install github.com/charmbracelet/crush@latest` |

**Debian/Ubuntu:**
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install crush
```

---

## Configuration

### OpenCode Config Locations

| Priority | Path |
|----------|------|
| 1 | `.opencode.json` (project) |
| 2 | `~/.config/opencode/opencode.json` (global) |

### Crush Config Locations

| Priority | Path |
|----------|------|
| 1 | `.crush.json` (project) |
| 2 | `crush.json` (project) |
| 3 | `~/.config/crush/crush.json` (Unix global) |
| 4 | `%LOCALAPPDATA%\crush\crush.json` (Windows) |

### Environment Variables

```bash
# Provider keys (at least one required)
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
export GEMINI_API_KEY=...
export GROQ_API_KEY=...
export OPENROUTER_API_KEY=...

# Crush overrides
export CRUSH_GLOBAL_CONFIG=/path/to/config.json
export CRUSH_GLOBAL_DATA=/path/to/data
export CRUSH_DISABLE_METRICS=1
```

### Crush Config Example

```json
{
  "$schema": "https://charm.land/crush.json",
  
  "providers": {
    "anthropic": {
      "type": "anthropic",
      "api_key": "$ANTHROPIC_API_KEY"
    },
    "deepseek": {
      "type": "openai-compat",
      "base_url": "https://api.deepseek.com/v1",
      "api_key": "$DEEPSEEK_API_KEY",
      "models": [
        {
          "id": "deepseek-chat",
          "name": "Deepseek V3",
          "cost_per_1m_in": 0.27,
          "cost_per_1m_out": 1.1,
          "context_window": 64000
        }
      ]
    }
  },
  
  "lsp": {
    "go": {
      "command": "gopls",
      "env": { "GOTOOLCHAIN": "go1.24.5" }
    },
    "typescript": {
      "command": "typescript-language-server",
      "args": ["--stdio"]
    }
  },
  
  "mcp": {
    "context7": {
      "type": "sse",
      "url": "https://mcp.context7.com/sse",
      "timeout": 120
    },
    "filesystem": {
      "type": "stdio",
      "command": "node",
      "args": ["/path/to/mcp-server.js"],
      "env": { "NODE_ENV": "production" }
    }
  },
  
  "permissions": {
    "allowed_tools": ["view", "ls", "grep", "edit"]
  },
  
  "options": {
    "debug": false,
    "debug_lsp": false,
    "disable_metrics": false,
    "disable_provider_auto_update": false,
    "attribution": {
      "trailer_style": "assisted-by",
      "generated_with": true
    }
  }
}
```

### Crush Advanced Configuration

**.crushignore (like .gitignore):**
```
# Ignore large directories
node_modules/
.git/
dist/
build/
```

**Agent Skills:**
```bash
# Skills directory (Unix)
~/.config/crush/skills/

# Windows
%LOCALAPPDATA%\crush\skills\

# Configure additional paths
{
  "options": {
    "skills_paths": ["~/.config/crush/skills", "./project-skills"]
  }
}

# Get example skills
mkdir -p ~/.config/crush/skills
cd ~/.config/crush/skills
git clone https://github.com/anthropics/skills.git _temp
mv _temp/skills/* . && rm -rf _temp
```

**Attribution Settings:**
```json
{
  "options": {
    "attribution": {
      "trailer_style": "assisted-by",  // or "co-authored-by" or "none"
      "generated_with": true           // adds "💘 Generated with Crush"
    }
  }
}
```

**Logging:**
```bash
# View logs
crush logs                 # Last 1000 lines
crush logs --tail 500      # Last 500 lines
crush logs --follow        # Real-time

# Logs location: ./.crush/logs/crush.log
```

**Disable Metrics:**
```bash
export CRUSH_DISABLE_METRICS=1
# or
export DO_NOT_TRACK=1
```

Or in config:
```json
{
  "options": {
    "disable_metrics": true
  }
}
```

**Disable Provider Auto-Updates:**
```bash
export CRUSH_DISABLE_PROVIDER_AUTO_UPDATE=1
```

Or in config:
```json
{
  "options": {
    "disable_provider_auto_update": true
  }
}
```

**Manual Provider Update:**
```bash
crush update-providers                           # From Catwalk
crush update-providers https://custom.url/       # Custom URL
crush update-providers /path/to/providers.json   # Local file
crush update-providers embedded                  # Reset to built-in
```

---

### Local Models (Crush)

**Ollama:**
```json
{
  "providers": {
    "ollama": {
      "name": "Ollama",
      "base_url": "http://localhost:11434/v1/",
      "type": "openai-compat",
      "models": [
        {
          "name": "Qwen 3 30B",
          "id": "qwen3:30b",
          "context_window": 256000,
          "default_max_tokens": 20000
        }
      ]
    }
  }
}
```

**LM Studio:**
```json
{
  "providers": {
    "lmstudio": {
      "name": "LM Studio",
      "base_url": "http://localhost:1234/v1/",
      "type": "openai-compat",
      "models": [
        {
          "name": "Qwen 3 30B",
          "id": "qwen/qwen3-30b-a3b-2507",
          "context_window": 256000,
          "default_max_tokens": 20000
        }
      ]
    }
  }
}
```

---

### Cloud Providers (Crush)

**Amazon Bedrock:**
```bash
# Configure AWS
aws configure

# Set region
export AWS_REGION=us-east-1
# or
export AWS_DEFAULT_REGION=us-east-1

# Or use profile
export AWS_PROFILE=myprofile

# Or use bearer token
export AWS_BEARER_TOKEN_BEDROCK=...
```

**Google Vertex AI:**
```bash
# Set project and location
export VERTEXAI_PROJECT=my-project
export VERTEXAI_LOCATION=us-central1

# Authenticate
gcloud auth application-default login
```

Config:
```json
{
  "providers": {
    "vertexai": {
      "models": [
        {
          "id": "claude-sonnet-4@20250514",
          "name": "VertexAI Sonnet 4",
          "cost_per_1m_in": 3,
          "cost_per_1m_out": 15,
          "context_window": 200000
        }
      ]
    }
  }
}
```

---

## Error Patterns

### 1. No API Key Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: No API key found                                                     │
│  Please set ANTHROPIC_API_KEY or configure a provider                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Set in environment
export ANTHROPIC_API_KEY=sk-ant-...

# Or in config
{
  "providers": {
    "anthropic": {
      "api_key": "sk-ant-..."
    }
  }
}
```

---

### 2. MCP Transport Not Started (Crush)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERRO error initializing mcp client error="transport error:                  │
│  transport not started yet"                                                  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** SSE transport initialization bug in Crush v0.1.11

**Solution:**
```bash
# Update to v0.2.0+
brew upgrade crush
# or
npm update -g @charmland/crush
```

**Verified Working Config:**
```json
{
  "mcp": {
    "context7": {
      "type": "sse",
      "url": "https://mcp.context7.com/sse"
    }
  }
}
```

**Source:** [GitHub Issue #475](https://github.com/charmbracelet/crush/issues/475)

---

### 3. Old Version Conflict

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: Incompatible version                                                 │
│  Or: Multiple installations detected                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Remove old installations
npm uninstall -g opencode-ai
brew uninstall opencode-ai/tap/opencode 2>/dev/null
rm -rf ~/.config/opencode

# Fresh install
brew install charmbracelet/tap/crush
```

---

### 4. MCP Connection Failed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: MCP connection failed                                                │
│  spawn /path/to/server ENOENT                                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:** Use absolute paths:
```json
{
  "mcp": {
    "myserver": {
      "type": "stdio",
      "command": "/absolute/path/to/server"
    }
  }
}
```

---

### 5. LSP Server Failed to Start

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR: failed to start LSP server: gopls                                    │
│  spawn gopls ENOENT                                                          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:** Ensure LSP binary is in PATH:
```bash
# Go
go install golang.org/x/tools/gopls@latest

# TypeScript
npm install -g typescript-language-server typescript

# Python
pip install python-lsp-server
```

---

### 6. Permission Denied

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR: permission denied: bash                                              │
│  Tool 'bash' is not in allowed_tools                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```json
{
  "permissions": {
    "allowed_tools": ["bash", "view", "ls", "grep", "edit"]
  }
}
```

**Or use YOLO mode (⚠️ dangerous):**
```bash
crush --yolo
```

---

### 7. uint64 Schema Warning

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ WARNING                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  unknown format "uint64" ignored                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Status:** Safe to ignore. MCP server uses non-standard JSON schema format.

---

### 8. Provider Authentication Failed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  401 Unauthorized                                                            │
│  Invalid API key                                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Verify key is set
echo $ANTHROPIC_API_KEY

# Check config
cat ~/.config/crush/crush.json | jq '.providers'

# Test key directly
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-haiku-20240307","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'
```

---

## Feature Comparison

| Feature | OpenCode | Crush |
|---------|----------|-------|
| **Language** | TypeScript | Go |
| **Architecture** | Client/Server | Monolithic |
| **Desktop App** | ✅ BETA | ❌ |
| **Provider Updates** | Manual | Auto (Catwalk) |
| **MCP Support** | Limited | Full (stdio/http/sse) |
| **Agent Skills** | Custom | agentskills.io |
| **License** | MIT | FSL-1.1-MIT |
| **Multi-Model** | ✅ | ✅ |
| **LSP** | ✅ | ✅ |
| **Sessions** | ✅ | ✅ |

---

## Verification Commands

```bash
# OpenCode
opencode --version
cat ~/.config/opencode/opencode.json | jq '.providers | keys'

# Crush
crush --version
cat ~/.config/crush/crush.json | jq '.providers | keys'
crush logs --tail 50

# Test connection
crush
# Then: /connect
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Plugin for OpenCode |
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI |
| [Ghostty Errors](./ghostty-errors.md) | Terminal emulator |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Complete rewrite, clarified OpenCode vs Crush |
| 2.6 | 2024-02-06 | Initial migration guide |

---

*Last updated: 2026-02-07 | Sources: opencode.ai, github.com/charmbracelet/crush*
*Maintainer: claude-error-prevention | License: MIT*
