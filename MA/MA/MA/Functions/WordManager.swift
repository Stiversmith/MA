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
    
    func saveName(dictName: String, words: [String], from viewController: UIViewController) {
        _ = DictionaryLists(name: dictName)
        let currentDate = Date()

        StorageManager.saveName(name: dictName, words: words, date: currentDate)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let listTVC = storyboard.instantiateViewController(withIdentifier: "ListTVC") as? ListTVC {
            listTVC.selectedWord = dictName
            viewController.navigationController?.pushViewController(listTVC, animated: true)
        }
    }
    }
