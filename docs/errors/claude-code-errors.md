# Claude Code Error Patterns & Troubleshooting

> Official error patterns and solutions for Claude Code CLI - sourced from Anthropic documentation

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗                           ║
║  ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝                           ║
║  ██║     ██║     ███████║██║   ██║██║  ██║█████╗                             ║
║  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝                             ║
║  ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗                           ║
║   ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝                           ║
║                           ██████╗ ██████╗ ██████╗ ███████╗                   ║
║                          ██╔════╝██╔═══██╗██╔══██╗██╔════╝                   ║
║                          ██║     ██║   ██║██║  ██║█████╗                     ║
║                          ██║     ██║   ██║██║  ██║██╔══╝                     ║
║                          ╚██████╗╚██████╔╝██████╔╝███████╗                   ║
║                           ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝                   ║
║                                                                              ║
║   Error Prevention System v3.2 | Patterns: 24 | Source: Official Docs       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| Main Docs | https://code.claude.com/docs/en/overview |
| Troubleshooting | https://code.claude.com/docs/en/troubleshooting |
| CLI Reference | https://code.claude.com/docs/en/cli-reference |
| Settings Schema | https://json.schemastore.org/claude-code-settings.json |
| Settings Reference | https://code.claude.com/docs/en/settings |
| MCP Documentation | https://code.claude.com/docs/en/mcp |
| Hooks Reference | https://code.claude.com/docs/en/hooks |
| Permissions | https://code.claude.com/docs/en/permissions |
| GitHub Issues | https://github.com/anthropics/claude-code/issues |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          CLAUDE CODE QUICK FIX                               │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "command not found: claude"      │ Add ~/.local/bin to PATH                 │
│  "API Error: 500"                 │ Check status.anthropic.com, retry        │
│  "exec: node: not found" (WSL)    │ Install Node via Linux pkg manager       │
│  "Sandbox requires socat"         │ apt install bubblewrap socat             │
│  MCP server "failed"              │ Check stderr, may be false positive      │
│  Repeated permission prompts      │ Add to permissions.allow in settings     │
│  Search not working               │ brew install ripgrep                     │
│  Settings ignored                 │ Check location & JSON syntax             │
│  Authentication loop              │ rm ~/.config/claude-code/auth.json       │
│  High memory usage                │ Run /compact, restart session            │
│  Windows npx MCP fails            │ Use: cmd /c npx -y @package              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Installation Errors

### 1.1 Windows: Git Bash Required

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Claude Code on Windows requires git-bash                                    │
│                                                                              │
│  Git for Windows (including Git Bash) is not installed or not detected.     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```powershell
# Option 1: Install Git for Windows
# Download from: https://git-scm.com/downloads/win

# Option 2: Set path explicitly
$env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"

# Option 3: Add to system environment variables permanently
# System Properties → Environment Variables → Add CLAUDE_CODE_GIT_BASH_PATH
```

**Source:** [Official Troubleshooting](https://code.claude.com/docs/en/troubleshooting)

---

### 1.2 Windows: Command Not Found After Install

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  installMethod is native, but claude command not found                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```powershell
# Add to User PATH
# 1. Press Win + R, type sysdm.cpl, press Enter
# 2. Click Advanced → Environment Variables
# 3. Under "User variables", select Path and click Edit
# 4. Click New and add: %USERPROFILE%\.local\bin
# 5. Restart terminal

# Verify installation
claude doctor
```

---

### 1.3 WSL: OS/Platform Detection Issues

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  npm ERR! notsup Unsupported platform for @anthropic-ai/claude-code          │
│  npm ERR! notsup Valid OS: darwin, linux                                     │
│  npm ERR! notsup Actual OS: win32                                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** WSL using Windows npm instead of Linux npm

**Solution:**
```bash
# Option 1: Configure npm for Linux
npm config set os linux

# Option 2: Force installation
npm install -g @anthropic-ai/claude-code --force --no-os-check
# DO NOT use sudo

# Option 3: Use native installer (recommended)
curl -fsSL https://claude.ai/install.sh | bash
```

---

### 1.4 WSL: Node Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  exec: node: not found                                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** WSL using Windows Node.js instead of Linux version

**Solution:**
```bash
# Check current paths
which npm
which node
# Should point to /usr/... not /mnt/c/...

# Install Node via Linux package manager (Ubuntu/Debian):
sudo apt update && sudo apt install nodejs npm

# Or use nvm (recommended):
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts
```

---

### 1.5 WSL: nvm Version Conflicts

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Node version keeps reverting to Windows version                             │
│  which npm shows /mnt/c/... path instead of Linux path                       │
│  Broken functionality after switching Node versions with nvm in WSL          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** WSL imports Windows PATH by default, Windows nvm/npm takes priority

**Solution 1: Ensure nvm loads in non-interactive shells (Recommended)**

Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Load nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

Or run directly:
```bash
source ~/.nvm/nvm.sh
```

**Solution 2: Adjust PATH order**

Add to shell config:
```bash
export PATH="$HOME/.nvm/versions/node/$(node -v)/bin:$PATH"
```

> ⚠️ **Avoid**: Disabling Windows PATH (`appendWindowsPath = false`) breaks Windows executable calls from WSL.

---

### 1.6 Alpine Linux: Missing Dependencies

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: GLIBC_2.x not found                                                  │
│  Or: musl/uClibc compatibility issues                                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Alpine uses musl libc, not glibc

**Solution:**
```bash
# Install required dependencies
apk add libgcc libstdc++ ripgrep

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Set environment
export USE_BUILTIN_RIPGREP=0
```

---

### 1.8 WSL: Sandbox Dependencies Missing

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Sandbox requires socat and bubblewrap                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Ubuntu/Debian
sudo apt-get install bubblewrap socat

# Fedora
sudo dnf install bubblewrap socat

# Note: WSL1 does not support sandboxing
```

---

### 1.9 Linux/Mac: Permission Errors

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  EACCES: permission denied, mkdir '/usr/local/lib/node_modules'              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution (Native Installation - Recommended):**
```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Install specific version
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58

# Ensure ~/.local/bin is in PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 2. API & Server Errors

### 2.1 API Error 500 (Internal Server Error)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  API Error: 500 {"type":"error","error":{"type":"api_error",                 │
│  "message":"Internal server error"}}                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Diagnosis Flow:**
```
API Error 500?
      │
      ├─▶ Check status.anthropic.com
      │        │
      │        ├─▶ Outage? → Wait for resolution
      │        │
      │        └─▶ No outage? → Continue debugging
      │
      ├─▶ Try different model
      │        │
      │        └─▶ claude -p --fallback-model sonnet "query"
      │
      └─▶ Switch provider (if configured)
               │
               └─▶ AWS Bedrock / Google Vertex AI
```

**Solution:**
```bash
# 1. Check Anthropic status page
# Visit: https://status.anthropic.com

# 2. Wait and retry (usually resolves within minutes to hours)

# 3. Use fallback model (print mode only)
claude -p --fallback-model sonnet "your query"

# 4. Switch to AWS Bedrock or Google Vertex AI if configured
# See: https://code.claude.com/docs/en/third-party-integrations
```

**Recent Outage:** January 22, 2026 - Major service disruption

---

### 2.2 Authentication Failures

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Authentication failed. Please try logging in again.                         │
│                                                                              │
│  Or: Repeated login prompts                                                  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Step 1: Sign out completely
/logout

# Step 2: Remove stored auth
rm -rf ~/.config/claude-code/auth.json

# Step 3: Restart and re-authenticate
claude

# If browser doesn't open automatically:
# Press 'c' to copy OAuth URL, then paste in browser

# Step 4: Verify authentication
claude doctor
```

---

## 3. MCP Server Errors

### 3.1 MCP Server Shows "Failed" (False Positive)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ MCP STATUS                                                                   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ✓ filesystem    Running                                                     │
│  ✗ myserver      Failed                                                      │
│                                                                              │
│  But the server is actually working...                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Claude Code treats any stderr output as an error, even for informational messages.

**Solution:**
```bash
# Workaround: Redirect stderr in MCP server command
claude mcp add --transport stdio myserver -- npx -y server 2>/dev/null

# Or configure server to suppress stderr warnings
# Check server documentation for quiet/silent mode flags
```

**Source:** [GitHub Issue #17653](https://github.com/anthropics/claude-code/issues/17653)

---

### 3.2 OAuth: Dynamic Client Registration Not Supported

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Incompatible auth server: does not support dynamic client registration      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Step 1: Register OAuth app with the server's developer portal
# Note your client ID, client secret, and redirect URI

# Step 2: Add server with credentials
claude mcp add --transport http \
  --client-id your-client-id \
  --client-secret \
  --callback-port 8080 \
  my-server https://mcp.example.com/mcp

# Step 3: Authenticate in Claude Code
# Run: /mcp
# Follow browser login flow
```

---

### 3.3 MCP Environment Variables Not Working

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  MCP server not receiving API_KEY or other environment variables             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Correct format for stdio servers:
claude mcp add --transport stdio \
  --env API_KEY=your_key \
  --env BASE_URL=https://api.example.com \
  myserver -- npx -y server-package

# For .mcp.json file:
{
  "mcpServers": {
    "myserver": {
      "command": "npx",
      "args": ["-y", "server-package"],
      "env": {
        "API_KEY": "${API_KEY}",
        "BASE_URL": "https://api.example.com"
      }
    }
  }
}

# Ensure environment variables are exported in shell
export API_KEY=your_key
```

---

### 3.4 Windows: npx MCP Servers Fail

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Connection closed                                                           │
│  spawn npx ENOENT                                                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Windows cannot directly execute npx without cmd wrapper

**Solution:**
```bash
# Correct format for Windows native (not WSL):
claude mcp add --transport stdio myserver -- cmd /c npx -y @some/package

# Incorrect (will fail):
claude mcp add --transport stdio myserver -- npx -y @some/package
```

---

### 3.5 MCP Configuration File Location

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ MCP CONFIGURATION LOCATIONS                                                  │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ✓ CORRECT:                                                                  │
│    • User/Local: ~/.claude.json (in mcpServers field)                        │
│    • Project:    .mcp.json (in project root)                                 │
│    • Managed:    /Library/Application Support/ClaudeCode/managed-mcp.json    │
│                                                                              │
│  ✗ INCORRECT (deprecated):                                                   │
│    • ~/.config/claude-code/mcp.json                                          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Verify configuration:**
```bash
claude mcp list
claude mcp get <server-name>
```

---

## 4. Settings.json Errors

### 4.1 JSON Schema Validation

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Invalid settings.json: Unexpected token '}' at position 123                 │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```json
// Add schema for validation in VS Code/Cursor:
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run test)"],
    "deny": ["Read(.env)"]
  }
}
```

**Common mistakes:**
- ❌ Trailing commas
- ❌ Single quotes instead of double quotes
- ❌ Missing brackets/braces
- ❌ Incorrect setting names

**Verify:**
```bash
claude doctor
```

---

### 4.2 outputStyle: Expected String, Received Object

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  /Users/user/.claude/settings.json                                           │
│   └ outputStyle: Expected string, but received object                        │
│                                                                              │
│  Files with errors are skipped entirely, not just the invalid settings.      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** `outputStyle` was set as an object instead of a string. The entire settings file is skipped when any field has a type error.

```json
// ❌ WRONG — object type
"outputStyle": { "name": "explanatory" }

// ✅ CORRECT — string type
"outputStyle": "explanatory"
```

**Valid values:** Any string with `minLength: 1`. Built-in styles: `"default"`, `"Explanatory"`, `"Learning"`. Custom styles go in `~/.claude/output-styles/`.

**Source:** [Output Styles](https://code.claude.com/docs/en/output-styles) · [JSON Schema](https://json.schemastore.org/claude-code-settings.json)

---

### 4.3 Permission Rules: Wildcard-Only Specifier Fails Regex

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Permission rule "Read(*)" silently fails schema regex validation            │
│  Same for: Write(*), Edit(*), Glob(*), Grep(*), WebSearch(*)                │
│                                                                              │
│  Rules are ignored — permissions don't apply as expected                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** The schema regex `(\((?=.*[^)*?])[^)]+\))?` requires at least one character inside `()` that is NOT `*`, `)`, or `?`. A specifier of just `*` fails the lookahead.

```json
// ❌ WRONG — wildcard-only specifier fails regex
"Read(*)", "Write(*)", "Edit(*)", "Glob(*)", "Grep(*)", "WebSearch(*)"

// ✅ CORRECT — omit specifier to match all
"Read", "Write", "Edit", "Glob", "Grep", "WebSearch"

// ✅ ALSO CORRECT — path-based specifier
"Read(./**)", "Edit(src/**/*.ts)"
```

**Source:** [Permission Rule Syntax](https://code.claude.com/docs/en/permissions#permission-rule-syntax) · [JSON Schema permissionRule](https://json.schemastore.org/claude-code-settings.json)

---

### 4.4 Local Settings Override: Model Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  There's an issue with the selected model (claude-opus-4-6-20260205).        │
│  It may not exist or you may not have access to it.                          │
│  Run /model to pick a different model.                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** `.claude/settings.local.json` contains `"model": "claude-opus-4-6-20260205"` which overrides `~/.claude/settings.json` `"model": "sonnet"`. Local scope has higher precedence than User scope.

**Precedence (highest → lowest):**
```
Managed > CLI args > Local (.claude/settings.local.json) > Project (.claude/settings.json) > User (~/.claude/settings.json)
```

**Solution:**
```bash
# Check what's overriding your model
cat .claude/settings.local.json | jq '.model'

# Fix: remove model from local settings
# Or reset local settings entirely:
echo '{"$schema":"https://json.schemastore.org/claude-code-settings.json"}' > .claude/settings.local.json
```

**Source:** [Settings Precedence](https://code.claude.com/docs/en/settings#settings-precedence)

---

### 4.5 API Keys Leaked in Permission Allow List

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SECURITY                                                                     │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  .claude/settings.local.json contains hardcoded API keys in allow rules:     │
│                                                                              │
│  "Bash(GROQ_API_KEY=\"gsk_xxx...\" openclaw models:*)"                       │
│  "Bash(OPENROUTER_API_KEY=\"sk-or-v1-xxx...\" openclaw agent:*)"             │
│  "Bash(COUCH_PASS=\"7fce...\")"                                              │
│                                                                              │
│  These are auto-added when you click "Always Allow" for commands             │
│  that contain inline environment variables.                                  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** When Claude runs `SOME_KEY="secret" some-command` and you click "Always Allow", the full command including the secret is saved verbatim to `settings.local.json` permissions.

**Solution:**
```bash
# 1. Audit your local settings for secrets
grep -i "key\|pass\|secret\|token" .claude/settings.local.json

# 2. Reset local settings
echo '{"$schema":"https://json.schemastore.org/claude-code-settings.json"}' > .claude/settings.local.json

# 3. Prevent recurrence: use env vars via settings.json env field
{
  "env": {
    "GROQ_API_KEY": "gsk_xxx..."
  }
}

# 4. Or export in shell profile (~/.zshrc, ~/.bashrc)
export GROQ_API_KEY="gsk_xxx..."
```

**Prevention:** Never click "Always Allow" on commands containing inline secrets. Use `env` in settings or shell profile instead.

---

### 4.6 Non-Schema Fields Silently Ignored

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ INFO                                                                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Fields not in the schema are silently ignored due to                        │
│  "additionalProperties": true                                                │
│                                                                              │
│  Common examples:                                                            │
│    "vimModeEnabled": true      → ignored (use /config toggle)                │
│    "theme": "dark"             → ignored (use /config toggle)                │
│    "filesystem": { ... }       → ignored (use permissions.deny Read/Edit)    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:** Use `$schema` in your settings file for IDE validation:
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
```

UI preferences (`vimModeEnabled`, `theme`) are stored in `~/.claude.json`, not `settings.json`. Use `/config` to toggle them.

**Source:** [JSON Schema](https://json.schemastore.org/claude-code-settings.json)

---

### 4.7 Settings File Priority

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SETTINGS FILE HIERARCHY (highest to lowest priority)                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  SCOPE      │ LOCATION                                                       │
│  ───────────┼──────────────────────────────────────────────────────────────  │
│  Managed    │ /Library/Application Support/ClaudeCode/managed-settings.json  │
│             │ /etc/claude-code/managed-settings.json (Linux)                 │
│             │ C:\Program Files\ClaudeCode\managed-settings.json (Windows)    │
│  Command    │ --settings flag                                                │
│  Local      │ .claude/settings.local.json                                    │
│  Project    │ .claude/settings.json                                          │
│  User       │ ~/.claude/settings.json                                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 4.8 API Key Exposure Response Procedure

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ INCIDENT                                                                     │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  API keys exposed in settings.local.json via auto-added permission rules    │
│                                                                              │
│  LEAKED:                                                                     │
│  - GROQ_API_KEY (gsk_...)                                                    │
│  - OPENROUTER_API_KEY (sk-or-v1-...)                                         │
│  - CouchDB password (plaintext)                                              │
│                                                                              │
│  ROOT CAUSE:                                                                 │
│  Claude Code auto-appends approved commands to permissions.allow list,      │
│  which can include environment variables with sensitive values               │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Response Procedure:**

| Step | Action | Tool |
|------|--------|------|
| 1 | Identify all exposed keys | `grep -r "API_KEY\|SECRET\|PASS" ~/.claude/` |
| 2 | Check git history for leaks | `git log -p -S "API_KEY"` |
| 3 | Revoke/rotate exposed keys | Service console (GROQ, OpenRouter, etc.) |
| 4 | Generate new keys | Service console |
| 5 | Update `.env` with new keys | Edit `~/.config/opencode/config/.env` |
| 6 | Clear settings.local.json | Reset to `{"$schema": "..."}` only |
| 7 | Add to .gitignore | `echo "settings.local.json" >> .gitignore` |

**Service Console URLs:**

| Service | Console URL | Key Format |
|---------|-------------|------------|
| GROQ | https://console.groq.com/keys | `gsk_...` |
| OpenRouter | https://openrouter.ai/settings/keys | `sk-or-v1-...` |
| Anthropic | https://console.anthropic.com/settings/keys | `sk-ant-...` |
| OpenAI | https://platform.openai.com/api-keys | `sk-...` |

**Prevention:**

```json
// ~/.claude/settings.json - Use patterns, not literal values
{
  "permissions": {
    "allow": [
      "Bash(curl *)",      // Pattern matching
      "Read",              // Tool-level allow
      "Write"
    ],
    "deny": [
      "Bash(curl * --header *Authorization*)",  // Block auth headers
      "Bash(* API_KEY=*)",                      // Block key exposure
      "Bash(* SECRET=*)"
    ]
  }
}
```

**Automation (Playwright):**

```typescript
// API key rotation can be automated via browser automation
// See: ~/.agents/skills/playwright/SKILL.md

// 1. Navigate to service console
await page.goto('https://console.groq.com/keys');

// 2. Delete compromised key
await page.getByTestId('delete-button').click();
await page.getByRole('button', { name: 'Revoke Key' }).click();

// 3. Create new key
await page.getByRole('button', { name: 'Create API Key' }).click();
await page.getByTestId('key-name-input').fill('OpenCode-Main');
await page.getByTestId('key-form-submit-button').click();

// 4. Capture new key (shown only once)
const newKey = await page.getByRole('textbox').inputValue();
```

---

## 5. Permission Errors

### 5.1 Repeated Permission Prompts

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Claude keeps asking for permission for the same commands                    │
│                                                                              │
│  "Allow Bash(npm run test)?"  [Yes] [No] [Always]                            │
│  (every single time)                                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# In Claude Code:
/permissions

# Or add to settings.json:
{
  "permissions": {
    "allow": [
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(npm run test *)",
      "Read"
    ]
  }
}

# Use permission modes:
claude --permission-mode acceptAll  # Accept all (use with caution)
claude --permission-mode plan       # Plan mode (review before execution)
```

### 5.2 Permission Rule Patterns

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",           // All npm run commands
      "Bash(git diff *)",          // All git diff commands
      "Read(src/**)",              // All files in src/
      "Edit(src/**/*.ts)",         // TypeScript files in src/
      "WebFetch(domain:github.com)" // Only GitHub
    ],
    "deny": [
      "Bash(curl *)",              // Block curl
      "Bash(rm -rf *)",            // Block dangerous rm
      "Read(.env)",                // Block .env file
      "Read(.env.*)",              // Block .env.* files
      "Read(secrets/**)",          // Block secrets directory
      "WebFetch"                   // Block all web fetching
    ]
  }
}
```

---

## 6. Performance Issues

### 6.1 High CPU/Memory Usage

**Solution:**
```bash
# 1. Compact context regularly
/compact

# 2. Restart Claude Code between major tasks
exit
claude

# 3. Add large directories to permission deny
{
  "permissions": {
    "deny": [
      "Read(node_modules/**)",
      "Read(build/**)",
      "Read(.next/**)"
    ]
  }
}

# 4. Add to .gitignore
echo "node_modules/" >> .gitignore
echo "build/" >> .gitignore
echo "dist/" >> .gitignore
```

### 6.2 Slow or Incomplete Search

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Search tool, @file mentions not working or very slow                        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** System ripgrep not installed

**Solution:**
```bash
# macOS (Homebrew)
brew install ripgrep

# Windows (winget)
winget install BurntSushi.ripgrep.MSVC

# Ubuntu/Debian
sudo apt install ripgrep

# Then set environment variable:
export USE_BUILTIN_RIPGREP=0

# Or in settings.json:
{
  "env": {
    "USE_BUILTIN_RIPGREP": "0"
  }
}
```

---

## 7. IDE Integration Issues

### 7.1 JetBrains IDE Not Detected on WSL2

**Solution:**

**Option 1: Configure Windows Firewall**
```bash
# 1. Find WSL2 IP address
wsl hostname -I
# Example: 172.21.123.456

# 2. Open PowerShell as Administrator
New-NetFirewallRule -DisplayName "Allow WSL2 Internal Traffic" `
  -Direction Inbound -Protocol TCP -Action Allow `
  -RemoteAddress 172.21.0.0/16 -LocalAddress 172.21.0.0/16

# 3. Restart IDE and Claude Code
```

**Option 2: Switch to Mirrored Networking**
```ini
# Add to .wslconfig in Windows user directory
[wsl2]
networkingMode=mirrored

# Then restart WSL
wsl --shutdown
```

### 7.2 Escape Key Not Working in JetBrains Terminals

**Solution:**
```
1. Go to Settings → Tools → Terminal
2. Either:
   - Uncheck "Move focus to the editor with Escape"
   - OR click "Configure terminal keybindings" 
     and delete "Switch focus to Editor" shortcut
3. Apply changes
```

---

## 8. Diagnostic Commands

```bash
# Run comprehensive diagnostics
claude doctor

# Checks:
# - Installation type and version
# - Auto-update status
# - Search functionality (ripgrep)
# - Invalid settings files
# - MCP server configuration
# - Keybinding configuration
# - Context usage warnings
# - Plugin and agent loading

# Check MCP server status
/mcp

# View current settings
/config

# Check permissions
/permissions

# View session info
/info

# Report bugs
/bug
```

---

## 9. Reset Configuration

```bash
# Reset all user settings and state
rm ~/.claude.json
rm -rf ~/.claude/

# Reset project-specific settings
rm -rf .claude/
rm .mcp.json

# Reset authentication
rm -rf ~/.config/claude-code/auth.json

# WARNING: This removes all settings, MCP configs, and session history
```

---

## 10. Markdown Formatting Issues

### 10.1 Missing Language Tags in Code Blocks

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Generated markdown has code blocks without language tags:                   │
│                                                                              │
│  ```                                                                         │
│  function example() { return "hello"; }                                      │
│  ```                                                                         │
│                                                                              │
│  Instead of:                                                                 │
│  ```javascript                                                               │
│  function example() { return "hello"; }                                      │
│  ```                                                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Request: "Add appropriate language tags to all code blocks"
2. Set up PostToolUse formatting hooks
3. Manual review after generation

### 10.2 Inconsistent Spacing

**Solutions:**
1. Request: "Fix spacing and formatting issues in this markdown file"
2. Use formatting tools (prettier) via hooks
3. Document preferences in `CLAUDE.md`

**Best Practices:**
- Be explicit: "properly formatted markdown with language-tagged code blocks"
- Document style in `CLAUDE.md`
- Set up validation hooks

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [OpenCode Errors](./opencode-errors.md) | OpenCode/Crush CLI errors |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Plugin errors |
| [Obsidian Errors](./obsidian-errors.md) | PKM integration |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.2 | 2026-02-08 | Add API key exposure response procedure (4.8) with Playwright automation |
| 3.1 | 2026-02-08 | Update URLs to code.claude.com, add 5 settings.json error cases (4.2-4.6) |
| 3.0 | 2026-02-07 | Initial comprehensive guide from official docs |

---

*Last updated: 2026-02-08 | Source: code.claude.com/docs/en/overview*
*Maintainer: claude-error-prevention | License: MIT*
