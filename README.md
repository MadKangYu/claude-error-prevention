# AI Error Prevention

> **TL;DR**: AI 코딩 도구(Claude Code, OpenClaw 등)에서 발생하는 83가지 에러 패턴을 자동으로 진단하고 수정합니다.

```bash
./src/error-engine.sh heal   # 이것만 실행하면 됩니다
```

---

## 목차

1. [왜 이게 필요한가?](#왜-이게-필요한가)
2. [핵심 개념](#핵심-개념)
3. [빠른 시작](#빠른-시작)
4. [에러 패턴 데이터베이스](#에러-패턴-데이터베이스)
5. [작동 원리](#작동-원리)
6. [문서](#문서)

---

## 왜 이게 필요한가?

### 문제

AI 코딩 도구를 사용하다 보면 이런 에러를 만납니다:

```
FailoverError: OAuth token refresh failed for anthropic
spawn npx ENOENT  
gateway timeout after 30000ms
Invalid JSON in settings.json
```

**에러 메시지가 거짓말을 합니다.**

예를 들어, `OAuth token refresh failed`가 떴을 때:
- 실제 원인: WebSocket 연결이 끊어짐
- 에러 메시지: OAuth 토큰 문제라고 함
- 결과: 2시간 동안 잘못된 방향으로 디버깅

### 해결책

**83가지 에러 패턴**을 수집하고, 각각의 **진짜 원인**과 **검증된 해결책**을 데이터베이스화했습니다.

```
에러 발생 → 패턴 매칭 → 진짜 원인 찾기 → 자동 수정 → 검증
```

---

## 핵심 개념

### 1. 에러는 계층 구조를 가진다

```
Layer 4: Application  ←── 에러 메시지가 여기서 나옴 (거짓말 가능)
    ↑
Layer 3: Protocol     ←── 실제 문제가 여기 있을 수 있음
    ↑
Layer 2: Transport    ←── 또는 여기
    ↑
Layer 1: Process      ←── 또는 여기 (근본 원인)
```

**원칙**: 위에서 에러가 나면, 아래부터 확인한다.

### 2. 진단은 MECE로 한다

```
MECE = Mutually Exclusive, Collectively Exhaustive
     = 중복 없이, 빠짐없이
```

예시: Claude Code가 안 될 때
```
1. 설치 문제인가? → which -a claude
2. 설정 문제인가? → jq empty ~/.claude/settings.json
3. 인증 문제인가? → claude auth status
4. 네트워크 문제인가? → curl -s https://api.anthropic.com
```

하나씩 제거하면 원인이 남는다.

### 3. 수정 전에 백업, 수정 후에 검증

```bash
# 나쁜 예
rm ~/.claude/settings.json
echo '{}' > ~/.claude/settings.json

# 좋은 예  
cp ~/.claude/settings.json ~/.claude/settings.json.bak
echo '{}' > ~/.claude/settings.json
jq empty ~/.claude/settings.json && echo "OK" || mv ~/.claude/settings.json.bak ~/.claude/settings.json
```

---

## 빠른 시작

### 설치

```bash
git clone https://github.com/MadKangYu/claude-error-prevention.git
cd claude-error-prevention
```

### 사용

```bash
# 전체 자동 수정 (대부분 이것만 쓰면 됨)
./src/error-engine.sh heal

# 문제만 찾기 (수정 안 함)
./src/error-engine.sh scan

# 시스템 상태 확인
./src/error-engine.sh doctor
```

### 실행 예시

```
$ ./src/error-engine.sh heal

[SCAN] Claude Code 2.1.34 발견
[SCAN] 83개 패턴 검사 중...

[FIX] 중복 설치 발견 → npm 버전 제거
[FIX] 설정 파일 오류 → JSON 복구
[OK] 81개 패턴 정상

완료: 2개 수정, 81개 정상
```

---

## 에러 패턴 데이터베이스

### 도구별 패턴 수

| 도구 | 패턴 수 | 주요 에러 |
|------|---------|-----------|
| Claude Code | 18 | 중복 설치, 설정 오류, MCP 경로 |
| OpenClaw | 10 | Gateway timeout, OAuth 거짓 양성 |
| Oh-my-OpenCode | 8 | 플러그인 로드 실패, 사칭 사이트 |
| OpenCode/Crush | 6 | 마이그레이션, Provider 연결 |
| MCP Server | 12 | spawn ENOENT, JSON-RPC |
| Obsidian/QMD | 15 | SQLite, Embedding |
| 시스템 | 14 | npm 권한, git, 인증 |

### 대표 사례: OAuth 거짓 양성

**상황**: OpenClaw 사용 중 아래 에러 발생
```
FailoverError: OAuth token refresh failed for anthropic
```

**잘못된 시도 (2시간 낭비)**:
1. OAuth 재인증 → 실패
2. 모델 변경 → 실패  
3. Timeout 증가 → 실패

**진짜 원인**:
```
Error: gateway timeout after 30000ms
Gateway target: ws://127.0.0.1:18789   ← WebSocket이 죽어있었음
```

**해결 (42초)**:
```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist
launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

**교훈**: 에러 메시지를 그대로 믿지 마라. 계층을 아래부터 확인하라.

---

## 작동 원리

```
┌─────────────────────────────────────────────────────────────┐
│                      error-engine.sh                        │
├─────────────────────────────────────────────────────────────┤
│  1. DETECT     어떤 AI 도구가 설치되어 있는가?              │
│                → which claude, which crush, ...             │
├─────────────────────────────────────────────────────────────┤
│  2. SCAN       83개 패턴과 대조                             │
│                → 설정 파일 검사, 프로세스 확인, ...         │
├─────────────────────────────────────────────────────────────┤
│  3. FIX        발견된 문제 자동 수정                        │
│                → 백업 → 수정 → 검증 → (실패시 롤백)         │
├─────────────────────────────────────────────────────────────┤
│  4. VERIFY     수정 후 정상 동작 확인                       │
│                → 도구 실행 테스트, 설정 유효성 검사         │
└─────────────────────────────────────────────────────────────┘
```

### 패턴 구조

각 에러 패턴은 다음 구조를 가집니다:

```yaml
pattern:
  id: CLAUDE_DUPLICATE_INSTALL
  symptom: "claude 명령어가 이상하게 동작"
  error_message: "Multiple Claude Code installations found"
  
diagnosis:
  command: "which -a claude | wc -l"
  expected: "1"
  actual: "> 1"
  
root_cause: "npm 버전과 native 버전 동시 설치"

fix:
  steps:
    - "npm uninstall -g @anthropic-ai/claude-code"
  
verify:
  command: "which -a claude | wc -l"
  expected: "1"
```

---

## 문서

### 에러 레퍼런스

| 문서 | 설명 |
|------|------|
| [docs/errors/claude-code-errors.md](docs/errors/claude-code-errors.md) | Claude Code 18개 패턴 |
| [docs/errors/openclaw-errors.md](docs/errors/openclaw-errors.md) | OpenClaw 10개 패턴 |
| [docs/errors/opencode-errors.md](docs/errors/opencode-errors.md) | OpenCode/Crush 6개 패턴 |
| [docs/errors/mcp-server-errors.md](docs/errors/mcp-server-errors.md) | MCP Server 12개 패턴 |

### 설정 가이드

| 문서 | 설명 |
|------|------|
| [docs/guides/settings-reference-2026-02-07.md](docs/guides/settings-reference-2026-02-07.md) | Claude Code 설정 (공식 문서 검증) |
| [docs/guides/installation.md](docs/guides/installation.md) | 설치 가이드 |
| [docs/guides/quick-cheatsheet.md](docs/guides/quick-cheatsheet.md) | 복사-붙여넣기 명령어 |

### 최신 업데이트

| 문서 | 설명 |
|------|------|
| [docs/guides/patch-notes-2026-02-07.md](docs/guides/patch-notes-2026-02-07.md) | Claude Code 2.1.34 패치 노트 |

**2026년 2월 주요 변경사항**:
- Claude Opus 4.6 출시
- Agent Teams (멀티 에이전트 협업)
- Desktop App, Claude Code on the Web
- npm 설치 deprecated → Native/Homebrew 권장

---

## 자주 묻는 질문

**Q: 개발자가 아닌데 사용할 수 있나요?**

네. `./src/error-engine.sh heal` 한 줄만 실행하면 됩니다.

**Q: 내 파일이 삭제되나요?**

아니요. 수정 전 백업하고, 실패 시 자동 롤백합니다.

**Q: Windows에서 되나요?**

WSL(Windows Subsystem for Linux)에서 사용 가능합니다.

---

## 기여하기

새로운 에러 패턴을 발견하면:

1. [CONTRIBUTING.md](CONTRIBUTING.md) 읽기
2. 패턴 구조에 맞게 문서화
3. Pull Request 보내기

---

## 라이선스

MIT

---

<p align="center">
<b>83 Error Patterns · Auto-Fix · Official Docs Synced</b>
<br>
<sub>Last synced: 2026-02-07 · Sources: code.claude.com · charmbracelet/crush · tobi/qmd</sub>
</p>
