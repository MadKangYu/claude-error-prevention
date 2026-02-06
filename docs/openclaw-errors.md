# OpenClaw Error Patterns

## System Overview

| Component | Location/Port |
|-----------|---------------|
| Gateway | `localhost:18789` |
| Config | `~/.openclaw/openclaw.json` |
| Cron | `~/.openclaw/cron/jobs.json` |
| Version | 2026.2.3-1 |

## Configuration

### Config File Location

```
~/.openclaw/
├── openclaw.json       # 메인 설정
├── cron/
│   └── jobs.json       # 크론 작업
└── docker-compose.browserless.yml
```

### Common Config Errors

| Mistake | Problem | Fix |
|---------|---------|-----|
| Claude Code 경로 사용 | `~/.claude/` 에 설정 | `~/.openclaw/` 사용 |
| Gateway 포트 충돌 | 18789 사용 중 | 포트 변경 또는 프로세스 종료 |
| Auth profile 누락 | Provider 인증 실패 | `openclaw.json` auth 섹션 확인 |

## Agents

### Agent Configuration

| ID | Model | Telegram |
|----|-------|----------|
| main | haiku | @Mad_Yu_Bot |
| study | sonnet | @Study_Yu_Bot |
| madstamp | sonnet | @MadstampCEO_Bot |
| github | haiku | @GitBub_Yu_Bot |
| opencode | sonnet | @oh_my_opencode_bot |
| openclaw-learn | haiku | @OpenClaw8723Bot |

### Agent Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Agent not responding | Gateway down | `launchctl start openclaw.gateway` |
| Wrong model used | Config 오류 | `openclaw.json` models 섹션 확인 |
| Telegram 연결 실패 | Token 만료 | @BotFather에서 토큰 재발급 |

## Services

### Service Status Check

```bash
# Gateway
curl -s http://localhost:18789/health

# Browserless
curl -s http://localhost:3000/health

# CouchDB
curl -s http://localhost:5984/
```

### Common Service Errors

| Service | Port | Error | Fix |
|---------|------|-------|-----|
| Gateway | 18789 | Connection refused | launchd 확인 |
| Browserless | 3000 | Container not running | `docker compose up -d` |
| CouchDB | 5984 | Auth failed | credentials 확인 |

## Security

### Security Settings

| Setting | Value | Description |
|---------|-------|-------------|
| Sandbox | `non-main` | 메인 외 에이전트 샌드박스 |
| mDNS | minimal | 최소 노출 |
| Logging | redact | 민감정보 삭제 |
| Policy | allowlist | dm/group 허용 목록 |

### Security Errors

| Error | Cause | Fix |
|-------|-------|-----|
| .env 노출 | Git에 커밋됨 | .gitignore 추가, 토큰 교체 |
| Token leak | 히스토리에 남음 | BFG Repo-Cleaner로 제거 |
| Unauthorized access | allowlist 미설정 | policy 설정 |

## Provider Authentication

### Auth Profiles

```json
{
  "auth": {
    "profiles": {
      "anthropic:oauth": { "provider": "anthropic", "mode": "oauth" },
      "openai:oauth": { "provider": "openai", "mode": "oauth" },
      "google-antigravity:email": { "provider": "google-antigravity", "mode": "oauth" }
    }
  }
}
```

### Auth Errors

| Error | Cause | Fix |
|-------|-------|-----|
| OAuth expired | 토큰 만료 | 재인증 |
| Provider not found | Profile 없음 | auth.profiles에 추가 |
| Rate limit | 사용량 초과 | 다른 provider fallback |

## Model Configuration

### Model Aliases

| Alias | Model ID |
|-------|----------|
| opus46 | claude-opus-4-6-20260205 |
| sonnet | claude-sonnet-4-5-20250929 |
| haiku | claude-haiku-4-5-20251001 |

### Model Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Model not found | Alias 오타 | 정확한 ID 사용 |
| Context exceeded | 토큰 초과 | 작은 모델 또는 /compact |
| Fallback failed | 모든 provider 실패 | 최소 하나 인증 확인 |

## Verification

```bash
# Config 검증
cat ~/.openclaw/openclaw.json | jq '.meta.lastTouchedVersion'

# Gateway 상태
curl -s http://localhost:18789/health

# Services 상태
docker ps | grep -E "(browserless|couchdb)"

# Agent 목록
cat ~/.openclaw/openclaw.json | jq '.agents | keys'
```

## Pending Actions (from MEMORY.md)

- [ ] Telegram Bot Token rotation (@BotFather) - madstamp-bot .env 노출됨
- [ ] Optional: BFG Repo-Cleaner로 .env git 히스토리 제거
