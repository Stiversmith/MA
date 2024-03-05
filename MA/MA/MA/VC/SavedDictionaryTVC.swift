import RealmSwift
import UIKit

class SavedDictionaryTVC: UITableViewController {
    var words: [String] = []
    var wordLists: Results<WordLists>!
    var delegate: TextVC?
    var selectedSentence: String?
    var filteredWords: [String] = []
    var savedWords: [String] = []
    var dictionaryList: DictionaryLists?
    var dictionaryLists: Results<DictionaryLists>!

    private var wordProcessor: WordProcessor
    private var cellUpdater: CellUpdater
    private var wordFilter: WordFilter
    private var translations: [String: String] = [:]

    private static var translater: Translater?

    init(wordLists: Results<WordLists>) {
        self.wordLists = wordLists
        self.wordProcessor = WordProcessor()
        self.cellUpdater = CellUpdater()
        self.wordFilter = WordFilter()
        super.init(nibName: nil, bundle: nil)
        let realm = try! Realm()
        dictionaryLists = realm.objects(DictionaryLists.self)
    }

    required init?(coder aDecoder: NSCoder) {
        self.wordLists = try? Realm().objects(WordLists.self)
        self.wordProcessor = WordProcessor()
        self.cellUpdater = CellUpdater()
        self.wordFilter = WordFilter()
        super.init(coder: aDecoder)
        let realm = try! Realm()
        dictionaryLists = realm.objects(DictionaryLists.self)
    }

    @IBOutlet var searchBar: UISearchBar!

    @IBAction func addWord(_ sender: Any) {
        AlertHandler.showAddOrUpdateWordAlert { [weak self] newWord in
            guard let self, let word = newWord else {
                return
            }
            WordManager.shared.addWord(word)
            self.tableView.reloadData()
        }
    }

    @IBAction func deleteAll(_ sender: Any) {
        StorageManager.deleteAll()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = dictionaryList?.name

        tableView.register(UINib(nibName: "MyCellTVC", bundle: nil), forCellReuseIdentifier: "Cell")

        searchBar.delegate = self

        Self.translater = Translater()

        let realm = try! Realm()
        let dictionaryLists = realm.objects(DictionaryLists.self)

        for dictionary in dictionaryLists {
            words += dictionary.words.map { $0.words }
        }

        processWords()
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

        var word = words[indexPath.row]
        cell.titleLabel.text = word

        if let numberLabel = cell.numberLbl {
            numberLabel.text = "\(indexPath.row + 1)"
        } else {
            print("numberLbl is nil!")
        }

        if !searchBar.text!.isEmpty {
            word = filteredWords[indexPath.row]
        } else {
            word = words[indexPath.row]
        }

        cell.translateCompletion = { [weak self, weak cell] word in
            self?.translateWord(word: word, forCell: cell!)
        }

        let translation = translations[word] ?? "Показать перевод"
        cell.translateBtn.setTitle(translation, for: .normal)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MyCellTVC

        let word = words[indexPath.row]

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

    func translateWord(word: String, forCell cell: MyCellTVC) {
        guard let translater = SavedDictionaryTVC.translater else { return }

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

    private func processWords() {
        guard let selectedDictionary = dictionaryList else { return }

        words = selectedDictionary.words.flatMap { $0.words.components(separatedBy: ",") }
        filteredWords = words.sorted()
        tableView.reloadData()
    }
}
