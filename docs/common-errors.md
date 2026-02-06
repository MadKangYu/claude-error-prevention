# Common Error Patterns (Lessons Learned)

> AI 에이전트 개발 중 학습한 일반적인 에러 패턴과 교훈

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██╗     ███████╗███████╗███████╗ ██████╗ ███╗   ██╗███████╗                ║
║   ██║     ██╔════╝██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔════╝                ║
║   ██║     █████╗  ███████╗███████╗██║   ██║██╔██╗ ██║███████╗                ║
║   ██║     ██╔══╝  ╚════██║╚════██║██║   ██║██║╚██╗██║╚════██║                ║
║   ███████╗███████╗███████║███████║╚██████╔╝██║ ╚████║███████║                ║
║   ╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝                ║
║                    ██╗     ███████╗ █████╗ ██████╗ ███╗   ██╗███████╗██████╗ ║
║                    ██║     ██╔════╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔══██╗║
║                    ██║     █████╗  ███████║██████╔╝██╔██╗ ██║█████╗  ██║  ██║║
║                    ██║     ██╔══╝  ██╔══██║██╔══██╗██║╚██╗██║██╔══╝  ██║  ██║║
║                    ███████╗███████╗██║  ██║██║  ██║██║ ╚████║███████╗██████╔╝║
║                    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ ║
║                                                                              ║
║   Error Prevention System v3.1 | Category: Meta-Learning                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 1. Documentation Errors

| Error | Example | Fix |
|-------|---------|-----|
| 요약 | "No React data (keeps output minimal)" → "Minimal output" | 원문 그대로 복사 |
| 번역 | 영어 → 한국어 (요청 없이) | 요청 시에만 번역 |
| 의역 | "Get annotation" → "Retrieve annotation" | 동사 그대로 유지 |
| 추가 | 공식에 없는 설명 삽입 | 있는 것만 복사 |

## 2. Config Path Errors

| Wrong | Correct |
|-------|---------|
| `~/.mcp.json` | `~/.claude/claude_code_config.json` |
| `~/.config/claude/` | `~/.claude/` |
| `./mcp.json` | `~/.claude/claude_code_config.json` |

## 3. Installation Errors

| Error | Result | Fix |
|-------|--------|-----|
| npm + native 둘 다 설치 | 버전 충돌 | `npm -g uninstall` 후 native만 유지 |
| `sudo npm install -g` | 권한 문제 | 절대 sudo 사용 금지 |
| npm 설치 (deprecated) | 업데이트 안 됨 | native 설치로 마이그레이션 |

## 4. Verification Errors

| Error | Problem | Fix |
|-------|---------|-----|
| WebFetch로 검증 | AI 해석 개입 | GitHub raw 사용 |
| "100% 완료" 선언 | 검증 없는 확신 | 실제 출력 보여주기 |
| 부분만 확인 | 누락 발생 | 전체 diff 실행 |

## 5. npx/npm Errors

| Error | Problem | Fix |
|-------|---------|-----|
| 캐시된 구버전 실행 | 최신 아님 | `npx --yes pkg@latest` |
| peer dependency 무시 | 런타임 에러 | `npm ls` 로 확인 |
| 설치 확인 안 함 | 실패 모름 | `npm list pkg` 확인 |

## 6. MCP Server Errors

| Error | Problem | Fix |
|-------|---------|-----|
| 비표준 플래그 사용 | 공식 아님 | 공식 문서 플래그만 사용 |
| 서버 미실행 | MCP 연결 실패 | `npx [mcp] doctor` 확인 |
| 잘못된 JSON 형식 | 파싱 에러 | `jq .` 로 검증 |

## 7. Git/GitHub Errors

| Error | Problem | Fix |
|-------|---------|-----|
| WebFetch로 GitHub 접근 | AI 해석 | `gh api` 또는 `curl raw` |
| 파일 구조 추측 | 404 에러 | `gh api contents` 로 확인 |
| Branch 이름 추측 | main vs master | repo 확인 후 사용 |

## 8. Memory/CLAUDE.md Errors

| Error | Problem | Fix |
|-------|---------|-----|
| 잘못된 경로 | 로드 안 됨 | `~/.claude/CLAUDE.md` 사용 |
| import 문법 오류 | 파일 못 찾음 | `@path/to/file` 형식 |
| rules 디렉토리 없음 | 모듈화 못함 | `~/.claude/rules/` 생성 |

## Prevention Checklist

### 문서 작업 전
- [ ] GitHub raw 접근 확인
- [ ] 번역/요약 요청 여부 확인 (기본: NO)

### 설치 작업 전
- [ ] 기존 설치 확인: `which -a`
- [ ] 공식 설치 방법 확인

### 작업 완료 시
- [ ] 실제 명령어 출력 제시
- [ ] "100%" 표현 사용 안 함
- [ ] 검증 방법 명시

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI errors |
| [MCP Server Errors](./mcp-server-errors.md) | MCP protocol errors |
| [Provider Errors](./provider-errors.md) | API provider errors |
| [Korean Errors](./korean-errors.md) | Korean user patterns |
| [Installation Guide](./installation.md) | Installation procedures |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.1 | 2026-02-07 | Added cross-references, header |
| 1.0 | 2026-02-06 | Initial lessons learned |

---

*Last updated: 2026-02-07 | Maintainer: claude-error-prevention*
