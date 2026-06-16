import Foundation

// 버전 변경 로그 — 데이터 테이블(로직과 분리). 최신 버전이 맨 앞.
// 새 버전 발행 시 이 배열 맨 앞에 항목만 추가한다.
public struct ChangelogEntry: Equatable, Sendable {
    public let version: String
    public let date: String          // YYYY.MM.DD
    public let changes: [String]
    public init(version: String, date: String, changes: [String]) {
        self.version = version; self.date = date; self.changes = changes
    }
}

public enum Changelog {
    public static let entries: [ChangelogEntry] = [
        ChangelogEntry(version: "0.3.7", date: "2026.06.16", changes: [
            "컨디션 좋은데 자는 펫이 슬픈 표정으로 보이던 문제 수정",
        ]),
        ChangelogEntry(version: "0.3.6", date: "2026.06.16", changes: [
            "도감 통계·칭호 뱃지에 마우스 오버 설명(툴팁) 추가",
        ]),
        ChangelogEntry(version: "0.3.5", date: "2026.06.16", changes: [
            "펫 일지 — 부화·성장·졸업·마일스톤을 기록해 모달(📖)로 확인",
            "펫 종합 컨디션 라벨(최상/좋음/보통/시무룩/위급)",
            "연속 중복 대사 방지",
        ]),
        ChangelogEntry(version: "0.3.4", date: "2026.06.16", changes: [
            "연속 사용일(스트릭) + 마일스톤 축하 대사",
            "업적: 누적 작업·급식·쓰다듬기 + 오늘의 작업 수",
            "칭호 시스템(새내기→코딩 마스터)",
            "심야·주말 작업 전용 인사",
            "오프라인 대사가 작업 키워드(버그/테스트/배포 등)에 반응",
            "랜덤 잡담 on/off 설정 + 배고플 때 잡담 억제",
            "AI 대사 출력 검증 강화(한글 무포함·모델 누수 폴백)",
            "변경 로그 보기(이 화면) 추가",
        ]),
        ChangelogEntry(version: "0.3.3", date: "2026.06.16", changes: [
            "설정 탭에 현재 버전 표시",
        ]),
        ChangelogEntry(version: "0.3.2", date: "2026.06.16", changes: [
            "포만감·기분·EXP 실시간 갱신(상호작용 중에도)",
        ]),
        ChangelogEntry(version: "0.3.1", date: "2026.06.16", changes: [
            "자동 업데이트 안정화(App Translocation 대응·교체 실패 시 복원)",
        ]),
        ChangelogEntry(version: "0.3.0", date: "2026.06.16", changes: [
            "도감 상세·통계 화면 + 다회 기록",
            "레벨 10 조기 졸업",
            "휴가 모드·졸업을 설정 탭으로 이동 + 패널 스크롤",
        ]),
        ChangelogEntry(version: "0.2.0", date: "2026.06.12", changes: [
            "초기 공개 빌드 — 노치 다마고치, 밥주기·말걸기·도감·성장 단계",
        ]),
    ]
}
