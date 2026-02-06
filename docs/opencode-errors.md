# OpenCode Error Patterns

## Installation

### Official Methods (2026-02-07)

```bash
# Recommended
curl -fsSL https://opencode.ai/install | bash

# Package managers
brew install anomalyco/tap/opencode    # macOS/Linux (최신)
brew install opencode                   # macOS/Linux (덜 최신)
npm i -g opencode-ai@latest             # npm
scoop install opencode                  # Windows
choco install opencode                  # Windows
paru -S opencode-bin                    # Arch Linux
```

### Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| 구버전 설치 | 0.1.x 이전 버전 충돌 | 구버전 먼저 삭제 후 설치 |
| brew vs brew tap 혼동 | 버전 불일치 | `anomalyco/tap/opencode` 사용 |
| npm 구버전 캐시 | 최신 아님 | `npm i -g opencode-ai@latest` |

## Configuration

### Config File Locations

```
$HOME/.config/opencode/opencode.json    # 메인 설정
$HOME/.config/opencode/.mcp.json        # MCP 설정
$HOME/.config/opencode/AGENTS.md        # 에이전트 설정
./.opencode.json                        # 프로젝트별
```

### Common Config Errors

| Mistake | Problem | Fix |
|---------|---------|-----|
| Claude Code 경로 사용 | `~/.claude/` 에 설정 | `~/.config/opencode/` 사용 |
| AGENTS.md 없음 | 에이전트 동작 안 함 | `/init` 실행 |
| provider API key 누락 | 인증 실패 | 환경변수 또는 config에 추가 |

### Environment Variables

```bash
# Required (하나 이상)
ANTHROPIC_API_KEY=      # Claude
OPENAI_API_KEY=         # OpenAI
GEMINI_API_KEY=         # Google
GROQ_API_KEY=           # Groq

# Optional
OPENCODE_INSTALL_DIR=   # 설치 경로
XDG_BIN_DIR=            # XDG 경로
```

## Agent Modes

| Mode | Purpose | Permissions |
|------|---------|-------------|
| **build** | 개발 작업 (기본) | Full access |
| **plan** | 분석/탐색 | Read-only, 명령어 허가 필요 |
| **general** | 복잡한 검색 | Subagent (`@general`) |

### Mode Switch
- `Tab` 키로 build ↔ plan 전환

## Common Errors

### 1. Provider Connection

```
Error: No API key found
```
**Fix**: 환경변수 설정 또는 `/connect` 실행

### 2. Old Version Conflict

```
Error: Incompatible version
```
**Fix**:
```bash
# 구버전 삭제
npm uninstall -g opencode-ai
rm -rf ~/.config/opencode  # 필요시

# 재설치
brew install anomalyco/tap/opencode
```

### 3. MCP Server Issues

```
Error: MCP connection failed
```
**Fix**: `.mcp.json` 경로 및 형식 확인

## Schema Errors

### uint64 Format Warning

```
unknown format "uint64" ignored in schema at path "#/properties/lastModifiedTime"
unknown format "uint64" ignored in schema at path "#/$defs/MaterializedViewDefinition/properties/refreshIntervalMs"
unknown format "uint64" ignored in schema at path "#/properties/numRows"
```

| Field | Cause | Impact |
|-------|-------|--------|
| `uint64` format | JSON Schema 표준에 없는 타입 | 경고만, 기능 정상 |
| MCP schema | MCP 서버가 비표준 스키마 사용 | 무시해도 됨 |

**해결**: 무시 가능 (Warning only, not error)

MCP 서버 제작자가 스키마에 `"format": "uint64"` 대신 `"type": "integer"`를 사용해야 함.

## Verification

```bash
# 버전 확인
opencode --version

# 설정 확인
cat ~/.config/opencode/opencode.json | jq '.provider'

# Provider 연결 테스트
opencode
/connect
```
