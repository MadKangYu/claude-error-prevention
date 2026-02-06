# Cursor IDE Error Patterns & Troubleshooting

> Error patterns and solutions for Cursor AI IDE

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗                           ║
║  ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗                          ║
║  ██║     ██║   ██║██████╔╝███████╗██║   ██║██████╔╝                          ║
║  ██║     ██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗                          ║
║  ╚██████╗╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║                          ║
║   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝                          ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 8 | Source: Official Docs        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| Homepage | https://cursor.com |
| Documentation | https://docs.cursor.com |
| Changelog | https://changelog.cursor.com |
| Forum | https://forum.cursor.com |
| Status | https://status.cursor.com |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          CURSOR QUICK FIX                                    │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "Request limit reached"          │ Wait or upgrade plan                     │
│  "Model not available"            │ Check status.cursor.com                  │
│  "Context too long"               │ Reduce file selection, use @codebase     │
│  Extension crash                  │ Disable conflicting extensions           │
│  Slow indexing                    │ Add folders to .cursorignore             │
│  Agent mode stuck                 │ Press Escape, restart chat               │
│  MCP connection failed            │ Check ~/.cursor/mcp.json config          │
│  Composer not responding          │ Reload window (Cmd+Shift+P > Reload)     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          CURSOR ARCHITECTURE                                 │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                          CURSOR IDE (VSCode Fork)                       │ │
│  │                                                                        │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                 │ │
│  │  │   Chat (⌘L)  │  │ Composer(⌘I) │  │  Agent Mode  │                 │ │
│  │  │              │  │              │  │              │                 │ │
│  │  │  Single-turn │  │  Multi-file  │  │  Autonomous  │                 │ │
│  │  │  Q&A         │  │  Edits       │  │  Execution   │                 │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘                 │ │
│  │         │                 │                 │                          │ │
│  │         └─────────────────┼─────────────────┘                          │ │
│  │                           │                                            │ │
│  │  ┌────────────────────────┼────────────────────────────────────────┐  │ │
│  │  │                   CONTEXT ENGINE                                 │  │ │
│  │  │  • @codebase (semantic search)                                  │  │ │
│  │  │  • @file / @folder (explicit context)                           │  │ │
│  │  │  • @docs (documentation lookup)                                 │  │ │
│  │  │  • @web (internet search)                                       │  │ │
│  │  └─────────────────────────────────────────────────────────────────┘  │ │
│  │                                                                        │ │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │ │
│  │  │  Indexer  │  MCP Support  │  Rules (.cursorrules)  │  Privacy   │  │ │
│  │  └─────────────────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│                           │                                                  │
│                           ▼                                                  │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      CURSOR CLOUD                                       │ │
│  │  • Model routing (GPT-4o, Claude, cursor-small)                        │ │
│  │  • Usage tracking & rate limiting                                      │ │
│  │  • Privacy mode (optional)                                             │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Error Patterns

### 1. Request Limit Reached

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  You've reached your request limit                                           │
│  Premium requests: 0 remaining                                               │
│  Slow requests available                                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Monthly quota exhausted for premium models (GPT-4o, Claude).

**Solutions:**
1. Wait for monthly reset
2. Use "slow requests" (queued, lower priority)
3. Switch to cursor-small for simple tasks
4. Upgrade to higher tier plan

**Check Usage:**
```
Settings > Cursor Settings > Usage
```

---

### 2. Model Not Available

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Model is currently unavailable                                              │
│  Please try again later or select a different model                          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Upstream provider outage or maintenance.

**Solutions:**
1. Check https://status.cursor.com
2. Switch to alternative model
3. Wait and retry

---

### 3. Context Window Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Context length exceeded                                                     │
│  The conversation is too long for this model                                 │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Too many files or long conversation history.

**Solutions:**
1. Start new chat (Cmd+L, then Cmd+N)
2. Use @codebase instead of @folder for large projects
3. Be selective with @file references
4. Use `.cursorignore` to exclude large files

**.cursorignore Example:**
```
node_modules/
dist/
*.min.js
*.bundle.js
package-lock.json
```

---

### 4. Slow Indexing

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  @codebase returns irrelevant results                                        │
│  Indexing spinner never completes                                            │
│  High CPU usage during indexing                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**

1. **Add .cursorignore:**
```
# Large generated files
dist/
build/
*.min.js

# Dependencies
node_modules/
vendor/
.venv/

# Data files
*.csv
*.json
!package.json
```

2. **Rebuild Index:**
```
Cmd+Shift+P > "Cursor: Rebuild Codebase Index"
```

3. **Check indexing status:**
```
View > Output > Cursor Indexing
```

---

### 5. MCP Connection Failed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Failed to connect to MCP server                                             │
│  MCP server [name] is not responding                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Config Location:** `~/.cursor/mcp.json`

**Example Config:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-filesystem-server", "/Users/you/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_..."
      }
    }
  }
}
```

**Debugging:**
```bash
# Test MCP server manually
npx -y @anthropic-ai/mcp-filesystem-server /tmp

# Check Cursor logs
View > Output > MCP
```

---

### 6. Agent Mode Stuck

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Agent keeps running indefinitely                                            │
│  "Thinking..." never completes                                               │
│  Agent makes wrong assumptions                                               │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Press **Escape** to stop current operation
2. Click "Stop" button in chat
3. Start new chat session
4. Reload window: `Cmd+Shift+P > Developer: Reload Window`

**Prevention:**
- Be specific in prompts
- Use @file to provide exact context
- Break large tasks into smaller steps

---

### 7. Composer Not Applying Changes

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Composer shows diff but "Apply" does nothing                                │
│  Changes don't persist after applying                                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Save all files before using Composer
2. Check file isn't read-only
3. Reload window
4. Check for conflicting extensions

---

### 8. Extension Conflicts

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Cursor features not working                                                 │
│  IDE crashes or freezes                                                      │
│  Unexpected behavior                                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Known Conflicting Extensions:**
- GitHub Copilot (disable when using Cursor AI)
- Other AI coding assistants
- Some vim emulation extensions

**Debug:**
1. Disable all extensions
2. Enable one by one to find conflict
3. Report to forum.cursor.com

---

## Configuration

### .cursorrules

Project-level AI instructions:

```
# .cursorrules

You are an expert in TypeScript and React.

Always:
- Use functional components with hooks
- Add JSDoc comments to exported functions
- Use strict TypeScript (no any)

Never:
- Use class components
- Commit console.log statements
- Skip error handling
```

### Settings Locations

| Setting | Location |
|---------|----------|
| Global | `~/.cursor/settings.json` |
| MCP Servers | `~/.cursor/mcp.json` |
| Project Rules | `.cursorrules` |
| Ignore Files | `.cursorignore` |

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘L` | Open Chat |
| `⌘I` | Open Composer |
| `⌘K` | Inline Edit |
| `⌘Shift+L` | Add selection to Chat |
| `⌘Shift+K` | Generate in selection |
| `Tab` | Accept autocomplete |
| `Escape` | Cancel current operation |

---

## Verification Commands

```bash
# Check Cursor version
# Help > About

# View logs
# View > Output > [Select: Cursor, MCP, Indexing]

# Reset Cursor
rm -rf ~/.cursor/Cache
rm -rf ~/.cursor/CachedData
# Restart Cursor
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [MCP Server Errors](./mcp-server-errors.md) | Common MCP patterns |
| [Provider Errors](./provider-errors.md) | API provider errors |
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Initial Cursor error patterns |

---

*Last updated: 2026-02-07 | Source: docs.cursor.com*
*Maintainer: claude-error-prevention | License: MIT*
