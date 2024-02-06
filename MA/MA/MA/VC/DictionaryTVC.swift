import UIKit
import RealmSwift

class DictionaryTVC: UITableViewController {
    var words: [String] = []
    var wordLists: Results<WordLists>!
    var delegate: TextVC?
    var selectedSentence: String?
    var filteredWords: [String] = []

    private var wordProcessor: WordProcessor
    private var cellUpdater: CellUpdater
    private var wordFilter: WordFilter
    private var translations: [String: String] = [:]

    
    private static var translater: Translater?

    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func addWord(_ sender: Any) {
        AlertHandler.showAddOrUpdateWordAlert { [weak self] newWord in
            guard let self, let word = newWord else {
                return
            }
            WordManager.shared.addWord(word)
            processWords()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        StorageManager.deleteAll()
        self.tableView.reloadData()
    }

    @IBAction func saveDict(_ sender: Any) {
        AlertHandler.showSaveDictAlert { [weak self] dictName in
            guard let dictName = dictName else {
                return
            }
            
            print("Сохранение словаря: \(dictName)")

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let listTVC = storyboard.instantiateViewController(withIdentifier: "ListTVC") as? ListTVC {
                listTVC.selectedWord = dictName // передать значение dictName в selectedWord
                self?.navigationController?.pushViewController(listTVC, animated: true)
            }
        }
    }
    
    init(wordLists: Results<WordLists>) {
            self.wordLists = wordLists
            self.wordProcessor = WordProcessor()
            self.cellUpdater = CellUpdater()
            self.wordFilter = WordFilter()
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            self.wordLists = try? Realm().objects(WordLists.self)
            self.wordProcessor = WordProcessor()
            self.cellUpdater = CellUpdater()
            self.wordFilter = WordFilter()
            super.init(coder: aDecoder)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.register(UINib(nibName: "MyCellTVC", bundle: nil), forCellReuseIdentifier: "Cell")

            processWords()

            searchBar.delegate = self
            
            Self.translater = Translater()
            
            WordManager.shared.wordAddedHandler = { [weak self] word in
                        self?.words.append(word)
                        self?.tableView.reloadData()
                    }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            let wordCount = words.count
            WordCount.showAlert(withWordCount: wordCount) {
                self.tableView.reloadData()
            }
        }

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

            if let numberLabel = cell.numberLbl {
                numberLabel.text = "\(indexPath.row + 1)"
            } else {
                print("numberLbl is nil!")
            }

            cell.numberLbl.text = "\(indexPath.row + 1)"
            cell.titleLabel.text = word
            
            cell.translateCompletion = { [weak self, weak cell] word in
                self?.translateWord(word: word, forCell: cell!)
            }

            if let translation = translations[word] {
                cell.translateBtn.setTitle(translation, for: .normal)
            } else {
                cell.translateBtn.setTitle("Показать перевод", for: .normal)
            }

            return cell
        }

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath) as? MyCellTVC

            let word = words[indexPath.row]

            cell?.showActivityIndicator()

            if let textVC = delegate, let text = textVC.textView.text {
                AlertHandlerTranslated.showAlert(withText: text, forWord: word) { [weak self] in
                    cell?.hideActivityIndicator()
                }
            }
        }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let currentWord = wordLists[indexPath.row]

            let deleteContextualAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
                StorageManager.deleteWord(word: currentWord)
                self?.words.remove(at: indexPath.row)
                CellUpdater.updateCellNumbers(for: tableView)
                tableView.deleteRows(at: [indexPath], with: .fade)
                CellUpdater.updateCellNumbers(for: tableView)
                tableView.endUpdates()
            }

            let editContextualAction = UIContextualAction(style: .destructive, title: "Редактировать") { [weak self] _, _, _ in
                AlertHandler.showAddOrUpdateWordAlert(currentWord: currentWord, indexPath: indexPath) { [weak self] word in
                    guard let word = word else { return }

                    StorageManager.editWord(word: currentWord, newWord: word)
                    self?.words[indexPath.row] = word
                    tableView.reloadData()
                }
            }

            deleteContextualAction.backgroundColor = .black
            editContextualAction.backgroundColor = .white

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

        func filterContentForSearchText(_ searchText: String) {
            if !searchText.isEmpty {
                filteredWords = WordFilter.filterWords(words, for: searchText)
            } else {
                filteredWords = words
            }
            tableView.reloadData()
        }

        func translateWord(word: String, forCell cell: MyCellTVC) {
            guard let translater = DictionaryTVC.translater else { return }
            
            cell.showActivityIndicator()
            
            translater.translate(word: word) { [weak cell] translatedText in
                cell?.hideActivityIndicator()
                
                if let translatedText = translatedText {
                    self.translations[word] = translatedText
                    cell?.translateBtn.setTitle(translatedText, for: .normal)
                    print("Перевод для '\(word)': \(translatedText)")
                } else {
                    print("Чтобы перевести '\(word)', сходите и купите себе словарь.")
                }
            }
        }
    }
