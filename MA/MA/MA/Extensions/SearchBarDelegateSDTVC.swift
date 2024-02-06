import UIKit

extension SavedDictionaryTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        filterContentForSearchText(searchText)
    }

    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func filterContentForSearchText(_ searchText: String) {
        if !searchText.isEmpty {
            filteredWords = WordFilter.filterWords(words, for: searchText)
        } else {
            filteredWords = words
        }
        tableView.reloadData()
    }
}
