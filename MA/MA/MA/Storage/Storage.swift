import Foundation
import RealmSwift

let realm = try! Realm()

enum StorageManager {
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
    
    static func saveName(name: String, words: [String], date: Date) {
        let dictionaryList = DictionaryLists(name: name)
        dictionaryList.date = date

        for word in words {
            let wordObject = WordLists()
            wordObject.words = word
            dictionaryList.words.append(wordObject)
        }

        do {
            try realm.write {
                realm.add(dictionaryList)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func deleteName(name: DictionaryLists) {
        do {
            try realm.write {
                realm.delete(name)
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    static func editName(name: DictionaryLists,
                         newName: String)
    {
        do {
            try realm.write {
                name.name = newName
            }
        } catch {
            print("error: \(error)")
        }
    }
}
