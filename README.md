# 🐾 Clauchi

> 맥북 노치(다이나믹 아일랜드 스타일)에 상주하며 **Claude Code 사용량을 먹고 자라는** 12지신 픽셀 다마고치.

Clauchi는 메뉴바 위 노치 공간에 작은 알약으로 떠 있다가, 당신이 Claude Code로
작업할 때마다 반응합니다. 작업을 끝내면(`Stop`) 밥을 먹고, 프롬프트를 입력하면
한마디 거들고, 며칠 잘 돌봐주면 알에서 깨어나 성체로 자라 도감에 졸업으로 남습니다.
12지신(쥐·소·호랑이·토끼·용·뱀·말·양·원숭이·닭·개·돼지)을 전부 모아보세요.

순수 Swift + SwiftUI 네이티브 앱이며, 대사는 Apple의 온디바이스 모델
(**FoundationModels**)로 생성되어 **네트워크 없이, 무료로** 동작합니다.

---

## ✨ 주요 기능

- **노치 상주 픽셀 펫** — 12지신 × (알 → 아기 → 성체) 단계별 도트 스프라이트, 컬러 외곽선 파스텔 스타일
- **Claude Code 연동** — 세션 시작/작업/완료/알림 훅을 받아 포만감·기분·경험치가 실시간 변동
- **프롬프트 대답** — Claude에 프롬프트를 입력하면 펫이 그 내용을 반영해 노치 토스트로 한마디 (온디바이스 AI, 90초 쿨다운)
- **이름 변경** — 펫에게 직접 이름을 지어주면 모든 대사와 도감 기록에 반영
- **생애 주기** — 부화·레벨업·진화·졸업·굶주림 사망, 결과는 도감(Collection)에 영구 기록
- **돌봄 요소** — 쓰다듬기로 기분 올리기, 주말 휴식·휴가 모드(펫 시간 정지)
- **온디바이스 대사 + 폴백** — FoundationModels가 없거나 느리면 템플릿 대사로 자연 폴백

## 🛠 동작 원리

```
Claude Code hooks → clauchi-hook (CLI) → ~/.clauchi/events.jsonl → Clauchi.app
                                                                       │
                          ClaudeEventListener → PetEngine(순수 상태 머신) → NotchWindow(SwiftUI)
```

- `clauchi-hook`은 Claude Code의 훅으로 등록되어, 이벤트를 `~/.clauchi/events.jsonl`에 한 줄씩 append 합니다. **어떤 경우에도 Claude Code를 지연·실패시키지 않습니다**(조용히 실패).
- 앱은 이 로그를 따라 읽어 **`PetEngine`** — 시계와 이벤트만 주입받는 순수 상태 머신 — 에 흘려보내고, 결과를 SwiftUI 노치 패널에 렌더합니다.
- 훅 등록은 앱 첫 실행 시 동의를 받아 `~/.claude/settings.json`에 병합합니다. 기존 설정은 건드리지 않으며, 설정 탭에서 언제든 제거할 수 있습니다.

## 📦 요구사항

- **macOS 26 Tahoe** 이상 (노치 통합 + FoundationModels)
- Swift 6 toolchain (Xcode 또는 Command Line Tools)
- (선택) [Claude Code](https://claude.ai/code) — 펫이 자라려면 필요

## 🚀 빌드 & 실행

```bash
# 빌드
swift build

# 개발 실행 (노치에 알약이 표시됨)
swift run ClauchiApp

# 배포용 .app 번들 생성 → build/Clauchi.app
Scripts/make-app-bundle.sh
```

> ℹ️ 첫 실행 시 Claude Code 훅 등록 동의 창이 뜹니다. 등록하면 이후 Claude Code 활동에 펫이 반응합니다.

## 🧪 테스트

```bash
# 전체 테스트
Scripts/test.sh

# 특정 스위트만
Scripts/test.sh --filter PetEngineFeedingTests
```

> 이 프로젝트는 Swift Testing을 사용합니다. Command Line Tools 전용 환경에서는 일반 `swift test`가 모듈을 찾지 못할 수 있어, 래퍼 스크립트(`Scripts/test.sh`)를 사용합니다.

## 🧩 아키텍처

| 모듈 | 역할 |
| --- | --- |
| `ClauchiCore` | 순수 로직 — `PetEngine`(상태 머신), 모델, 스프라이트 도트 데이터, 이벤트 파서, 설정 |
| `ClauchiApp` | SwiftUI 앱 — 노치 패널, 토스트, 온디바이스 대사, 훅 설치 |
| `ClauchiHook` | 초경량 CLI — Claude Code 훅이 호출하는 이벤트 기록기 |
| `SpritePreviewGen` | 개발 도구 — 12지신 스프라이트 전체를 한 장의 HTML로 렌더 |

핵심 설계 원칙:

- **`PetEngine`은 순수하다** — UI·파일시스템·AI를 모르고, 시계와 이벤트만 주입받는다. 테스트의 중심.
- **스프라이트 도트 데이터는 게임 로직과 분리** — 종을 추가해도 로직 변경이 없다.
- **게임 수치는 하드코딩하지 않고** `GameConfig` 한 곳에 모은다.

설계 전문과 구현 계획은 [`docs/superpowers/`](docs/superpowers/)에 있습니다.

## 📄 라이선스

[MIT](LICENSE) © 2026 whalstndla
