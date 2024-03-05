import UIKit

extension ImageVC: TextVCDelegate {
    func setText(_ text: String) {
        let wordCount = TextRecognizer.getWordCount(from: text)
        let message = "Получено \(wordCount) слов"
        let alertController = UIAlertController(title: "Информация", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func getRecognizedText() -> String? { return recognizedText }
}
