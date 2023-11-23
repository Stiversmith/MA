
import RealmSwift
import UIKit

class DictionaryTVC: UITableViewController {
    var words: [String] = []
    var wordLists: WordLists
    var wordProcessor: WordProcessor
    var delegate: TextVC?
    var selectedSentence: String?
    
    init(wordLists: WordLists) {
        self.wordLists = wordLists
        self.wordProcessor = WordProcessor()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.wordLists = WordLists(nouns: [""], verbs: [""], adjectives: [""], adverbs: [""], pronouns: [""], prepositions: [""], conjunctions: [""], negativeParticles: [""], articles: [""], interjections: [""])
        self.wordProcessor = WordProcessor()
        super.init(coder: aDecoder)
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
        
        let partOfSpeech = WordLists.getPartOfSpeech(for: word)
        cell.detailTextLabel?.text = partOfSpeech
        
        if partOfSpeech == "Multiple" {
            cell.detailTextLabel?.textColor = .red
        } else {
            cell.detailTextLabel?.textColor = .black
        }
        
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
}
