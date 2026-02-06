# Claude Code MCP - Official Documentation Verification

> Step by step 검증 과정 기록 (2026-02-07)

---

## Step 1: 공식 문서 URL

```
https://code.claude.com/docs/en/mcp
```

---

## Step 2: 검증 방법 - WebFetch vs curl

### ❌ WebFetch (사용 금지)

```bash
# BAD: AI가 요약/해석함
webfetch https://code.claude.com/docs/en/mcp
```

**문제점:**
- AI가 내용을 요약함
- 세부 명령어 누락 가능
- 플래그 순서 등 중요 정보 손실

### ✅ curl (권장)

```bash
# GOOD: Raw 문서 그대로 가져옴
curl -s "https://code.claude.com/docs/en/mcp"

# GitHub raw 파일
curl -s "https://raw.githubusercontent.com/anthropics/claude-code/main/README.md"
```

**장점:**
- 원본 그대로
- 해석/요약 없음
- 검증 가능한 증거

---

## Step 3: MCP 서버 추가 방법 (공식 원문)

### Option 1: HTTP Server (권장)

```bash
# 기본 문법
claude mcp add --transport http <name> <url>

# 예시: Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# 인증 헤더 포함
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### Option 2: SSE Server (Deprecated)

```bash
# 기본 문법
claude mcp add --transport sse <name> <url>

# 예시: Asana
claude mcp add --transport sse asana https://mcp.asana.com/sse
```

**⚠️ SSE는 deprecated. HTTP 사용 권장.**

### Option 3: Stdio Server (로컬)

```bash
# 기본 문법
claude mcp add [options] <name> -- <command> [args...]

# 예시: Airtable
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

---

## Step 4: 중요! 옵션 순서 (공식 원문)

### 공식 문서 원문

> **Important: Option ordering**
>
> All options (`--transport`, `--env`, `--scope`, `--header`) must come **before** the server name. The `--` (double dash) then separates the server name from the command and arguments.

### 올바른 순서

```bash
# ✅ 올바름
claude mcp add --transport stdio --env KEY=value myserver -- npx server

# ❌ 틀림
claude mcp add myserver --transport stdio -- npx server
```

---

## Step 5: MCP Scope 설정 (공식 원문)

### Scope 종류

| Scope | 저장 위치 | 용도 |
|-------|----------|------|
| `local` (기본) | `~/.claude.json` (프로젝트별) | 개인용, 현재 프로젝트만 |
| `project` | `.mcp.json` (프로젝트 루트) | 팀 공유, git commit |
| `user` | `~/.claude.json` | 개인용, 모든 프로젝트 |

### 사용법

```bash
# local (기본값)
claude mcp add --transport http stripe https://mcp.stripe.com

# project (팀 공유)
claude mcp add --transport http paypal --scope project https://mcp.paypal.com/mcp

# user (모든 프로젝트)
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

---

## Step 6: MCP 관리 명령어 (공식 원문)

```bash
# 목록 보기
claude mcp list

# 상세 정보
claude mcp get github

# 삭제
claude mcp remove github

# Claude Code 내에서 상태 확인
/mcp
```

---

## Step 7: .mcp.json 파일 형식 (공식 원문)

```json
{
  "mcpServers": {
    "shared-server": {
      "command": "/path/to/server",
      "args": [],
      "env": {}
    }
  }
}
```

### 환경변수 확장

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

**지원 문법:**
- `${VAR}` - 환경변수 값
- `${VAR:-default}` - 기본값 포함

---

## Step 8: OAuth 인증 (공식 원문)

### 자동 OAuth

```bash
# 1. 서버 추가
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 2. Claude Code 내에서 인증
> /mcp
# 브라우저에서 로그인
```

### 사전 설정 OAuth

```bash
# client-id와 client-secret 필요한 경우
claude mcp add --transport http \
  --client-id your-client-id --client-secret --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```

---

## Step 9: Claude Desktop에서 가져오기 (공식 원문)

```bash
# Claude Desktop 설정 가져오기
claude mcp add-from-claude-desktop

# 대화형으로 선택
# --scope user로 전역 설정 가능
```

**지원:** macOS, WSL만

---

## Step 10: Claude Code를 MCP 서버로 사용 (공식 원문)

```bash
# Claude Code를 MCP 서버로 시작
claude mcp serve
```

### Claude Desktop에서 사용

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

**주의:** `command`에 전체 경로 필요할 수 있음
```bash
which claude  # 경로 확인
```

---

## Step 11: MCP Output 제한 (공식 원문)

| 설정 | 기본값 | 설명 |
|------|--------|------|
| 경고 임계값 | 10,000 tokens | 이상이면 경고 표시 |
| 최대값 | 25,000 tokens | `MAX_MCP_OUTPUT_TOKENS`로 변경 |

```bash
# 제한 늘리기
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

---

## Step 12: MCP Tool Search (공식 원문)

### 자동 활성화 조건

MCP 도구가 context window의 10% 초과시 자동 활성화

### 설정

```bash
# 커스텀 임계값 (5%)
ENABLE_TOOL_SEARCH=auto:5 claude

# 항상 활성화
ENABLE_TOOL_SEARCH=true claude

# 비활성화
ENABLE_TOOL_SEARCH=false claude
```

**지원 모델:** Sonnet 4+, Opus 4+ (Haiku 미지원)

---

## Step 13: Managed MCP (공식 원문)

### 파일 위치

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux/WSL | `/etc/claude-code/managed-mcp.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-mcp.json` |

### 형식

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"]
    }
  }
}
```

---

## Step 14: Windows 주의사항 (공식 원문)

```bash
# Windows에서 npx 사용시 cmd /c 필요
claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package
```

**이유:** Windows는 npx 직접 실행 불가

---

## 발견된 오류 요약

| 항목 | 이전 (틀림) | 공식 (맞음) |
|------|------------|------------|
| MCP 설정 파일 | `~/.claude/claude_code_config.json` | `~/.claude.json` |
| Project scope 파일 | `~/.config/opencode/.mcp.json` 혼동 | `.mcp.json` (프로젝트 루트) |
| SSE transport | 권장인 줄 | **Deprecated**, HTTP 사용 |
| 옵션 순서 | 순서 무관인 줄 | **옵션 → 이름 → -- → 명령** |
| scope 이름 | `global` | `user` (이름 변경됨) |
| scope 이름 | `project` (로컬) | `local` (이름 변경됨) |

---

## 검증 명령어 (재현용)

```bash
# 1. 공식 문서 가져오기 (WebFetch 금지!)
curl -s "https://code.claude.com/docs/en/mcp" > /tmp/mcp-docs.md

# 2. 특정 섹션 추출
grep -A20 "## Installing MCP" /tmp/mcp-docs.md

# 3. 현재 MCP 설정 확인
cat ~/.claude.json | jq '.mcpServers'

# 4. 프로젝트 MCP 확인
cat .mcp.json
```

---

## 출처

- **공식 문서**: https://code.claude.com/docs/en/mcp
- **검증일**: 2026-02-07
- **검증 방법**: curl (NOT WebFetch)
