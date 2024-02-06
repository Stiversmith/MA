import UIKit
import RealmSwift

class WordManager {
    
    var availableWords: [String] = []

    static let shared = WordManager()
    
    private init() {}
    
    var wordAddedHandler: ((String) -> Void)?
    
    func addWord(_ word: String) {
        let wordObject = WordLists()
        wordObject.words = word
        StorageManager.saveWord(word: wordObject)
        wordAddedHandler?(word)
        availableWords.append(word)

    }
    
    func saveName(dictName: String, words: [String]) {
        let dictionaryList = DictionaryLists(name: dictName)
        StorageManager.saveName(name: dictionaryList, date: dictionaryList)
        wordAddedHandler?(dictName)
        availableWords.append(dictName)
    }
    }
