# Claude Code 치트시트 (에러 안 나는 방법)

> 복잡한 설명 없이, 그냥 이렇게 하면 됨

---

## 1. 설치 (복붙하면 끝)

```bash
# Mac/Linux
curl -fsSL https://claude.ai/install.sh | bash

# 확인
claude --version
```

**❌ 하지 마세요:**
```bash
npm install -g @anthropic-ai/claude-code  # deprecated
sudo npm install  # 절대 금지
brew install claude-code  # --cask 빠짐
```

---

## 2. 메모리 파일 위치

```
~/.claude/CLAUDE.md          ← 개인 설정 (모든 프로젝트)
./CLAUDE.md                  ← 프로젝트 설정 (팀 공유)
./CLAUDE.local.md            ← 프로젝트 개인용 (git 무시됨)
```

**그냥 이렇게:**
```bash
# 프로젝트에서 자동 생성
claude
/init
```

---

## 3. MCP 서버 추가

```bash
# HTTP 서버 (가장 쉬움)
claude mcp add --transport http 이름 URL

# 예시
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

**확인:**
```bash
claude mcp list
```

---

## 4. 설정 파일 위치

| 뭐? | 어디? |
|-----|-------|
| 개인 설정 | `~/.claude/settings.json` |
| MCP 설정 | `~/.claude.json` |
| 프로젝트 MCP | `./.mcp.json` |

---

## 5. 권한 설정 (복붙)

`~/.claude/settings.json`:
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./secrets/**)"
    ]
  }
}
```

---

## 6. 문제 생기면

```bash
# MCP 상태 확인
/mcp

# 메모리 확인
/memory

# 설정 확인
/config
```

---

## 7. 공식 문서 확인법 (AI 믿지 말고)

```bash
# GitHub에서 직접 가져오기
curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md

# 공식 문서
open https://code.claude.com/docs
```

**❌ WebFetch 쓰지 마세요** (AI가 요약해버림)

---

## 8. 흔한 실수 → 해결

| 실수 | 해결 |
|------|------|
| `brew install claude-code` | `brew install --cask claude-code` |
| `~/.mcp.json` 사용 | `~/.claude.json` 사용 |
| `opencode` 설치 | `crush` 설치 (이름 바뀜) |
| `brew install qmd` | `bun install -g https://github.com/tobi/qmd` |

---

## 9. 업데이트

```bash
claude update
```

---

## 10. 완전 초기화 (문제 해결 안 될 때)

```bash
# 설정 백업
cp -r ~/.claude ~/.claude.bak

# 재설치
claude update
```

---

**끝. 이것만 알면 됨.**
