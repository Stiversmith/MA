import UIKit
import RealmSwift

class ListTVC: UITableViewController {

    var words: [String] = []
        var filteredWords: [String] = []
        var selectedWord: String?
        var dictionaryLists: Results<DictionaryLists>!
    var availableWords: [String] = []

        
        init() {
            super.init(style: .plain)
            
            let realm = try! Realm()
            dictionaryLists = realm.objects(DictionaryLists.self)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            let realm = try! Realm()
            dictionaryLists = realm.objects(DictionaryLists.self)
        }
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ListCellTVC", bundle: nil), forCellReuseIdentifier: "Cell")
        words = WordManager.shared.availableWords
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if !searchBar.text!.isEmpty {
                return filteredWords.count
            } else {
                return dictionaryLists.count
            }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListCellTVC
                    
            var wordList: String
                    
            if !searchBar.text!.isEmpty {
                wordList = filteredWords[indexPath.row]
            } else {
                wordList = dictionaryLists[indexPath.row].name
            }
        
        cell.name.text = wordList
        cell.number.text = "\(indexPath.row + 1)"
        
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let dateString = dateFormatter.string(from: dictionaryLists[indexPath.row].date)
                cell.date.text = dateString
        
        if let selectedWord = selectedWord, wordList == selectedWord {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if !searchText.isEmpty {
            filteredWords = WordFilter.filterWords(words, for: searchText)
        } else {
            filteredWords = words
        }
        tableView.reloadData()
    }
    
    func addDictionaryList(_ name: String) {
        let dictionaryList = DictionaryLists(name: name)
        dictionaryList.date = Date()
        StorageManager.saveName(name: dictionaryList, date: dictionaryList)
        availableWords.append(name)
    }
}
