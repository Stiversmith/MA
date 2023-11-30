import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func getAllWordLists() -> Results<WordLists> {
        realm.objects(WordLists.self)
    }
    
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }
    
    static func editWord(word: WordLists,
                               newWord: String) {
        do {
            try realm.write {
                word.words = newWord
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func saveWord(words: WordLists) {
        do {
            try realm.write {
                realm.add(words)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    //////////////
    
    static func deleteWord(words: WordLists) {
        do {
            try realm.write {
                let dictionarys = words.dictionarys
                realm.delete(words)
                realm.delete(dictionarys)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func editWord(words: WordLists,
                               newWord: String) {
        do {
            try realm.write {
                words.words = newWord
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    /////////////////////
    
}
