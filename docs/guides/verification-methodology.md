# Official Documentation Verification Methodology

> AI가 생성한 설치 명령어를 공식 문서와 비교 검증한 실제 사례

**검증일:** 2026-02-07  
**검증자:** Claude Opus 4.5 + 사용자 확인

---

## 핵심 교훈: 뭐가 틀렸는지 모르면 수정할 수 없다

AI가 생성한 문서는 **틀렸는지조차 모르는 상태**로 배포될 수 있습니다.  
이 문서는 실제로 발견한 오류들과 검증 과정을 기록합니다.

---

## 발견된 오류 #1: Claude Code Homebrew

### 틀린 정보 (AI가 생성한 것)

```bash
brew install claude-code
```

### 공식 문서 원문 (curl로 가져온 실제 출력)

```bash
$ curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md | grep -A2 "Homebrew"
```

**출력:**
```
**Homebrew (MacOS/Linux):**
```bash
brew install --cask claude-code
```

### 차이점

| 항목 | 틀린 것 | 맞는 것 |
|------|---------|---------|
| 명령어 | `brew install claude-code` | `brew install --cask claude-code` |
| 누락된 플래그 | 없음 | `--cask` |

### 왜 틀렸나?

- Claude Code는 **Cask**(GUI 앱/바이너리)로 배포됨
- `brew install`은 Formula(소스 빌드)용
- `--cask` 없으면 "formula not found" 에러 발생

### 증거: 전체 공식 README 설치 섹션

```
## Get started
> [!NOTE]
> Installation via npm is deprecated. Use one of the recommended methods below.

1. Install Claude Code:

    **MacOS/Linux (Recommended):**
    ```bash
    curl -fsSL https://claude.ai/install.sh | bash
    ```

    **Homebrew (MacOS/Linux):**
    ```bash
    brew install --cask claude-code
    ```

    **Windows (Recommended):**
    ```powershell
    irm https://claude.ai/install.ps1 | iex
    ```

    **WinGet (Windows):**
    ```powershell
    winget install Anthropic.ClaudeCode
    ```

    **NPM (Deprecated):**
    ```bash
    npm install -g @anthropic-ai/claude-code
    ```
```

---

## 발견된 오류 #2: OpenCode → Crush 이름 변경

### 틀린 정보 (AI가 생성한 것)

```bash
brew install opencode-ai/tap/opencode
# 또는
brew install anomalyco/tap/opencode
```

### 공식 문서 원문 (curl로 가져온 실제 출력)

```bash
$ curl -s https://raw.githubusercontent.com/opencode-ai/opencode/main/README.md | head -10
```

**출력:**
```
# Archived: Project has Moved

This repository is no longer maintained and has been archived for provenance.

The project has continued under the name [Crush][crush], developed by the original author and the Charm team.

Please follow [Crush][crush] for ongoing development.

[crush]: https://github.com/charmbracelet/crush
```

### 새로운 공식 설치 방법

```bash
$ curl -s https://raw.githubusercontent.com/charmbracelet/crush/main/README.md | grep -A20 "## Installation"
```

**출력:**
```
## Installation

Use a package manager:

```bash
# Homebrew
brew install charmbracelet/tap/crush

# NPM
npm install -g @charmland/crush

# Arch Linux (btw)
yay -S crush-bin
```

Windows users:

```bash
# Winget
winget install charmbracelet.crush

# Scoop
scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git
scoop install crush
```
```

### 차이점

| 항목 | 틀린 것 | 맞는 것 |
|------|---------|---------|
| 프로젝트명 | OpenCode | Crush |
| GitHub org | opencode-ai | charmbracelet |
| Homebrew tap | opencode-ai/tap/opencode | charmbracelet/tap/crush |
| npm 패키지 | opencode-ai | @charmland/crush |
| 상태 | **Archived** | Active |

### 왜 틀렸나?

- OpenCode 프로젝트가 Charmbracelet에 인수됨
- 이름이 "Crush"로 변경됨
- 구 레포지토리는 archived 상태
- AI는 학습 시점의 정보만 알고 있음

---

## 발견된 오류 #3: QMD 설치 방법

### 틀린 정보 (AI가 생성한 것)

```bash
brew install tobi/tap/qmd
# 또는
go install github.com/tobi/qmd@latest
```

### 공식 문서 원문 (curl로 가져온 실제 출력)

```bash
$ curl -s https://raw.githubusercontent.com/tobi/qmd/main/README.md | head -20
```

**출력:**
```
# QMD - Query Markup Documents

An on-device search engine for everything you need to remember. Index your markdown notes, meeting transcripts, documentation, and knowledge bases. Search with keywords or natural language. Ideal for your agentic flows.

QMD combines BM25 full-text search, vector semantic search, and LLM re-ranking—all running locally via node-llama-cpp with GGUF models.

## Quick Start

```sh
# Install globally
bun install -g https://github.com/tobi/qmd

# Create collections for your notes, docs, and meeting transcripts
qmd collection add ~/notes --name notes
```
```

### 차이점

| 항목 | 틀린 것 | 맞는 것 |
|------|---------|---------|
| 패키지 매니저 | brew, go | bun |
| 명령어 | `brew install tobi/tap/qmd` | `bun install -g https://github.com/tobi/qmd` |
| Homebrew tap | tobi/tap/qmd | **존재하지 않음** |

### 왜 틀렸나?

- QMD는 TypeScript/JavaScript 프로젝트
- Bun으로만 설치 가능
- Homebrew tap은 존재하지 않음
- AI가 일반적인 패턴(brew tap)을 추측함

---

## 검증 프로세스 (재현 가능)

### Step 1: Raw README 가져오기

```bash
# Claude Code
curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md > /tmp/claude-code-readme.md

# OpenCode (archived 확인)
curl -s https://raw.githubusercontent.com/opencode-ai/opencode/main/README.md > /tmp/opencode-readme.md

# Crush (새 이름)
curl -s https://raw.githubusercontent.com/charmbracelet/crush/main/README.md > /tmp/crush-readme.md

# QMD
curl -s https://raw.githubusercontent.com/tobi/qmd/main/README.md > /tmp/qmd-readme.md
```

### Step 2: 설치 섹션 추출

```bash
# 각 README에서 Install 섹션 찾기
grep -A 30 "## Install" /tmp/claude-code-readme.md
grep -A 30 "## Install" /tmp/crush-readme.md
grep -A 10 "## Quick Start" /tmp/qmd-readme.md
```

### Step 3: 우리 문서와 비교

```bash
# 차이점 확인
diff <(grep "brew install" /tmp/crush-readme.md) \
     <(grep "brew install" our-docs/installation.md)
```

### Step 4: 실제 설치 테스트

```bash
# 실제로 명령어 실행
brew install --cask claude-code && claude --version
brew install charmbracelet/tap/crush && crush --version
bun install -g https://github.com/tobi/qmd && qmd --version
```

---

## 수정 내역

### 수정 전 (틀린 문서)

```markdown
## Installation

### Claude Code
brew install claude-code

### OpenCode
brew install anomalyco/tap/opencode

### QMD
brew install tobi/tap/qmd
```

### 수정 후 (검증된 문서)

```markdown
## Installation

### Claude Code
# Recommended
curl -fsSL https://claude.ai/install.sh | bash

# Homebrew (--cask 필수!)
brew install --cask claude-code

### Crush (구 OpenCode - 이름 변경됨)
# OpenCode는 archived됨. Crush 사용할 것.
brew install charmbracelet/tap/crush

### QMD
# Homebrew tap 없음. Bun 필수.
bun install -g https://github.com/tobi/qmd
```

---

## 왜 WebFetch를 쓰면 안 되는가

### 문제

```bash
# BAD: AI가 요약/해석함
webfetch https://github.com/anthropics/claude-code
# → "Claude Code can be installed via npm or brew..."
# → 세부사항(--cask) 누락 가능
```

### 해결

```bash
# GOOD: Raw 파일 그대로 가져옴
curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md
# → 원본 그대로, 해석 없음
```

---

## 자동 검증 스크립트

```bash
#!/bin/bash
# verify-official-docs.sh
# 공식 문서와 우리 문서 비교

set -e

echo "=== Fetching Official READMEs ==="

# Claude Code
echo "[1/4] Claude Code..."
CLAUDE_BREW=$(curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md | grep -A1 "Homebrew" | tail -1)
if [[ "$CLAUDE_BREW" == *"--cask"* ]]; then
  echo "✅ Claude Code: --cask 확인됨"
else
  echo "❌ Claude Code: --cask 누락 또는 변경됨"
fi

# OpenCode archived check
echo "[2/4] OpenCode archived 상태..."
OPENCODE_STATUS=$(curl -s https://raw.githubusercontent.com/opencode-ai/opencode/main/README.md | head -1)
if [[ "$OPENCODE_STATUS" == *"Archived"* ]]; then
  echo "✅ OpenCode: Archived 확인됨 (Crush 사용)"
else
  echo "⚠️ OpenCode: 상태 변경됨 - 확인 필요"
fi

# Crush
echo "[3/4] Crush..."
CRUSH_BREW=$(curl -s https://raw.githubusercontent.com/charmbracelet/crush/main/README.md | grep "brew install" | head -1)
echo "   현재 명령어: $CRUSH_BREW"

# QMD
echo "[4/4] QMD..."
QMD_INSTALL=$(curl -s https://raw.githubusercontent.com/tobi/qmd/main/README.md | grep "bun install" | head -1)
if [[ "$QMD_INSTALL" == *"bun"* ]]; then
  echo "✅ QMD: bun install 확인됨"
else
  echo "❌ QMD: 설치 방법 변경됨"
fi

echo ""
echo "=== 검증 완료 ==="
```

---

## 교훈 요약

| 번호 | 교훈 | 예시 |
|------|------|------|
| 1 | AI는 플래그를 누락할 수 있다 | `--cask` 누락 |
| 2 | 프로젝트는 이름이 바뀔 수 있다 | OpenCode → Crush |
| 3 | AI는 존재하지 않는 tap을 추측한다 | tobi/tap/qmd (없음) |
| 4 | "100% 완료" 주장을 믿지 마라 | 검증 없는 주장 |
| 5 | WebFetch는 요약한다 | curl raw 사용 |
| 6 | 공식 README가 진실이다 | GitHub raw URL |

---

## 검증 주기

| 주기 | 행동 |
|------|------|
| 매주 | `verify-official-docs.sh` 실행 |
| 에러 리포트 시 | 해당 도구 재검증 |
| 메이저 버전 | 전체 재검증 |

---

## 참고 자료

| 도구 | 공식 GitHub | 검증된 설치 명령어 |
|------|-------------|-------------------|
| Claude Code | [anthropics/claude-code](https://github.com/anthropics/claude-code) | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Crush | [charmbracelet/crush](https://github.com/charmbracelet/crush) | `brew install charmbracelet/tap/crush` |
| QMD | [tobi/qmd](https://github.com/tobi/qmd) | `bun install -g https://github.com/tobi/qmd` |

---

## 기여하기

오류를 발견했다면:

1. `curl -s https://raw.githubusercontent.com/...`로 공식 문서 확인
2. 차이점을 **Before/After** 형식으로 기록
3. PR 제출 시 curl 출력 증거 첨부
