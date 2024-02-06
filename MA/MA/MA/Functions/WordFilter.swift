import UIKit

class WordFilter {
    static func filterWords(_ words: [String], for searchText: String) -> [String] {
        return words.filter({ (word: String) -> Bool in
            return word.lowercased().contains(searchText.lowercased())
        })
    }
}
