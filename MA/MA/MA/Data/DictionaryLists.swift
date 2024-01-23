import Foundation
import RealmSwift

class DictionaryLists: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
