# Claude Code Settings - Official Documentation Verification

> Step by step 검증 과정 기록 (2026-02-07)

---

## Step 1: 공식 문서 URL

```
https://code.claude.com/docs/en/settings
```

---

## Step 2: Configuration Scopes (공식 원문)

| Scope | Location | Who it affects | Shared with team? |
|-------|----------|----------------|-------------------|
| **Managed** | System-level `managed-settings.json` | All users on the machine | Yes (deployed by IT) |
| **User** | `~/.claude/` directory | You, across all projects | No |
| **Project** | `.claude/` in repository | All collaborators on this repository | Yes (committed to git) |
| **Local** | `.claude/*.local.*` files | You, in this repository only | No (gitignored) |

---

## Step 3: Settings Files 위치 (공식 원문)

### 이전에 틀렸던 것

```
~/.claude/settings.json           # 있는 줄 알았음
~/.mcp.json                       # deprecated인 줄 몰랐음
~/.claude/claude_code_config.json # 이게 맞는 줄 알았음
```

### 공식 문서 원문

| Feature | User location | Project location | Local location |
|---------|---------------|------------------|----------------|
| **Settings** | `~/.claude/settings.json` | `.claude/settings.json` | `.claude/settings.local.json` |
| **Subagents** | `~/.claude/agents/` | `.claude/agents/` | — |
| **MCP servers** | `~/.claude.json` | `.mcp.json` | `~/.claude.json` (per-project) |
| **Plugins** | `~/.claude/settings.json` | `.claude/settings.json` | `.claude/settings.local.json` |
| **CLAUDE.md** | `~/.claude/CLAUDE.md` | `CLAUDE.md` or `.claude/CLAUDE.md` | `CLAUDE.local.md` |

### 중요 발견

1. **MCP 설정**: `~/.claude.json` (NOT `~/.claude/claude_code_config.json`)
2. **Project MCP**: `.mcp.json` (프로젝트 루트)
3. **Managed**: `/Library/Application Support/ClaudeCode/` (시스템 레벨)

---

## Step 4: settings.json 스키마 (공식 원문)

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run test *)",
      "Read(~/.zshrc)"
    ],
    "deny": [
      "Bash(curl *)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ]
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp"
  }
}
```

### $schema URL

```
https://json.schemastore.org/claude-code-settings.json
```

**이전 틀린 정보:**
```
https://json.schemastore.org/claude-code-settings  # .json 누락
```

---

## Step 5: 모든 Settings 옵션 (공식 원문)

| Key | Description | Example |
|-----|-------------|---------|
| `apiKeyHelper` | 커스텀 API 키 생성 스크립트 | `/bin/generate_temp_api_key.sh` |
| `cleanupPeriodDays` | 세션 자동 삭제 기간 (기본: 30일) | `20` |
| `companyAnnouncements` | 시작시 표시할 공지 | `["Welcome to Acme Corp!"]` |
| `env` | 환경변수 설정 | `{"FOO": "bar"}` |
| `attribution` | git commit/PR 귀속 설정 | `{"commit": "🤖 Generated", "pr": ""}` |
| `permissions` | 권한 설정 | 아래 참조 |
| `hooks` | 라이프사이클 훅 | `/en/hooks` 참조 |
| `disableAllHooks` | 모든 훅 비활성화 | `true` |
| `model` | 기본 모델 오버라이드 | `"claude-sonnet-4-5-20250929"` |
| `statusLine` | 상태 라인 커스터마이징 | `{"type": "command", "command": "~/.claude/statusline.sh"}` |
| `outputStyle` | 출력 스타일 | `"Explanatory"` |
| `forceLoginMethod` | 로그인 방법 강제 | `claudeai` 또는 `console` |
| `enableAllProjectMcpServers` | 프로젝트 MCP 자동 승인 | `true` |
| `language` | 응답 언어 설정 | `"japanese"` |
| `autoUpdatesChannel` | 업데이트 채널 | `"stable"` 또는 `"latest"` |
| `plansDirectory` | 플랜 저장 위치 | `"./plans"` |
| `showTurnDuration` | 턴 소요시간 표시 | `true` |
| `spinnerVerbs` | 스피너 동사 커스터마이징 | `{"mode": "append", "verbs": ["Pondering"]}` |
| `prefersReducedMotion` | 애니메이션 감소 | `true` |
| `teammateMode` | 에이전트 팀 표시 방식 | `"auto"`, `"in-process"`, `"tmux"` |

---

## Step 6: Permission Settings (공식 원문)

### Permission Keys

| Key | Description | Example |
|-----|-------------|---------|
| `allow` | 자동 허용 규칙 | `["Bash(git diff *)"]` |
| `ask` | 확인 요청 규칙 | `["Bash(git push *)"]` |
| `deny` | 거부 규칙 | `["WebFetch", "Read(./.env)"]` |
| `additionalDirectories` | 추가 작업 디렉토리 | `["../docs/"]` |
| `defaultMode` | 기본 권한 모드 | `"acceptEdits"` |
| `disableBypassPermissionsMode` | bypass 모드 비활성화 | `"disable"` |

### Permission Rule 문법

| Rule | Effect |
|------|--------|
| `Bash` | 모든 Bash 명령 |
| `Bash(npm run *)` | npm run으로 시작하는 명령 |
| `Read(./.env)` | .env 파일 읽기 |
| `WebFetch(domain:example.com)` | example.com 접근 |

---

## Step 7: Sandbox Settings (공식 원문)

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "allowUnixSockets": ["/var/run/docker.sock"],
      "allowLocalBinding": true
    }
  }
}
```

---

## Step 8: Settings 우선순위 (공식 원문)

```
1. Managed settings (최고 우선순위)
   └── IT/DevOps가 배포, 오버라이드 불가

2. Command line arguments
   └── 세션 임시 오버라이드

3. Local project settings (.claude/settings.local.json)
   └── 개인 프로젝트 설정

4. Shared project settings (.claude/settings.json)
   └── 팀 공유 설정

5. User settings (~/.claude/settings.json)
   └── 개인 전역 설정 (최저 우선순위)
```

---

## Step 9: Managed Settings 경로 (공식 원문)

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/` |
| Linux/WSL | `/etc/claude-code/` |
| Windows | `C:\Program Files\ClaudeCode\` |

**파일들:**
- `managed-settings.json`
- `managed-mcp.json`
- `CLAUDE.md`

---

## Step 10: Subagent 설정 (공식 원문)

| Location | Purpose |
|----------|---------|
| `~/.claude/agents/` | 모든 프로젝트에서 사용 가능 |
| `.claude/agents/` | 프로젝트 전용 (팀 공유 가능) |

---

## Step 11: 민감한 파일 제외 (공식 원문)

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Read(./build)"
    ]
  }
}
```

**이전 틀린 정보:** `ignorePatterns` 사용 → **Deprecated**

---

## Step 12: Attribution 설정 (공식 원문)

### 기본값

**Commit:**
```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**PR:**
```
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

### 비활성화

```json
{
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

---

## 발견된 오류 요약

| 항목 | 이전 (틀림) | 공식 (맞음) |
|------|------------|------------|
| MCP 설정 파일 | `~/.claude/claude_code_config.json` | `~/.claude.json` |
| Project MCP | `~/.config/opencode/.mcp.json` 혼동 | `.mcp.json` (프로젝트 루트) |
| Schema URL | `.json` 누락 | `https://json.schemastore.org/claude-code-settings.json` |
| ignorePatterns | 사용 | **Deprecated** → `permissions.deny` 사용 |
| Managed 경로 | 몰랐음 | `/Library/Application Support/ClaudeCode/` |

---

## 출처

- **공식 문서**: https://code.claude.com/docs/en/settings
- **검증일**: 2026-02-07
