import Foundation
import RealmSwift

let realm = try! Realm()

enum StorageManager {
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
    
    static func deleteWord(word: WordLists) {
        do {
            try realm.write {
                realm.delete(word)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func editWord(word: WordLists,
                         newWord: String)
    {
        do {
            try realm.write {
                word.words = newWord
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func saveWord(word: WordLists) {
        do {
            try realm.write {
                realm.add(word)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    /*

     static func deleteWordIn(word: WordLists) {
         do {
             try realm.write {
                 let dictionarys = word.dictionarys
                 realm.delete(word)
                 realm.delete(dictionarys)
             }
         } catch {
             print("error: \(error)")
         }
     }
    
     static func editWord(words: WordLists,
                          newWord: String)
     {
         do {
             try realm.write {
                 words.words = newWord
             }
         } catch {
             print("error: \(error)")
         }
     }
    
      */
}
