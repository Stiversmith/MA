import RealmSwift
import UIKit

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
        tableView.reloadData()
        searchBar.delegate = self
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
        dateFormatter.dateFormat = "MM.dd.yyyy / hh.mm"
        let dateString = dateFormatter.string(from: dictionaryLists[indexPath.row].date)
        cell.date.text = dateString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentName = dictionaryLists[indexPath.row]

        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            StorageManager.deleteName(name: currentName)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.updateAvailableWords()
            tableView.reloadData()
        }

        deleteContextualAction.backgroundColor = .black

        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction])
        return swipeActionsConfiguration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDictionary = dictionaryLists[indexPath.row]
        let selectedWord = selectedDictionary.name

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let savedDictionaryTVC = storyboard.instantiateViewController(withIdentifier: "toSavedDictionaryTVC") as? SavedDictionaryTVC {
            savedDictionaryTVC.navigationItem.title = selectedWord
            savedDictionaryTVC.dictionaryList = selectedDictionary
            navigationController?.pushViewController(savedDictionaryTVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateAvailableWords() {
        availableWords.removeAll()
        for dictionary in dictionaryLists {
            availableWords.append(dictionary.name)
        }
    }
}
