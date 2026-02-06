# Oh My OpenCode Error Patterns

## Security Warning

> **ohmyopencode.com is NOT affiliated with the official project.**
> Official downloads: https://github.com/code-yeongyu/oh-my-opencode/releases

## Installation

### Official Methods

```bash
# npm (recommended)
npm install -g oh-my-opencode@latest

# Or from releases
https://github.com/code-yeongyu/oh-my-opencode/releases
```

### Common Installation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Impersonation site | ohmyopencode.com 사용 | GitHub releases에서만 다운로드 |
| Old version | @latest 미사용 | `oh-my-opencode@latest` 명시 |
| npm permission | sudo 사용 | sudo 없이 설치, nvm 사용 권장 |

## OAuth / Authentication

### Claude OAuth 제한 (2026-01)

> Anthropic has restricted third-party OAuth access citing ToS violations.

| Status | Description |
|--------|-------------|
| Claude Code subscription | 기술적으로 가능하나 ToS 위반 가능성 |
| Official OAuth | 차단됨 |
| Custom OAuth spoofing | 권장하지 않음 |

### Auth Errors

| Error | Cause | Fix |
|-------|-------|-----|
| OAuth blocked | Anthropic 제한 | 다른 provider 사용 |
| ToS violation warning | Claude Code OAuth 사용 | OpenAI/Google 등 대체 |
| Token expired | OAuth 만료 | 재인증 |

## Configuration

### Config Locations

```
~/.config/opencode/        # OpenCode 기본
./.opencode/               # 프로젝트별
./AGENTS.md                # 에이전트 설정
```

### Plugin System

| Plugin | Description |
|--------|-------------|
| oh-my-opencode@latest | 메인 플러그인 |
| opencode-antigravity-auth | Antigravity 인증 |
| opencode-openai-codex-auth | OpenAI Codex 인증 |

## Agents

### Built-in Agents

| Agent | Description |
|-------|-------------|
| oracle | 질의응답 |
| librarian | 코드 검색 |
| frontend engineer | 프론트엔드 작업 |
| sisyphus | 자동 반복 작업 |

### Agent Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Agent not found | AGENTS.md 없음 | `/init` 실행 |
| Permission denied | 권한 설정 | AGENTS.md 확인 |
| Loop stuck | Sisyphus 무한 루프 | 수동 중단 |

## Common Issues (from GitHub)

### OpenCode Official Issues

| Issue | Description | Status |
|-------|-------------|--------|
| Memory consumption | 장시간 사용 후 느려짐 | 알려진 문제 |
| Windows blank GUI | GUI 열리나 빈 화면 | 로그 확인 필요 |
| Web UI no folders | 서버 폴더 안 보임 | 설정 확인 |
| grok-code-fast-1 error | GitHub Copilot 연동 오류 | model ID 확인 |

### Claude Code Official Issues

| Issue | Description | Fix |
|-------|-------------|-----|
| /compact not working | 4.5→4.6 마이그레이션 후 | /clear 사용 |
| vim mode Escape | 입력 중 Escape 오작동 | 알려진 문제 |
| Linux freeze | 2.1.34+ 버전 터미널 멈춤 | 버전 다운그레이드 |
| Session restore fail | sessions-index.json 누락 | 파일 복구 |
| 200K context cap | Opus 4.6 1M인데 200K 제한 | 알려진 문제 |

## Verification

```bash
# 버전 확인
oh-my-opencode --version 2>/dev/null || opencode --version

# 플러그인 확인
cat ~/.config/opencode/opencode.json | jq '.plugin'

# AGENTS.md 존재 확인
ls -la ./AGENTS.md

# OAuth 상태 확인
cat ~/.config/opencode/opencode.json | jq '.auth'
```

## Features

### Unique Features

- Background agents
- LSP/AST tools
- MCP integration
- Claude Code compatibility layer
- Sisyphus (discipline agent)

### Mode Commands

| Command | Description |
|---------|-------------|
| `/init` | AGENTS.md 생성 |
| `/connect` | Provider 연결 |
| `/share` | 대화 공유 |
| `/undo`, `/redo` | 변경 취소/재실행 |
| `Tab` | build ↔ plan 전환 |
