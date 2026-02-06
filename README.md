```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║     █████╗ ██╗    ███████╗██████╗ ██████╗  ██████╗ ██████╗                        ║
║    ██╔══██╗██║    ██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗                       ║
║    ███████║██║    █████╗  ██████╔╝██████╔╝██║   ██║██████╔╝                       ║
║    ██╔══██║██║    ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██╔══██╗                       ║
║    ██║  ██║██║    ███████╗██║  ██║██║  ██║╚██████╔╝██║  ██║                       ║
║    ╚═╝  ╚═╝╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝                       ║
║                                                                                  ║
║    ██████╗ ██████╗ ███████╗██╗   ██╗███████╗███╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗ ║
║    ██╔══██╗██╔══██╗██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██║██╔═══██╗████╗  ██║ ║
║    ██████╔╝██████╔╝█████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║██║   ██║██╔██╗ ██║ ║
║    ██╔═══╝ ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║██║   ██║██║╚██╗██║ ║
║    ██║     ██║  ██║███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ██║╚██████╔╝██║ ╚████║ ║
║    ╚═╝     ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ║
║                                                                                  ║
║    ┌─────────────────────────────────────────────────────────────────────────┐   ║
║    │  Claude Code · OpenClaw · Oh-my-OpenCode · OpenCode                     │   ║
║    │  AI 오답노트 · Error Journal · Troubleshooting Database                  │   ║
║    │                                                                         │   ║
║    │  Patterns: 83  |  Auto-Fix: 100%  |  Version: 3.1.0                     │   ║
║    └─────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

<p align="center">
  <img src="https://img.shields.io/badge/patterns-83-blue?style=for-the-badge" alt="Patterns">
  <img src="https://img.shields.io/badge/auto--fix-100%25-brightgreen?style=for-the-badge" alt="Auto-fix">
  <img src="https://img.shields.io/badge/version-3.1.0-orange?style=for-the-badge" alt="Version">
</p>

<h1 align="center">Claude Code · OpenClaw · Oh-my-OpenCode · OpenCode</h1>
<h2 align="center">AI Agent Error Prevention & Auto-Fix</h2>
<h3 align="center">AI 오답노트 · Error Journal · Troubleshooting Database</h3>

<p align="center">
  <strong>Claude Code, OpenClaw, Oh-my-OpenCode, OpenCode 오류를 자동으로 찾아서 고쳐주는 도구</strong>
</p>

<p align="center">
  <code>Claude Code</code> · <code>OpenClaw</code> · <code>Oh-my-OpenCode</code> · <code>OpenCode</code> · <code>Crush</code> · <code>Obsidian</code> · <code>MCP Server</code>
</p>

<p align="center">
  <sub>
    <b>Keywords:</b> Claude Code error, Claude Code 오류, Claude Code troubleshooting, Claude Code fix,
    OpenClaw error, OpenClaw 오류, OpenClaw gateway timeout, OpenClaw OAuth failed,
    Oh-my-OpenCode error, Oh-my-OpenCode 오류, Oh-my-OpenCode install,
    OpenCode error, OpenCode 오류, OpenCode Crush, Charmbracelet Crush,
    MCP server crash, MCP spawn ENOENT, oauth token expired, gateway timeout 30000ms,
    ECONNREFUSED, invalid json, AI coding tool error, AI agent error fix,
    클로드 코드 에러, 오픈클로 에러, AI 코딩 도구 자동 수정, AI 오답노트
  </sub>
</p>

---

## 이게 뭔가요?

**AI 코딩 도구**(Claude Code, OpenClaw, Oh-my-OpenCode 등)를 사용할 때 발생하는 오류를 **자동으로 진단하고 수정**해주는 프로그램입니다.

**실전에서 겪은 에러를 기록한 AI 오답노트(Error Journal)** 역할도 합니다:
- 🔴 실제 발생한 에러 → 패턴으로 기록
- 🟢 검증된 해결책 → 자동 수정
- 🔵 AI가 참조 → 같은 실수 반복 방지

### 비유로 설명하면

```
자동차 정비소를 생각해보세요:

1. 차를 가져오면 (당신의 컴퓨터)
2. 정비사가 점검하고 (이 도구가 스캔)
3. 문제를 찾아서 (오류 80가지 패턴)
4. 고쳐줍니다 (자동 수정)

당신은 "점검해줘" 한마디만 하면 됩니다.
```

### 실제 동작 예시

```
$ ./error-engine.sh heal

[OK] Claude Code 발견 (v2.1.34)
[OK] Cursor 발견

80개 패턴 검사 중...

[FIX] 중복 설치 발견 → npm 버전 제거함
[FIX] 설정 파일 오류 → 자동 수정함

╔════════════════════════════════════╗
║  완료!                              ║
║  고친 것: 2개  |  정상: 78개         ║
╚════════════════════════════════════╝
```

---

## 왜 필요한가요?

### 문제 상황

AI 코딩 도구를 사용하다 보면 이런 오류를 만납니다:

| 오류 메시지 | 무슨 뜻인지 | 어떻게 고치는지 |
|-------------|-------------|-----------------|
| `ECONNREFUSED` | 서버 연결 실패 | ??? |
| `Invalid JSON` | 설정 파일 깨짐 | ??? |
| `OAuth token expired` | 인증 만료 | ??? |
| `MCP server crash` | 플러그인 오류 | ??? |
| `gateway timeout after 30000ms` | 게이트웨이 응답 없음 | ??? |
| `FailoverError: OAuth token refresh failed` | OAuth 갱신 실패 (거짓) | ??? |
| `Multiple claude binaries found` | Claude Code 중복 설치 | ??? |
| `spawn ENOENT` | MCP 서버 경로 오류 | ??? |
| `ws://127.0.0.1:18789 timeout` | WebSocket 연결 실패 | ??? |
| `Unknown model: anthropic/claude-opus-4-7` | 모델 ID 오타 | ??? |

**개발자가 아니면 해결하기 어렵습니다.**

> 💡 **이 도구는 위 모든 에러를 자동으로 해결합니다!**

### 이 도구의 해결책

```
오류 발생
    ↓
이 도구 실행: ./error-engine.sh heal
    ↓
자동으로 원인 찾음
    ↓
자동으로 수정함
    ↓
끝!
```

**복잡한 명령어를 몰라도 됩니다.**

---

## 어떻게 사용하나요?

### 1단계: 다운로드

터미널(Terminal)을 열고 아래 명령어를 복사해서 붙여넣기하세요:

```bash
git clone https://github.com/MadKangYu/claude-error-prevention.git
```

> **터미널이 뭔가요?**
> - Mac: `Cmd + Space` → "터미널" 검색 → 엔터
> - Windows: `Win + R` → "cmd" 입력 → 엔터

### 2단계: 폴더 이동

```bash
cd claude-error-prevention
```

### 3단계: 실행

```bash
./src/error-engine.sh heal
```

**끝입니다!** 나머지는 자동으로 진행됩니다.

---

## 무엇을 고쳐주나요?

### 지원하는 도구들

| 도구 이름 | 설명 | 해결하는 문제 수 |
|-----------|------|------------------|
| **Claude Code** | Anthropic의 AI 코딩 CLI | 18개 |
| **OpenClaw** | Telegram AI Gateway | 10개 |
| **Oh-my-OpenCode** | OpenCode 플러그인 시스템 | 8개 |
| **OpenCode / Crush** | Charmbracelet AI 터미널 | 6개 |
| **Obsidian** | PKM 노트 앱 + QMD | 15개 |
| **MCP 서버** | Model Context Protocol | 12개 |
| **시스템 전반** | npm, git, 인증 오류 | 14개 |

**총 83가지 오류 패턴**을 자동으로 해결합니다.

---

## 📘 Claude Code 에러 사례

```
┌──────────────────────────────────────────────────────────────────────────────┐
│   ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗     ██████╗ ██████╗ ██████╗ ███████╗  │
│  ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝  │
│  ██║     ██║     ███████║██║   ██║██║  ██║█████╗      ██║     ██║   ██║██║  ██║█████╗    │
│  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝      ██║     ██║   ██║██║  ██║██╔══╝    │
│  ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗    ╚██████╗╚██████╔╝██████╔╝███████╗  │
│   ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝  │
│                                                                                          │
│   Anthropic's AI Coding CLI  |  18 Error Patterns  |  100% Auto-Fix                     │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

### 사례 1: 중복 설치 충돌

```
에러: Multiple Claude Code installations found
```

| 항목 | 내용 |
|------|------|
| **증상** | `claude` 명령어가 이상하게 동작, 버전 충돌 |
| **원인** | npm 버전과 native 버전이 동시에 설치됨 |
| **진단** | `which -a claude` → 2개 이상 경로 출력 |
| **해결** | `npm uninstall -g @anthropic-ai/claude-code` |
| **검증** | `which -a claude \| wc -l` → 1 |

### 사례 2: 설정 파일 깨짐

```
에러: Invalid JSON in settings.json
에러: SyntaxError: Unexpected token
```

| 항목 | 내용 |
|------|------|
| **증상** | Claude Code 실행 안 됨, 설정 로드 실패 |
| **원인** | JSON 문법 오류 (쉼표, 따옴표 누락) |
| **진단** | `jq empty ~/.claude/settings.json` |
| **해결** | 백업 후 빈 JSON으로 초기화: `echo '{}' > ~/.claude/settings.json` |
| **검증** | `jq empty ~/.claude/settings.json && echo 'OK'` |

### 사례 3: MCP 서버 경로 오류

```
에러: spawn npx ENOENT
에러: MCP server failed to start
```

| 항목 | 내용 |
|------|------|
| **증상** | MCP 서버 연결 실패, 도구 사용 불가 |
| **원인** | 상대 경로 사용, npx 경로 없음 |
| **진단** | `which npx` → 경로 확인 |
| **해결** | 절대 경로 사용: `/usr/local/bin/npx` |
| **검증** | Claude Code 재시작 후 MCP 도구 호출 |

### 사례 4: npm 설치 deprecated

```
경고: @anthropic-ai/claude-code is deprecated
```

| 항목 | 내용 |
|------|------|
| **증상** | npm 경고 메시지, 업데이트 안 됨 |
| **원인** | npm 설치 방식은 2025년부터 deprecated |
| **해결** | `npm uninstall -g @anthropic-ai/claude-code && curl -fsSL https://claude.ai/install.sh \| bash` |
| **검증** | `claude --version` |

---

## 🦞 OpenClaw 에러 사례

```
┌──────────────────────────────────────────────────────────────────────────────┐
│   ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗    ██╗       │
│  ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║    ██║       │
│  ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║     ██║     ███████║██║ █╗ ██║       │
│  ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║██║███╗██║       │
│  ╚██████╔╝██║     ███████╗██║ ╚████║╚██████╗███████╗██║  ██║╚███╔███╔╝       │
│   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝        │
│                                                                              │
│   Telegram AI Gateway  |  10 Error Patterns  |  Self-Healing System          │
└──────────────────────────────────────────────────────────────────────────────┘
```

> *"에러 발생 후 고치지 말고, 발생 전에 막아라"* — Andrej Karpathy

### 🔴 실제 사례 1: OAuth 거짓 양성 (2026-02-07 새벽 발생)

**최초 에러 메시지:**
```
FailoverError: OAuth token refresh failed for anthropic:
Failed to refresh OAuth token for anthropic.
Please try again or re-authenticate.
```

**잘못된 시도들 (오답):**
| 시도 | 명령어 | 결과 |
|------|--------|------|
| Agent 변경 | `github` → `main` | ❌ 실패 |
| Model 변경 | `haiku` → `openai/gpt-4o` | ❌ 실패 |
| OAuth 재인증 | `openclaw pair anthropic` | ❌ 실패 |
| Timeout 증가 | `--timeout 60000` | ❌ 실패 |
| Timeout 더 증가 | `--timeout 120000` | ❌ 실패 |

**진짜 에러 (숨어있던 것):**
```
Error: gateway timeout after 30000ms
Gateway target: ws://127.0.0.1:18789
Source: local loopback
Config: /Users/kangyu_macpro/.openclaw/openclaw.json
```

**MECE 진단:**
```
┌─────────────────────────────────────────────────────────────────┐
│                    MECE 진단 계층 구조                           │
├─────────────────────────────────────────────────────────────────┤
│  Layer 4: Application ─── OAuth, Model, Agent                   │
│       ↑                                                         │
│  Layer 3: WebSocket ───── Gateway WS Handler  ← ❌ 여기가 문제!  │
│       ↑                                                         │
│  Layer 2: HTTP ────────── Gateway HTTP Response ← ✅ 정상       │
│       ↑                                                         │
│  Layer 1: Process ─────── launchd ← ✅ 정상                     │
└─────────────────────────────────────────────────────────────────┘
```

**해결:**
```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist
sleep 2
launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

**결과:**
```json
{
  "ok": true,
  "ran": true
}
```
**42초 만에 완료** — 2시간 동안 실패하던 작업이!

> 💡 **핵심 교훈**: 에러 메시지를 그대로 믿지 마라. OAuth가 아니라 WebSocket이 죽어있었다!

---

### 🔴 실제 사례 2: Gateway Restart 거짓 성공

**상황:** `openclaw gateway restart` 실행

**거짓 성공 로그:**
```
[06:01:38] ❌ Process: Gateway not loaded
[06:01:38] 🔄 Recovering: openclaw gateway restart
[06:01:40] ✅ Gateway restart command succeeded   ← 거짓말!
[06:01:45] ⏳ Waiting for Gateway... (5s)
[06:01:45] ❌ HTTP: No response
[06:01:50] ⏳ Waiting for Gateway... (10s)
[06:01:50] ❌ HTTP: No response
...
[06:02:10] ❌ Recovery: Failed (timeout 30s)
```

**올바른 방법으로 재시도:**
```
[06:03:01] ❌ Process: Gateway not loaded
[06:03:01] 🔄 Recovering: Gateway restart
[06:03:04] ✅ launchctl load succeeded   ← 진짜 성공!
[06:03:09] ⏳ Waiting for Gateway... (5s)
[06:03:09] ✅ HTTP: OK
[06:03:12] ✅ Gateway Health: OK
[06:03:12] ✅ Recovery: Success (after 5s)
```

**비교:**
| 방법 | 명령어 | 결과 | 신뢰도 |
|------|--------|------|--------|
| 공식 명령어 | `openclaw gateway restart` | ❌ 거짓 성공 | 낮음 |
| 직접 제어 | `launchctl load` | ✅ 진짜 성공 | 높음 |

> ⚠️ **경고**: 공식 명령어도 실패할 수 있다. `launchctl load`가 더 확실하다!

---

### 🔴 실제 사례 3: HTTP OK인데 WS 죽음

**진단 명령어:**
```bash
# Layer 2: HTTP 체크 → OK
curl -s http://127.0.0.1:18789/health
```
```html
<!doctype html>
<html lang="en">
  <head><title>OpenClaw Control</title>...
```

```bash
# Layer 3: WebSocket 체크 → 응답 없음!
timeout 5 openclaw status --json 2>&1 | head -5
```
(응답 없음)

**원인:**
| 구분 | 상태 | 설명 |
|------|------|------|
| HTTP (stateless) | ✅ | 각 요청이 독립적 |
| WebSocket (stateful) | ❌ | 연결 상태 유지 필요, 불안정해짐 |

> 💡 **교훈**: HTTP OK ≠ 시스템 OK. WebSocket도 반드시 체크!

---

### 사례 4: Unknown Model

```
에러: Unknown model: anthropic/claude-opus-4-7
```

| 항목 | 내용 |
|------|------|
| **증상** | 모델 호출 실패 |
| **원인** | 모델 ID 오타 (4-7 → 4-6) |
| **해결** | `openclaw config set defaultModel anthropic/claude-opus-4-6` |
| **검증** | `openclaw models` |

---

## 🔧 Oh-my-OpenCode 에러 사례

```
┌──────────────────────────────────────────────────────────────────────────────┐
│   ██████╗ ██╗  ██╗      ███╗   ███╗██╗   ██╗       ██████╗  ██████╗          │
│  ██╔═══██╗██║  ██║      ████╗ ████║╚██╗ ██╔╝      ██╔═══██╗██╔════╝          │
│  ██║   ██║███████║█████╗██╔████╔██║ ╚████╔╝ █████╗██║   ██║██║               │
│  ██║   ██║██╔══██║╚════╝██║╚██╔╝██║  ╚██╔╝  ╚════╝██║   ██║██║               │
│  ╚██████╔╝██║  ██║      ██║ ╚═╝ ██║   ██║        ╚██████╔╝╚██████╗           │
│   ╚═════╝ ╚═╝  ╚═╝      ╚═╝     ╚═╝   ╚═╝         ╚═════╝  ╚═════╝           │
│                                                                              │
│   OpenCode Plugin System  |  8 Error Patterns  |  Skills & Hooks             │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 사례 1: 사칭 사이트 경고

```
경고: ohmyopencode.com is NOT official!
```

| 항목 | 내용 |
|------|------|
| **증상** | 이상한 사이트에서 다운로드 유도 |
| **위험** | 🚨 악성코드 가능성 |
| **공식 소스** | `https://github.com/code-yeongyu/oh-my-opencode` |
| **안전한 설치** | `bunx oh-my-opencode install` |

### 사례 2: 설치 실패

```
에러: bunx oh-my-opencode install failed
에러: ENOENT: no such file or directory
```

| 항목 | 내용 |
|------|------|
| **증상** | 설치 중 오류 |
| **원인** | bun 미설치 또는 권한 문제 |
| **진단** | `which bun` |
| **해결** | `curl -fsSL https://bun.sh/install \| bash` |
| **검증** | `bun --version` |

### 사례 3: 플러그인 로드 실패

```
에러: Failed to load skill: playwright
```

| 항목 | 내용 |
|------|------|
| **증상** | 특정 스킬/플러그인 동작 안 함 |
| **원인** | 의존성 미설치 |
| **해결** | `bunx oh-my-opencode install --fix` |

---

## 💻 OpenCode / Crush 에러 사례

```
┌──────────────────────────────────────────────────────────────────────────────┐
│   ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗        │
│  ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝        │
│  ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║     ██║   ██║██║  ██║█████╗          │
│  ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║     ██║   ██║██║  ██║██╔══╝          │
│  ╚██████╔╝██║     ███████╗██║ ╚████║╚██████╗╚██████╔╝██████╔╝███████╗        │
│   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝        │
│                                                                              │
│   Charmbracelet AI Terminal (formerly OpenCode)  |  6 Error Patterns         │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 사례 1: OpenCode → Crush 마이그레이션

```
경고: OpenCode is archived, use Crush instead
```

| 항목 | 내용 |
|------|------|
| **배경** | Charmbracelet이 OpenCode를 Crush로 리브랜딩 |
| **구버전** | `opencode-ai/opencode` (archived) |
| **신버전** | `charmbracelet/crush` |
| **마이그레이션** | `brew uninstall opencode-ai/tap/opencode && brew install charmbracelet/tap/crush` |

### 사례 2: Provider 연결 실패

```
에러: No AI provider configured
```

| 항목 | 내용 |
|------|------|
| **증상** | 실행은 되는데 AI 응답 없음 |
| **원인** | API 키 미설정 |
| **해결** | `crush` 실행 후 `/connect` 명령어 |
| **검증** | `crush` → 대화 테스트 |

### 사례 3: AGENTS.md 없음

```
경고: AGENTS.md not found in current directory
```

| 항목 | 내용 |
|------|------|
| **증상** | 프로젝트 컨텍스트 없이 동작 |
| **해결** | `crush` 실행 후 `/init` 명령어 |

---

## 🔌 MCP Server 에러 사례

### 사례 1: spawn ENOENT

```
에러: spawn npx ENOENT
에러: Error: spawn /usr/local/bin/npx ENOENT
```

| 항목 | 내용 |
|------|------|
| **증상** | MCP 서버 시작 실패 |
| **원인** | 경로에 npx가 없음 |
| **해결** | MCP 설정에서 절대 경로 사용 |
| **예시** | `"command": "/opt/homebrew/bin/npx"` |

### 사례 2: Invalid JSON-RPC

```
에러: MCP server returned invalid response
에러: JSON parse error
```

| 항목 | 내용 |
|------|------|
| **증상** | MCP 도구 호출 실패 |
| **원인** | 서버가 stdout에 JSON 외 내용 출력 |
| **해결** | 서버 코드에서 `console.log` → `console.error`로 변경 |
| **검증** | `echo '{"jsonrpc":"2.0","method":"initialize","id":1}' \| your-mcp-server 2>/dev/null \| jq .` |

### 사례 3: MCP Server Crash

```
에러: MCP server exited unexpectedly
```

| 항목 | 내용 |
|------|------|
| **증상** | 간헐적 MCP 연결 끊김 |
| **원인** | 메모리 누수, 예외 미처리 |
| **진단** | `claude` 로그 확인 |
| **해결** | 서버 재시작 또는 업데이트 |

---

## ⚠️ 시스템 공통 에러 사례

### 사례 1: npm 권한 오류

```
에러: npm EACCES: permission denied
에러: Error: EACCES: permission denied, mkdir '/usr/local/lib/node_modules'
```

| 항목 | 내용 |
|------|------|
| **증상** | npm 전역 설치 실패 |
| **원인** | sudo npm 사용 이력 |
| **해결** | `mkdir ~/.npm-global && npm config set prefix '~/.npm-global'` |
| **PATH 추가** | `export PATH=~/.npm-global/bin:$PATH` |

### 사례 2: .env 파일 git 노출

```
경고: .env file tracked in git (SECURITY RISK!)
```

| 항목 | 내용 |
|------|------|
| **위험** | 🚨 API 키, 토큰 노출 |
| **해결** | `git rm --cached .env && echo '.env' >> .gitignore` |
| **필수 조치** | 노출된 키 즉시 revoke 후 재발급 |

### 사례 3: Git Merge Conflict

```
에러: CONFLICT (content): Merge conflict in file.ts
```

| 항목 | 내용 |
|------|------|
| **증상** | git pull/merge 실패 |
| **진단** | `git diff --name-only --diff-filter=U` |
| **해결** | 파일 열어서 `<<<<<<`, `======`, `>>>>>>` 마커 해결 |
| **검증** | `git add <file> && git commit` |

---

## 자주 묻는 질문 (FAQ)

### Q: 개발자가 아닌데 사용할 수 있나요?

**네!** 위의 3단계만 따라하면 됩니다. 복잡한 내용은 모두 자동으로 처리됩니다.

### Q: 내 파일이 삭제되거나 하진 않나요?

**아니요.** 이 도구는:
- 수정 전 항상 **백업**을 만듭니다
- 문제가 생기면 **자동으로 되돌립니다**
- 사용자 파일은 **절대 삭제하지 않습니다**

### Q: Mac만 되나요?

현재는 **Mac과 Linux**를 지원합니다. Windows는 WSL(Windows Subsystem for Linux)에서 사용 가능합니다.

### Q: 인터넷 연결이 필요한가요?

처음 다운로드할 때만 필요합니다. 이후 실행은 오프라인에서도 됩니다.

### Q: 무료인가요?

**네, 완전히 무료입니다.** 오픈소스(MIT 라이선스)입니다.

---

## 용어 설명

| 용어 | 쉬운 설명 |
|------|-----------|
| **터미널** | 컴퓨터에 글자로 명령하는 프로그램 (검은 화면에 흰 글자) |
| **Git** | 코드를 다운로드하는 도구 |
| **JSON** | 설정 파일 형식 (사람이 읽을 수 있는 텍스트) |
| **MCP** | AI 도구의 확장 기능 (플러그인 같은 것) |
| **OAuth** | 로그인/인증 방식 |
| **npm** | 프로그램 설치 도구 (옛날 방식) |
| **Native** | 직접 설치 (새로운 권장 방식) |

---

## 문제가 생기면?

### 1. 다시 실행해보기

```bash
./src/error-engine.sh heal
```

### 2. 로그 확인하기

```bash
./src/error-engine.sh scan
```

### 3. 도움 요청하기

[GitHub Issues](https://github.com/MadKangYu/claude-error-prevention/issues)에 문제를 올려주세요.

---

## 명령어 모음

| 명령어 | 설명 | 언제 사용? |
|--------|------|------------|
| `heal` | **전체 자동 수정** | 평소에 이것만 쓰세요 |
| `scan` | 문제만 찾기 (수정 안 함) | 뭐가 문제인지 보고 싶을 때 |
| `doctor` | 건강 체크 | 모든 게 정상인지 확인할 때 |
| `list` | 모든 패턴 보기 | 어떤 오류를 잡는지 궁금할 때 |

**대부분의 경우 `heal`만 사용하면 됩니다:**

```bash
./src/error-engine.sh heal
```

---

## 작동 원리 (궁금한 분만)

```
당신이 "heal" 실행
        ↓
┌─────────────────────────────────────┐
│ 1. 감지: 어떤 AI 도구가 설치됐나?    │
│    → Claude Code, Cursor 등 찾기    │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ 2. 스캔: 80가지 오류 패턴 검사       │
│    → 설정 오류, 중복 설치 등 찾기    │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ 3. 수정: 발견된 문제 자동 해결       │
│    → 백업 → 수정 → 확인             │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ 4. 검증: 제대로 고쳐졌는지 확인      │
│    → 실패하면 자동 롤백             │
└─────────────────────────────────────┘
        ↓
      완료!
```

---

## 업데이트 방법

새로운 오류 패턴이 추가되면 업데이트하세요:

```bash
cd claude-error-prevention
git pull
```

---

## 기여하기

버그를 발견하거나 새로운 오류 패턴을 추가하고 싶다면:

1. [CONTRIBUTING.md](CONTRIBUTING.md) 읽기
2. GitHub에서 Pull Request 보내기

---

## 만든 사람

- **MadKangYu** - [GitHub](https://github.com/MadKangYu)

## 라이선스

MIT - 무료로 사용, 수정, 배포 가능

---

<p align="center">
  <strong>80가지 오류 패턴 · 100% 자동 수정 · 설정 필요 없음</strong>
</p>

<p align="center">
  <sub>AI 도구 사용이 어려우셨나요? 이제 이 도구가 도와드립니다.</sub>
</p>
