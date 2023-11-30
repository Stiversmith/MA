
import UIKit
import RealmSwift

class DictionaryTVC: UITableViewController {
    var words: [String] = []
    var wordLists: Results<WordLists>!
    var wordProcessor: WordProcessor
    var delegate: TextVC?
    var selectedSentence: String?
    
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
    
    @IBAction func addWord(_ sender: Any) {
        alertForAddAndUpdatesListTasks()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        processWords()
        
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
        return words.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let word = words[indexPath.row]
        cell.textLabel?.text = word
        
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
            StorageManager.deleteWord(words: currentWord)
//            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesListTasks(currentWord: currentWord, indexPath: indexPath)
        }
        
   //     deleteContextualAction.backgroundColor = .gray
        editContextualAction.backgroundColor = .gray
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [editContextualAction, deleteContextualAction])  // deleteContextualAction

        return swipeActionsConfiguration
    }
    
    private func processWords() {
        let uniqueWords = WordProcessor.processWords(words)
        words = uniqueWords
    }
    
    private func showAlert(withText text: String, forWord word: String) {
        if let sentence = getSentenceContainingWord(word, in: text) {
            let alertController = UIAlertController(title: "Alert", message: "Слово используется в предложении: \(sentence)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Alert", message: "Sorry, I forgot where that word was.", preferredStyle: .alert)
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
    
    private func alertForAddAndUpdatesListTasks(currentWord: WordLists? = nil, indexPath: IndexPath? = nil) {
        
        let title = currentWord == nil ? "New word" : "Edit"
        let messege = "Please insert new word"
        let doneButtonName = currentWord == nil ? "Save" : "Update"
        
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            
            guard let self,
                  let newWord = alertTextField.text,
                  !newWord.isEmpty else { return }
            
            if let currentWord = currentWord,
               let indexPath = indexPath {
                StorageManager.editWord(word: currentWord, newWord: newWord)
            } else {

                let wordLists = WordLists()
                wordLists.words = newWord
                StorageManager.saveWord(words: wordLists)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.text = currentWord?.words
            alertTextField.placeholder = "a new word"
        }
        
        present(alertController, animated: true)
    }
}
