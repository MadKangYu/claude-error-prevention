# Claude Code Settings Reference (2026-02-07)

> 공식 문서 기반 검증된 설정 가이드
> Source: https://code.claude.com/docs/en/settings

---

## 검증된 설정 예시

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "Glob(*)",
      "Grep(*)",
      "WebFetch(*)",
      "WebSearch(*)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)"
    ]
  },
  "model": "opus",
  "language": "korean",
  "cleanupPeriodDays": 30,
  "showTurnDuration": true,
  "spinnerTipsEnabled": true,
  "autoUpdatesChannel": "stable",
  "alwaysThinkingEnabled": true,
  "teammateMode": "auto",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

## 설정 검증 테이블

| 설정 | 공식 문서 | 설명 | 예시 값 |
|------|-----------|------|---------|
| `$schema` | ✅ | JSON 스키마 (자동완성 지원) | `"https://json.schemastore.org/claude-code-settings.json"` |
| `model` | ✅ | 기본 모델 설정 | `"opus"`, `"sonnet"`, `"haiku"` |
| `language` | ✅ | 응답 언어 | `"korean"`, `"japanese"`, `"french"` |
| `cleanupPeriodDays` | ✅ | 세션 정리 기간 (일) | `30` (기본값) |
| `showTurnDuration` | ✅ | 턴 소요시간 표시 | `true` |
| `spinnerTipsEnabled` | ✅ | 스피너 팁 표시 | `true` |
| `autoUpdatesChannel` | ✅ | 업데이트 채널 | `"stable"`, `"latest"` |
| `alwaysThinkingEnabled` | ✅ | Extended Thinking 기본 활성화 | `true` |
| `teammateMode` | ✅ | Agent Teams 표시 모드 | `"auto"`, `"in-process"`, `"tmux"` |
| `env` | ✅ | 환경 변수 | `{"KEY": "value"}` |

---

## Permission 설정

### 허용 규칙 (allow)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",      // npm run으로 시작하는 명령
      "Bash(git diff *)",     // git diff 명령
      "Read(~/.zshrc)",       // 특정 파일 읽기
      "Edit(./src/**)",       // src 디렉터리 편집
      "WebFetch(domain:github.com)"  // 특정 도메인 접근
    ]
  }
}
```

### 거부 규칙 (deny)

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",         // .env 파일
      "Read(./.env.*)",       // .env.* 파일들
      "Read(./secrets/**)",   // secrets 디렉터리
      "Bash(curl *)",         // curl 명령 차단
      "Bash(rm -rf *)"        // 위험한 삭제 차단
    ]
  }
}
```

---

## Agent Teams 설정

### 활성화 방법

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "teammateMode": "auto"
}
```

### teammateMode 옵션

| 값 | 설명 |
|----|------|
| `"auto"` | tmux/iTerm2면 split-pane, 아니면 in-process |
| `"in-process"` | 모든 teammate가 메인 터미널에서 실행 |
| `"tmux"` | split-pane 모드 강제 (tmux 또는 iTerm2 필요) |

---

## Extended Thinking 설정

```json
{
  "alwaysThinkingEnabled": true
}
```

또는 CLI에서:
```bash
claude --thinking
```

---

## 모델 설정

### Alias 사용 (권장)

```json
{
  "model": "opus"    // 최신 Opus 자동 선택
}
```

### Full Name 사용

```json
{
  "model": "claude-sonnet-4-5-20250929"
}
```

### 사용 가능한 모델 (2026-02-07 기준)

| Alias | 설명 |
|-------|------|
| `opus` | Claude Opus 4.6 (최신) |
| `sonnet` | Claude Sonnet 4.5 |
| `haiku` | Claude Haiku (경량) |

---

## 설정 파일 위치

| 스코프 | 위치 | 용도 |
|--------|------|------|
| User | `~/.claude/settings.json` | 개인 전역 설정 |
| Project | `.claude/settings.json` | 팀 공유 (git 커밋) |
| Local | `.claude/settings.local.json` | 개인 프로젝트용 (gitignore) |
| Managed | `/Library/Application Support/ClaudeCode/` | IT 관리자용 |

---

## 주의사항

### Homebrew 설치 시 자동 업데이트 안 됨

```bash
# 수동 업데이트 필요
brew upgrade claude-code
```

### Native vs Homebrew 충돌

```bash
# Native 제거 후 Homebrew만 사용
rm -rf ~/.local/share/claude ~/.local/bin/claude

# 확인
which claude  # /opt/homebrew/bin/claude 여야 함
```

### Native 재설치 방지

```bash
# 이 명령 실행하면 Native 2.1.25가 다시 설치됨 - 실행 금지!
# curl -fsSL https://claude.ai/install.sh | bash
```

---

## 공식 문서 링크

- Settings: https://code.claude.com/docs/en/settings
- Agent Teams: https://code.claude.com/docs/en/agent-teams
- Permissions: https://code.claude.com/docs/en/permissions
- Extended Thinking: https://code.claude.com/docs/en/common-workflows#use-extended-thinking-thinking-mode

---

*Last verified: 2026-02-07*
*Claude Code version: 2.1.34*
*Source: code.claude.com/docs/en/settings*
