import RealmSwift

class TextProcessor {
    static func getSentenceContainingWord(_ word: String, in text: String) -> String? {
        let sentences = text.components(separatedBy: ".")
        
        for sentence in sentences {
            let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            let words = trimmedSentence.components(separatedBy: .whitespacesAndNewlines)
            
            for wordInSentence in words {
                if wordInSentence.compare(word, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
                    return trimmedSentence
                }
            }
        }
        
        return nil
    }
}
