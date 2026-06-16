import Foundation

// 온디바이스 AI가 내놓은 대사 후보를 검증·정제하는 순수 로직.
// 펫은 한국어 한 문장으로 말하므로, 모델이 지시를 벗어난 출력(영어 거부문, 모델 자기언급,
// 빈 문자열, 과도한 길이)을 걸러 nil을 반환하면 호출부가 오프라인 폴백으로 넘어간다.
public enum AIDialogueValidator {
    // 모델이 지시를 벗어나 "자기 정체"를 드러낸 누수 표지 — 발견 시 폴백
    private static let leakageMarkers = ["as an ai", "language model", "언어 모델", "ai 모델", "ai로서"]

    // 후보를 한 줄로 정제. 부적합하면 nil(→ 폴백). maxLength는 지시문의 한 문장 길이와 맞춘다.
    public static func cleanLine(_ raw: String, maxLength: Int = 40) -> String? {
        var line = raw
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        while line.contains("  ") {   // 연속 공백 정리
            line = line.replacingOccurrences(of: "  ", with: " ")
        }
        guard !line.isEmpty else { return nil }
        let lowered = line.lowercased()
        if leakageMarkers.contains(where: { lowered.contains($0) }) { return nil }
        guard containsHangul(line) else { return nil }   // 한글이 없으면 지시 이탈로 간주
        if line.count > maxLength { line = String(line.prefix(maxLength)) }
        return line
    }

    // 완성형 음절 + 자모 + 호환 자모 범위에 속하는 스칼라가 하나라도 있으면 한글 포함
    private static func containsHangul(_ text: String) -> Bool {
        text.unicodeScalars.contains { scalar in
            (0xAC00...0xD7A3).contains(scalar.value) ||
            (0x1100...0x11FF).contains(scalar.value) ||
            (0x3130...0x318F).contains(scalar.value)
        }
    }
}
