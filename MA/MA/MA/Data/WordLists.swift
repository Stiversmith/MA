import Foundation
import RealmSwift

class WordLists: Object {
    @objc dynamic var words: String = ""
    @objc dynamic var translation: String = ""
    private let translater = Translater()
    @objc dynamic var dictionaryList: DictionaryLists?

    func updateTranslation(realm: Realm?, completion: @escaping (String?) -> Void) {
        translater.translate(word: words) { translation in
            if let translation = translation {
                try? realm?.write {
                    self.translation = translation
                }
                completion(translation)
            } else {
                print("Translation failed.")
                completion(nil)
            }
        }
    }
}
