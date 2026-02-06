# Real Error Examples

Copy-paste error messages to search.

---

## Claude Code

### Duplicate Installation
```
$ which -a claude
/Users/you/.local/bin/claude
/usr/local/bin/claude

$ claude --version
Multiple claude binaries found. Please remove duplicates.
```
**Search:** `./error-engine.sh search "duplicate"`  
**Fix:** `npm -g uninstall @anthropic-ai/claude-code`

---

### Deprecated npm Package
```
$ npm list -g @anthropic-ai/claude-code
/usr/local/lib
└── @anthropic-ai/claude-code@1.0.x

npm WARN deprecated @anthropic-ai/claude-code: Use native installer
```
**Search:** `./error-engine.sh search "deprecated"`  
**Fix:** `npm -g uninstall @anthropic-ai/claude-code && curl -fsSL https://claude.ai/install.sh | bash`

---

### Invalid Settings JSON
```
$ claude
Error: Failed to parse ~/.claude/settings.json
SyntaxError: Unexpected token } in JSON at position 234
```
**Search:** `./error-engine.sh search "json"`  
**Fix:** Validate at https://jsonlint.com/

---

### MCP Connection Failed
```
$ claude
[MCP] Failed to connect to server 'filesystem'
Error: spawn /path/to/server ENOENT
```
**Search:** `./error-engine.sh search "mcp"`  
**Fix:** Check path in `~/.claude/claude_code_config.json`

---

## Crush (OpenCode)

### No Provider
```
$ crush
Error: No API key found
Please configure a provider using /connect
```
**Search:** `./error-engine.sh search "provider"`  
**Fix:** `export ANTHROPIC_API_KEY=sk-ant-...`

---

### uint64 Warning
```
WARN: unknown format "uint64" ignored in schema
```
**Status:** Safe to ignore

---

## OpenClaw

### Unknown Model (NEW)
```
⚠️ Agent failed before reply: Unknown model: anthropic/claude-opus-4-7
Logs: openclaw logs --follow
```
**Search:** `./error-engine.sh search "unknown model"`  
**Cause:** Model ID typo (non-existent version)  
**Fix:**
```bash
openclaw models  # Check available
openclaw config set defaultModel anthropic/claude-opus-4-6
```

---

### Gateway Down
```
$ curl http://localhost:18789/health
curl: (7) Failed to connect to localhost port 18789
```
**Search:** `./error-engine.sh search "gateway"`  
**Fix:** `launchctl start openclaw.gateway`

---

### Telegram No Response
```
[OpenClaw] Telegram webhook timeout
Bot did not respond within 30s
```
**Search:** `./error-engine.sh search "telegram"`  
**Fix:** Check gateway + bot token

---

## Oh My OpenCode

### Ollama JSON Error
```
Error: JSON Parse error: Unexpected EOF
    at OllamaProvider.chat
```
**Search:** `./error-engine.sh search "ollama"`  
**Fix:** Set `"stream": false` in agent config

---

### Plugin Not Loaded
```
$ cat ~/.config/opencode/opencode.json | jq '.plugin'
[]
```
**Search:** `./error-engine.sh search "plugin"`  
**Fix:** `bunx oh-my-opencode install`

---

## System

### npm Permission Denied
```
npm ERR! Error: EACCES: permission denied
npm ERR! code EACCES
```
**Search:** `./error-engine.sh search "permission"`  
**Fix:** Never use `sudo npm`. Use nvm instead.

---

### Rate Limit
```
Error: 429 Too Many Requests
{"error": {"type": "rate_limit_error"}}
```
**Search:** `./error-engine.sh search "rate"`  
**Fix:** Wait or switch provider

---

### Context Exceeded
```
Error: Context window exceeded
Current: 195,000 / Max: 200,000
```
**Search:** `./error-engine.sh search "context"`  
**Fix:** `/compact` or `/clear`

---

## Quick Search

| Error Contains | Search |
|----------------|--------|
| ENOENT | `search "enoent"` |
| EACCES | `search "permission"` |
| 429 | `search "rate"` |
| MCP | `search "mcp"` |
| JSON | `search "json"` |
| Unknown model | `search "model"` |
