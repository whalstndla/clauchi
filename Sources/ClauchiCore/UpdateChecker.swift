import Foundation

// 자동 업데이트 판정 결과
public enum UpdateStatus: Equatable, Sendable {
    case upToDate
    case updateAvailable(remoteCommit: String)
    case skip   // 판정 불가(빌드 커밋 미상·원격 조회 실패·원격이 뒤/분기)
}

// git 호출을 모르는 순수 판정 — 입력값만으로 결정한다 (PetEngine 패턴)
public enum UpdateChecker {
    // buildCommit: 현재 앱 빌드 커밋(nil이면 dev → skip)
    // remoteCommit: origin/main tip(nil이면 조회 실패 → skip)
    // buildIsAncestorOfRemote: 빌드 커밋이 origin/main의 조상인가(앞으로만 업데이트)
    public static func status(buildCommit: String?, remoteCommit: String?,
                              buildIsAncestorOfRemote: Bool) -> UpdateStatus {
        guard let buildCommit, let remoteCommit else { return .skip }
        if buildCommit == remoteCommit { return .upToDate }
        guard buildIsAncestorOfRemote else { return .skip }
        return .updateAvailable(remoteCommit: remoteCommit)
    }
}
