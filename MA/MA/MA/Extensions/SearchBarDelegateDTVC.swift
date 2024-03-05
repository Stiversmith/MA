import UIKit

extension DictionaryTVC {
    func filterContentForSearchText(_ searchText: String) {
        if !searchText.isEmpty {
            filteredWords = WordFilter.filterWords(words, for: searchText)
        } else {
            filteredWords = words
        }
        tableView.reloadData()
    }
}

extension DictionaryTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        filterContentForSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
