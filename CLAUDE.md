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

## 코드 규칙

- 주석은 한글, 식별자(타입·함수·변수)는 영문. 축약어 최소화.
- 스프라이트 도트 데이터는 게임 로직과 분리 — 종 추가 시 로직 변경이 없어야 한다.
- clauchi-hook은 어떤 경우에도 Claude Code를 지연·실패시키지 않는다 (조용히 실패).

## 워크플로우

- **커밋**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`)
- **브랜치**: 전역 규칙 따름 — `feature/`, `bugfix/`, `hotfix/`, `refactor/`, `docs/`, `test/` (약어 금지)
- **푸시**: 사용자가 요청할 때만
- **문서 위치**: 스펙 `docs/superpowers/specs/`, 구현 계획 `docs/superpowers/plans/`

## 빌드 / 테스트

(구현 시작 후 SwiftPM/Xcode 구성이 확정되면 이 섹션에 명령어를 추가할 것)
