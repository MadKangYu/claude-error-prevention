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
║   Error Prevention System v3.0 | Patterns: 18 | Source: Official Docs       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| Main Docs | https://docs.anthropic.com/en/docs/claude-code |
| Troubleshooting | https://docs.anthropic.com/en/docs/claude-code/troubleshooting |
| CLI Reference | https://docs.anthropic.com/en/docs/claude-code/cli-reference |
| Settings Schema | https://json.schemastore.org/claude-code-settings.json |
| MCP Documentation | https://docs.anthropic.com/en/docs/claude-code/mcp |
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

**Source:** [Official Troubleshooting](https://docs.anthropic.com/en/docs/claude-code/troubleshooting)

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

### 1.5 WSL: Sandbox Dependencies Missing

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

### 1.6 Linux/Mac: Permission Errors

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
# See: https://docs.anthropic.com/en/docs/claude-code/third-party-integrations
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

### 4.2 Settings File Priority

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

## 10. GitHub Issues (실제 버그 - 2026-02-07)

> 공식 GitHub에서 수집한 실제 버그 패턴

### 10.1 Context Deadlock

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: Deadlock - context limit reached but /compact and rewind both fail      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  증상:                                                                        │
│  - Context 한계 도달                                                          │
│  - /compact 실행 → "Conversation too long" 에러                              │
│  - rewind 실행 → 동일 에러                                                    │
│  - 완전히 막힘                                                                │
│                                                                              │
│  해결:                                                                        │
│  1. 새 세션 시작 (/new 또는 claude 재실행)                                    │
│  2. 50% context에서 미리 /compact                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Source:** [GitHub Issue](https://github.com/anthropics/claude-code/issues)

### 10.2 MCP Server Instructions Not Passed

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: MCP server instructions from initialize response are not passed         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  증상:                                                                        │
│  - MCP 서버의 instructions가 모델에 전달 안됨                                  │
│  - MCP 서버 특정 동작이 무시됨                                                │
│                                                                              │
│  해결:                                                                        │
│  - CLAUDE.md에 MCP 사용법 명시적으로 기재                                     │
│  - 프롬프트에서 직접 MCP 도구 사용 지시                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 10.3 Settings Ignored

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: settings.json 설정이 무시됨                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  알려진 케이스:                                                               │
│  - teammateMode: "tmux" → CLI 플래그 --teammate-mode 필요                     │
│  - autoUpdatesChannel: "stable" → latest로 업데이트됨                         │
│                                                                              │
│  해결:                                                                        │
│  1. claude doctor로 설정 검증                                                 │
│  2. CLI 플래그 직접 사용                                                      │
│  3. JSON 문법 오류 확인 (jq . settings.json)                                  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 10.4 Chat History Loss After Restart

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: PC 재시작 후 채팅 히스토리 손실                                          │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  증상:                                                                        │
│  - /resume으로 20-40%만 복구됨                                                │
│  - 세션 데이터 불완전                                                         │
│                                                                              │
│  예방:                                                                        │
│  - 중요 작업 후 /compact로 요약                                               │
│  - MEMORY.md에 핵심 내용 기록                                                 │
│  - 주기적으로 커밋                                                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 10.5 MCP Servers Mid-Session

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: /mcp로 활성화한 서버가 재시작 전까지 사용 불가                            │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  증상:                                                                        │
│  - /mcp로 서버 활성화                                                         │
│  - 도구가 사용 가능하지 않음                                                  │
│  - Claude 재시작 후에야 작동                                                  │
│                                                                              │
│  해결:                                                                        │
│  - MCP 서버 변경 후 Claude 재시작                                             │
│  - 또는 미리 설정 파일에 추가                                                 │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 10.6 Opus 4.6 Silent Failures

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ BUG: Opus 4.6 reports success without verifying outcomes                     │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  증상:                                                                        │
│  - "완료했습니다" 보고 but 실제 실패                                          │
│  - 검증 없이 성공 선언                                                        │
│                                                                              │
│  예방:                                                                        │
│  - /effort high 사용                                                         │
│  - 검증 단계 명시적 요청                                                      │
│  - "100% 완료" 주장 신뢰하지 않기                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 11. Configuration Files (공식 경로)

> **Source:** https://code.claude.com/docs/en/troubleshooting

| File | Purpose |
|------|---------|
| `~/.claude/settings.json` | User settings (permissions, hooks, model) |
| `.claude/settings.json` | Project settings (source control) |
| `.claude/settings.local.json` | Local project settings (not committed) |
| `~/.claude.json` | Global state (theme, OAuth, MCP servers) |
| `.mcp.json` | Project MCP servers (source control) |

**Managed file locations:**
- macOS: `/Library/Application Support/ClaudeCode/`
- Linux/WSL: `/etc/claude-code/`
- Windows: `C:\Program Files\ClaudeCode\`

---

## 12. 자주 무시되는 문제들

### 12.1 WSL 느린 검색

```
증상: 검색 결과가 예상보다 적음 (완전 실패는 아님)
원인: 크로스 파일시스템 디스크 성능 패널티
해결:
  1. 더 구체적인 검색 쿼리 사용
  2. 프로젝트를 Linux 파일시스템(/home/)으로 이동
  3. WSL 대신 네이티브 Windows 사용
```

### 12.2 /doctor OK인데 실제 문제

```
/doctor는 "OK" 표시하지만:
- WSL 검색 성능 문제는 감지 안 됨
- MCP 서버 instructions 무시는 감지 안 됨
- Settings 일부 무시는 감지 안 됨

→ /doctor만 믿지 말고 실제 동작 테스트
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [OpenCode Errors](./opencode-errors.md) | OpenCode/Crush CLI errors |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Plugin errors |
| [OpenClaw Errors](./openclaw-errors.md) | Gateway/Telegram errors |
| [Context Window](./context-window-ultimate.md) | Memory management |
| [Obsidian Errors](./obsidian-errors.md) | PKM integration |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.1 | 2026-02-07 | Add GitHub issues, config paths, ignored problems |
| 3.0 | 2026-02-07 | Initial comprehensive guide from official docs |

---

*Last updated: 2026-02-07*
*Source: https://code.claude.com/docs/en/troubleshooting*
*GitHub: https://github.com/anthropics/claude-code/issues*
*Maintainer: claude-error-prevention | License: MIT*
