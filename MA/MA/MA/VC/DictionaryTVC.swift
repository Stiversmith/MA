import RealmSwift
import UIKit

class DictionaryTVC: UITableViewController {
    var words: [String] = []
    var wordLists: Results<WordLists>!
    var wordProcessor: WordProcessor
    var delegate: TextVC?
    var selectedSentence: String?
    var filteredWords: [String] = []
    
    init(wordLists: Results<WordLists>) {
        self.wordLists = wordLists
        self.wordProcessor = WordProcessor()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.wordLists = try? Realm().objects(WordLists.self)
        self.wordProcessor = WordProcessor()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func addWord(_ sender: Any) {
        alertForAddAndUpdatesWords()
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        StorageManager.deleteAll()
        self.tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MyCellTVC", bundle: nil), forCellReuseIdentifier: "Cell")

        processWords()
        
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let wordCount = words.count
        let message = "Добавлено \(wordCount) слов"
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            self?.tableView.reloadData()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBar.text!.isEmpty {
            return filteredWords.count
        } else {
            return words.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyCellTVC ?? MyCellTVC()
        let word: String
        
        if !searchBar.text!.isEmpty {
            word = filteredWords[indexPath.row]
        } else {
            word = words[indexPath.row]
        }
        
        let translation = getTranslationForWord(word) ?? "Перевод недоступен, советуем купить словарь"
        
        if let numberLabel = cell.numberLbl {
            numberLabel.text = "\(indexPath.row + 1)"
        } else {
            print("numberLbl is nil!")
        }
        
        cell.numberLbl.text = "\(indexPath.row + 1)"
        cell.titleLabel.text = word
        cell.detailsLabel.text = translation  // "еще работаем над этим..."
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = words[indexPath.row]
        
        if let textVC = delegate, let text = textVC.textView.text {
            showAlert(withText: text, forWord: word)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentWord = wordLists[indexPath.row]
            
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteWord(word: currentWord)
            self?.words.remove(at: indexPath.row)
            self?.updateCellNumbers()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.updateCellNumbers()
            self?.tableView.endUpdates()
        }
            
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesWords(currentWord: currentWord, indexPath: indexPath)
        }
            
        deleteContextualAction.backgroundColor = .black
        editContextualAction.backgroundColor = .gray
            
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [editContextualAction, deleteContextualAction])
        return swipeActionsConfiguration
    }
    
    private func processWords() {
        let uniqueWords = WordProcessor.processWords(words)
        words = uniqueWords.sorted()
        tableView.reloadData()

        for word in uniqueWords {
            let wordObject = WordLists()
            wordObject.words = word
            StorageManager.saveWord(word: wordObject)
        }
    }
    
    private func showAlert(withText text: String, forWord word: String) {
        if let sentence = getSentenceContainingWord(word, in: text) {
            let alertController = UIAlertController(title: "\(word)", message: "Слово используется в предложении: \(sentence)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "\(word)", message: "Извини, не помню откуда это слово взялось. Наверное это ты его написал.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    func getSentenceContainingWord(_ word: String, in text: String) -> String? {
        let sentences = text.components(separatedBy: ".")
        for sentence in sentences {
            let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            let words = trimmedSentence.components(separatedBy: .whitespacesAndNewlines)
            for wordInSentence in words {
                if wordInSentence.compare(word, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
                    return trimmedSentence
                }
            }
        }
        return nil
    }
    
    private func alertForAddAndUpdatesWords(currentWord: WordLists? = nil, indexPath: IndexPath? = nil) {
        let title = currentWord == nil ? "New word" : "Edit"
        let message = "Please insert a new word"
        let doneButtonName = currentWord == nil ? "Save" : "Update"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            guard let self, let newWord = alertTextField.text, !newWord.isEmpty else { return }

            if let currentWord = currentWord,
               let indexPath = indexPath
            {
                StorageManager.editWord(word: currentWord, newWord: newWord)
                self.words[indexPath.row] = newWord
                self.tableView.reloadData()
            } else {
                let wordObject = WordLists()
                wordObject.words = newWord
                StorageManager.saveWord(word: wordObject)
                self.words.append(newWord)
                processWords()
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "a new word"
            
            if let currentWord = currentWord {
                alertTextField.text = currentWord.words
            }
        }
        
        present(alertController, animated: true)
    }
    
    private func getTranslationForWord(_ word: String) -> String? {
        let translater = Translater()
        var translation: String?

        let semaphore = DispatchSemaphore(value: 0)

        translater.translate(word: word) { translatedText in
            translation = translatedText
            semaphore.signal()
        }

        semaphore.wait()

        if let translation = translation {
            print("Перевод для '\(word)': \(translation)")
        } else {
            print("Что бы перевести '\(word)' сходи и купи словарь себе.")
        }

        return translation
    }
    
    private func updateCellNumbers() {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? MyCellTVC {
                cell.numberLbl.text = "\(indexPath.row + 1)"
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredWords = words.filter({ (word: String) -> Bool in
            return word.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension DictionaryTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
