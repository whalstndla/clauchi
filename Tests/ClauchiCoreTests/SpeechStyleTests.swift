import Foundation
import Testing
@testable import ClauchiCore

@Test func everySpeciesHasSpeechStyle() {
    for species in Species.allCases {
        let style = SpeciesSpeech.style(for: species)
        #expect(!style.aiHint.isEmpty, "\(species) aiHint 비어있음")
        #expect(!style.interjections.isEmpty, "\(species) interjections 비어있음")
        for interjection in style.interjections {
            #expect(!interjection.isEmpty)
        }
    }
}

@Test func dogSpeechStyleHasBarkInterjection() {
    #expect(SpeciesSpeech.style(for: .dog).interjections.contains("멍!"))
}
