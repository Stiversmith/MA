import UIKit

class AlertHandlerTranslated {
    static func showAlert(withText text: String, forWord word: String, completion: @escaping () -> Void) {
        let translater = Translater()
        
        translater.translate(word: word) { translatedWord in
            let title: String
            var message: String
            
            if let translation = translatedWord {
                title = "\(word) - \(translation)"
                message = ""
            } else {
                title = "\(word) - перевод недоступен"
                message = "рекомендуем проверить словарь"
            }
            
            if let sentence = TextProcessor.getSentenceContainingWord(word, in: text) {
                translater.translate(word: sentence) { translatedSentence in
                    if let translatedSentence = translatedSentence {
                        message += "Оригинальное предложение: \n\(sentence)"
                        message += "\nПеревод: \n\(translatedSentence)"
                    } else {
                        message += "\nПредложение: \(sentence)"
                    }
                    self.displayAlert(withTitle: title, message: message, completion: completion)
                }
            } else {
                message += "\nИзвините, не помню откуда это слово взялось. Возможно, вы его использовали."
                self.displayAlert(withTitle: title, message: message, completion: completion)
            }
        }
    }

    private static func displayAlert(withTitle title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let rootViewController = scene.windows.first?.rootViewController {
                    rootViewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
