# MCP Server Error Patterns & Troubleshooting

> Common error patterns for Model Context Protocol (MCP) servers across all tools

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║  ███╗   ███╗ ██████╗██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗   ║
║  ████╗ ████║██╔════╝██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝   ║
║  ██╔████╔██║██║     ██████╔╝    ███████╗█████╗  ██████╔╝██║   ██║█████╗     ║
║  ██║╚██╔╝██║██║     ██╔═══╝     ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝     ║
║  ██║ ╚═╝ ██║╚██████╗██║         ███████║███████╗██║  ██║ ╚████╔╝ ███████╗   ║
║  ╚═╝     ╚═╝ ╚═════╝╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝   ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 12 | Source: Official MCP Spec   ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| MCP Specification | https://spec.modelcontextprotocol.io |
| MCP Servers Repo | https://github.com/modelcontextprotocol/servers |
| TypeScript SDK | https://github.com/modelcontextprotocol/typescript-sdk |
| Python SDK | https://github.com/modelcontextprotocol/python-sdk |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          MCP SERVER QUICK FIX                                │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "Failed to start MCP server"     │ Check command path exists                │
│  "Connection refused"             │ Verify port not in use                   │
│  "Invalid JSON-RPC response"      │ Check server stdout is clean             │
│  "Tool not found"                 │ Verify tool name in server manifest      │
│  "Permission denied"              │ Check file/API permissions               │
│  "Timeout waiting for response"   │ Increase timeout, check server logs      │
│  "Schema validation failed"       │ Verify tool input matches schema         │
│  "Server crashed"                 │ Check server logs, memory usage          │
│  "Transport error"                │ Verify stdio/SSE configuration           │
│  "Resource not found"             │ Check resource URI format                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## MCP Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          MCP ARCHITECTURE                                    │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │                           HOST APPLICATION                               ││
│  │  (Claude Code, Cursor, OpenCode, etc.)                                  ││
│  │                                                                         ││
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                     ││
│  │  │ MCP Client  │  │ MCP Client  │  │ MCP Client  │                     ││
│  │  │  (Server 1) │  │  (Server 2) │  │  (Server N) │                     ││
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                     ││
│  └─────────┼────────────────┼────────────────┼─────────────────────────────┘│
│            │                │                │                               │
│            │    JSON-RPC    │    JSON-RPC    │    JSON-RPC                  │
│            │    over        │    over        │    over                      │
│            │    stdio/SSE   │    stdio/SSE   │    stdio/SSE                 │
│            │                │                │                               │
│  ┌─────────┼────────────────┼────────────────┼─────────────────────────────┐│
│  │         ▼                ▼                ▼                              ││
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                      ││
│  │  │ MCP Server  │  │ MCP Server  │  │ MCP Server  │                      ││
│  │  │ (filesystem)│  │  (github)   │  │  (custom)   │                      ││
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                      ││
│  │         │                │                │                              ││
│  │  ┌──────┴──────┐  ┌──────┴──────┐  ┌──────┴──────┐                      ││
│  │  │   Tools     │  │   Tools     │  │   Tools     │                      ││
│  │  │  Resources  │  │  Resources  │  │  Resources  │                      ││
│  │  │   Prompts   │  │   Prompts   │  │   Prompts   │                      ││
│  │  └─────────────┘  └─────────────┘  └─────────────┘                      ││
│  │                       MCP SERVERS                                        ││
│  └──────────────────────────────────────────────────────────────────────────┘│
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Config Locations by Tool

| Tool | Config Path |
|------|-------------|
| Claude Code | `~/.config/claude/claude_desktop_config.json` |
| Cursor | `~/.cursor/mcp.json` |
| OpenCode | `~/.config/opencode/opencode.json` (mcp section) |
| Oh My OpenCode | `~/.config/opencode/oh-my-opencode.json` |

---

## Error Patterns

### 1. Server Failed to Start

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Failed to start MCP server: spawn npx ENOENT                                │
│  Or: MCP server exited with code 1                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. Command not found in PATH
2. npx/node not installed
3. Package doesn't exist

**Solutions:**

```bash
# Verify command exists
which npx
which node

# Test server manually
npx -y @anthropic-ai/mcp-filesystem-server /tmp

# Use absolute paths in config
{
  "command": "/usr/local/bin/npx",
  "args": ["-y", "@anthropic-ai/mcp-filesystem-server", "/tmp"]
}
```

---

### 2. Connection Refused

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Connection refused                                                          │
│  ECONNREFUSED 127.0.0.1:3000                                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. Server not running
2. Port already in use
3. Wrong transport type

**Solutions:**

```bash
# Check if port is in use
lsof -i :3000

# Kill process using port
kill -9 $(lsof -t -i :3000)

# Use stdio transport instead of HTTP
{
  "transport": "stdio"  // Not "http"
}
```

---

### 3. Invalid JSON-RPC Response

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Invalid JSON-RPC response                                                   │
│  Unexpected token in JSON at position 0                                      │
│  Expected JSON-RPC message but got: "Starting server..."                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Server printing non-JSON output to stdout.

**Solutions:**

1. **Redirect logs to stderr:**
```typescript
// In MCP server code
console.error("Debug message");  // Use stderr
// NOT: console.log("Debug message");  // stdout breaks JSON-RPC
```

2. **Suppress startup messages:**
```json
{
  "env": {
    "MCP_QUIET": "1"
  }
}
```

3. **Filter output (workaround):**
```json
{
  "command": "sh",
  "args": ["-c", "npx -y @some/mcp-server 2>/dev/null"]
}
```

---

### 4. Tool Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Tool 'read_file' not found                                                  │
│  Available tools: readFile, writeFile, listFiles                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Tool name mismatch between client request and server definition.

**Solutions:**

1. Check exact tool names:
```bash
# List available tools
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | \
  npx -y @anthropic-ai/mcp-filesystem-server /tmp
```

2. Use correct casing (tools are case-sensitive)

---

### 5. Permission Denied

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  EACCES: permission denied                                                   │
│  Or: 403 Forbidden                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. File system permissions
2. API key missing/invalid
3. Restricted directory access

**Solutions:**

```bash
# Check file permissions
ls -la /path/to/file

# Verify API key in env
{
  "env": {
    "GITHUB_TOKEN": "ghp_...",
    "OPENAI_API_KEY": "sk-..."
  }
}

# Grant access to directories
{
  "args": ["/allowed/path1", "/allowed/path2"]
}
```

---

### 6. Timeout

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Timeout waiting for MCP server response                                     │
│  Operation timed out after 30000ms                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. Slow server startup
2. Long-running tool operation
3. Network issues

**Solutions:**

```json
{
  "timeout": 60000,  // Increase to 60 seconds
  "startupTimeout": 10000  // Startup grace period
}
```

---

### 7. Schema Validation Failed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Invalid tool input                                                          │
│  Missing required property: path                                             │
│  Expected string, got number                                                 │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Tool arguments don't match the defined schema.

**Solution:** Check tool schema and provide correct arguments:

```typescript
// Tool definition
{
  name: "read_file",
  inputSchema: {
    type: "object",
    properties: {
      path: { type: "string" }
    },
    required: ["path"]
  }
}

// Correct usage
{ "path": "/tmp/file.txt" }

// WRONG
{ "file": "/tmp/file.txt" }  // Wrong property name
{ "path": 123 }              // Wrong type
```

---

### 8. Server Crashed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  MCP server crashed unexpectedly                                             │
│  Server exited with signal SIGSEGV                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**

1. **Check server logs:**
```bash
# Run server manually with debug
DEBUG=* npx -y @some/mcp-server
```

2. **Memory issues:**
```json
{
  "env": {
    "NODE_OPTIONS": "--max-old-space-size=4096"
  }
}
```

3. **Update server:**
```bash
npm cache clean --force
npx -y @some/mcp-server@latest
```

---

### 9. Transport Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Transport error: stdio stream closed                                        │
│  SSE connection dropped                                                      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. Server process died
2. Network interruption (SSE)
3. stdio buffer overflow

**Solutions:**

```json
// For stdio transport
{
  "transport": "stdio",
  "restartOnCrash": true
}

// For SSE transport
{
  "transport": "sse",
  "reconnect": true,
  "reconnectInterval": 5000
}
```

---

### 10. Resource Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Resource not found: file:///nonexistent/path                                │
│  Invalid resource URI                                                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Resource URI doesn't match server's resource patterns.

**Solutions:**

1. Check resource URI format:
```
file:///absolute/path           # File resources
github://owner/repo/path        # GitHub resources
custom://resource/id            # Custom resources
```

2. List available resources:
```bash
echo '{"jsonrpc":"2.0","method":"resources/list","id":1}' | \
  npx -y @some/mcp-server
```

---

### 11. Env Variables Not Passed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Missing required environment variable: API_KEY                              │
│  GITHUB_TOKEN is not set                                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:** Set environment variables in MCP config:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    }
  }
}
```

**Security Note:** Never commit tokens to git. Use environment variable references if supported.

---

### 12. Conflicting Server Names

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Duplicate MCP server name: filesystem                                       │
│  Server name collision                                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:** Use unique server names:

```json
{
  "mcpServers": {
    "filesystem-home": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-filesystem-server", "~"]
    },
    "filesystem-projects": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-filesystem-server", "~/projects"]
    }
  }
}
```

---

## Common MCP Servers

| Server | Package | Purpose |
|--------|---------|---------|
| Filesystem | `@anthropic-ai/mcp-filesystem-server` | File operations |
| GitHub | `@anthropic-ai/mcp-github` | GitHub API |
| PostgreSQL | `@anthropic-ai/mcp-postgres` | Database queries |
| Brave Search | `@anthropic-ai/mcp-brave-search` | Web search |
| Memory | `@anthropic-ai/mcp-memory` | Persistent memory |
| Fetch | `@anthropic-ai/mcp-fetch` | HTTP requests |

---

## Debugging Tips

### 1. Test Server Independently

```bash
# Start server in terminal
npx -y @anthropic-ai/mcp-filesystem-server /tmp

# Send test message
echo '{"jsonrpc":"2.0","method":"initialize","params":{"capabilities":{}},"id":1}'
```

### 2. Enable Debug Logging

```json
{
  "env": {
    "DEBUG": "mcp:*",
    "NODE_DEBUG": "mcp"
  }
}
```

### 3. Check Host Application Logs

| Tool | Log Location |
|------|--------------|
| Claude Code | `~/.config/claude/logs/` |
| Cursor | View > Output > MCP |
| OpenCode | `~/.local/share/opencode/logs/` |

---

## Verification Commands

```bash
# Test MCP server
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | \
  npx -y @anthropic-ai/mcp-filesystem-server /tmp

# Check if package exists
npm view @anthropic-ai/mcp-filesystem-server

# Validate config JSON
jq . ~/.cursor/mcp.json
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI |
| [Cursor Errors](./cursor-errors.md) | Cursor IDE |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Oh My OpenCode plugin |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Initial MCP server error patterns |

---

*Last updated: 2026-02-07 | Source: spec.modelcontextprotocol.io*
*Maintainer: claude-error-prevention | License: MIT*
