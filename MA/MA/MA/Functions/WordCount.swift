import UIKit

class WordCount {
    static func showAlert(withWordCount wordCount: Int, completion: (() -> Void)? = nil) {
        let message = "Добавлено \(wordCount) слов"
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let viewController = windowScene.windows.first?.rootViewController else {
            return
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
