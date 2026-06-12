# Clauchi — 프로젝트 가이드

맥북 노치(다이나믹 아일랜드 스타일)에 상주하며 Claude Code 사용량을 먹고 자라는
12지신 픽셀 다마고치. 설계 전문은 `docs/superpowers/specs/2026-06-10-clauchi-design.md`.

## 기술 스택

- **Swift + SwiftUI 네이티브** (최소 타깃 macOS 26 Tahoe)
- 사용자의 평소 선호는 JS 기반이지만, 노치 통합 품질과 Apple FoundationModels
  (온디바이스 무료 AI)를 위해 **사용자가 명시적으로 Swift를 선택**한 프로젝트다.
  전역 "javascript 기반으로 작업" 규칙보다 이 결정이 우선한다.
- Swift 개념을 설명할 때는 Vue/JS의 유사 개념과 비교해서 설명한다.
  (예: PetEngine = Pinia 스토어, SwiftUI View = 컴포넌트 템플릿, Combine/Observation = reactivity)

## 아키텍처 핵심 (요약)

```
Claude Code hooks → clauchi-hook CLI → ~/.clauchi/events.jsonl → Clauchi.app
앱 내부: ClaudeEventListener → PetEngine(순수 상태 머신) → NotchWindow(SwiftUI)
```

- **PetEngine은 순수 로직** — 시계와 이벤트를 주입받고, UI/파일시스템을 모른다. 테스트의 중심.
- 펫 시간(포만감 감소·위독 타이머)은 맥이 깨어있고 + 휴식 예외가 아닐 때만 흐른다.
- 게임 수치(포만감 증감량, 레벨 곡선, 사망 시간 등)는 하드코딩하지 말고
  튜닝 가능한 설정 구조체에 모은다.
- 펫은 Claude의 **Stop(턴 완료)과 tool-use(작업 중)** 양쪽으로 급식된다 — tool-use 급식은
  분당 상한으로 폭주를 막는다(GameConfig). 능동 작업도 펫을 자라게 한다.
- **성격(Personality)은 부화 시 랜덤 배정되며 대사 색채에만 영향을 준다** —
  포만감·기분·EXP·감쇠·사망 등 게임 수치에 절대 연결하지 않는다(PetEngine 순수성 유지).

## 코드 규칙

- 주석은 한글, 식별자(타입·함수·변수)는 영문. 축약어 최소화.
- 스프라이트 도트 데이터는 게임 로직과 분리 — 종 추가 시 로직 변경이 없어야 한다.
- 종별 말투(SpeechStyle)·성격(Personality) 데이터도 같은 원칙 — 게임 로직과 분리된
  데이터 테이블에 모은다. 종/성격 추가 시 로직 변경 없이 데이터만 추가한다.
- 대사 말투는 데이터 테이블 + AI 프롬프트 주입 + 오프라인 폴백(종 말끝 변환 + 성격 데코)
  구조. 슬픈 상황(died·graduated)에는 오프라인 데코를 생략한다.
- clauchi-hook은 어떤 경우에도 Claude Code를 지연·실패시키지 않는다 (조용히 실패).

## 워크플로우

- **커밋**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`)
- **브랜치**: 전역 규칙 따름 — `feature/`, `bugfix/`, `hotfix/`, `refactor/`, `docs/`, `test/` (약어 금지)
- **푸시**: 사용자가 요청할 때만
- **문서 위치**: 스펙 `docs/superpowers/specs/`, 구현 계획 `docs/superpowers/plans/`

## 빌드 / 테스트

- 테스트: `Scripts/test.sh` (필터: `Scripts/test.sh --filter PetEngineFeedingTests`)
  - 주의: 일반 `swift test`는 이 머신(Command Line Tools 전용)에서 Swift Testing
    모듈을 못 찾아 실패한다. 반드시 래퍼 스크립트 사용.
- 빌드: `swift build`
- 개발 실행: `swift run ClauchiApp` 또는 `.build/debug/ClauchiApp` (알약이 노치에 표시됨)
- 훅 단독 테스트: `echo '{"session_id":"t"}' | swift run ClauchiHook stop`
- 배포 번들: `Scripts/make-app-bundle.sh [version]` → `build/Clauchi.app` (CFBundleShortVersionString 각인)
- 릴리스 발행: `Scripts/release.sh <version>` — 번들 빌드 → `ditto` zip → `gh release create v<version>`.
- 자동 업데이트: 설치 번들이 GitHub Releases의 최신 semver 태그를 실행 시 + 6시간마다 확인해,
  새 버전이면 zip을 받아(미서명 → `xattr`로 격리 제거) "재시작하여 적용"(backup-restore 원자 교체).
  설정 탭에서 수동 확인. dev/번들 아님 시 비활성. 첫 설치는 미서명이라 1회 수동 허용 필요
  (우클릭→열기 / `xattr -dr com.apple.quarantine`). 서명/공증은 추후 release.sh에 추가 가능.
- 게임 시뮬레이션: UI 디버그 메뉴는 제거됨(사용자 요청) — 엔진의
  `debugAdvance`/`debugApply`는 테스트 전용 API로 유지. 수동 검증은
  `~/.clauchi/events.jsonl`에 이벤트 줄을 직접 append 하는 방식 사용
