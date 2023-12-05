
import Foundation
import RealmSwift

class WordLists: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var words = ""
    @Persisted var dictionarys = List<DictionaryLists>()
}
