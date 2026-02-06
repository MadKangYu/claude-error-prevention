# Real Error Examples

Actual error messages you might see. Copy-paste to search.

---

## Claude Code

### Duplicate Installation
```
Error: Multiple claude binaries found
/usr/local/bin/claude
/Users/username/.local/bin/claude
```
**Fix:** `npm -g uninstall @anthropic-ai/claude-code`

---

### Invalid JSON
```
Error: Failed to parse settings.json
SyntaxError: Unexpected token } in JSON at position 234
```
**Fix:** Check for trailing commas, missing quotes

---

### MCP Server Failed
```
Error: Failed to start MCP server "qmd"
spawn qmd ENOENT
```
**Fix:** Install qmd: `bun install -g https://github.com/tobi/qmd`

---

### Context Exceeded
```
Error: Context window exceeded
Maximum context length is 200000 tokens
```
**Fix:** Use `/compact` or `/clear`

---

## OpenCode / Crush

### uint64 Schema Warning
```
unknown format "uint64" ignored in schema at path "#/properties/lastModifiedTime"
unknown format "uint64" ignored in schema at path "#/$defs/MaterializedViewDefinition/properties/refreshIntervalMs"
```
**Fix:** Safe to ignore (warning only)

---

### No Provider
```
Error: No API key found
Please set ANTHROPIC_API_KEY or configure a provider
```
**Fix:** `export ANTHROPIC_API_KEY="sk-ant-..."`

---

## OpenClaw / Telegram

### Gateway Down
```
Error: Connection refused
curl: (7) Failed to connect to localhost port 18789
```
**Fix:** `launchctl start openclaw.gateway`

---

### Bot Token Invalid
```
Error: 401 Unauthorized
{"ok":false,"error_code":401,"description":"Unauthorized"}
```
**Fix:** Regenerate token at @BotFather

---

### Webhook SSL Error
```
Error: SSL certificate problem
Webhook requires HTTPS with valid certificate
```
**Fix:** Use valid SSL or ngrok for testing

---

## npm / Node

### EACCES Permission
```
npm ERR! Error: EACCES: permission denied
npm ERR! path /usr/local/lib/node_modules
```
**Fix:** Don't use sudo. Fix npm permissions.

---

### Peer Dependency
```
npm ERR! ERESOLVE unable to resolve dependency tree
npm ERR! peer dep missing: react@^18.0.0
```
**Fix:** `npm install --legacy-peer-deps`

---

### Module Not Found
```
Error: Cannot find module '@anthropic-ai/sdk'
```
**Fix:** `npm install @anthropic-ai/sdk`

---

## Git

### Merge Conflict
```
CONFLICT (content): Merge conflict in package.json
Automatic merge failed; fix conflicts and then commit the result.
```
**Fix:** Edit file, remove `<<<<<<<` markers, then `git add && git commit`

---

### Uncommitted Changes
```
error: Your local changes to the following files would be overwritten by merge
Please commit your changes or stash them before you merge.
```
**Fix:** `git stash` or `git commit -am "WIP"`

---

## Network

### Connection Refused
```
Error: connect ECONNREFUSED 127.0.0.1:3000
```
**Fix:** Check if server is running on that port

---

### Timeout
```
Error: ETIMEDOUT
Request timed out after 30000ms
```
**Fix:** Check network, increase timeout

---

### SSL Certificate
```
Error: UNABLE_TO_VERIFY_LEAF_SIGNATURE
Error: self signed certificate
```
**Fix (dev only):** `export NODE_TLS_REJECT_UNAUTHORIZED=0`

---

## Quota / Rate Limit

### Rate Limited
```
Error: 429 Too Many Requests
Rate limit exceeded. Please retry after 60 seconds.
```
**Fix:** Wait and retry, or use different API key

---

### Daily Limit
```
Error: Daily usage limit reached
You have exceeded your daily API quota
```
**Fix:** Wait until reset or upgrade plan

---

## Quick Search Commands

```bash
# Search by error message
./error-engine.sh search "ECONNREFUSED"
./error-engine.sh search "permission denied"
./error-engine.sh search "uint64"
./error-engine.sh search "401"
./error-engine.sh search "timeout"
```
