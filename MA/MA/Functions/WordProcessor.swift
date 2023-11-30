

// добавить удаление названий стран городов и тд
// добавить удаление ing
// добавить удаление названий стран городов и тд

import Foundation
class WordProcessor {
    static func processWords(_ words: [String]) -> [String] {
        var uniqueWords: [String: Bool] = [:]
        
        for word in words {
            // Удаляем символы, отличные от букв
            let letters = CharacterSet.letters
            let filteredWord = word.filter { letters.contains(UnicodeScalar(String($0))!) }
            
            var wordToAdd = filteredWord
            if let lastCharacter = wordToAdd.last {
                let lastScalar = lastCharacter.unicodeScalars
                
                if lastScalar.count > 0, CharacterSet.punctuationCharacters.contains(lastScalar[lastScalar.startIndex]) {
                    wordToAdd.removeLast()
                }
            }
            
            if let apostropheIndex = wordToAdd.firstIndex(of: "'") {
                wordToAdd = String(wordToAdd.prefix(upTo: apostropheIndex))
            }
            
            // Пропускаем слова "a", "an", "the", "any", "am", "pm"
            let skipWords = ["a", "an", "the", "any", "am", "pm"]
            if skipWords.contains(wordToAdd.lowercased()) {
                continue
            }
            
            // Пропускаем гласные и согл
            let vowels = CharacterSet(charactersIn: "aeiouAEIOU")
            let consonants = CharacterSet.letters.subtracting(vowels)
            
            if wordToAdd.rangeOfCharacter(from: vowels) == nil || wordToAdd.rangeOfCharacter(from: consonants) == nil {
                continue
            }
            
            if !wordToAdd.isEmpty {
                wordToAdd = wordToAdd.capitalized
                
                let isPlural = wordToAdd.hasSuffix("s")
                let ingWord = wordToAdd + "ing"
                
                // Проверяем наличие слова без окончания "ing" и удаляем соответствующее слово с окончанием "ing"
                if uniqueWords.keys.contains(ingWord) {
                    uniqueWords.removeValue(forKey: ingWord)
                } else {
                    uniqueWords[wordToAdd] = isPlural
                }
            }
        }
        
        let uniqueWordsArray = uniqueWords.filter { !$0.value }.map { $0.key }
        
        return uniqueWordsArray.sorted()
    }
}
