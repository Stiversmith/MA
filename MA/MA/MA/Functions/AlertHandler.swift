import UIKit

class AlertHandler {
    static func showAddOrUpdateWordAlert(currentWord: WordLists? = nil, indexPath: IndexPath? = nil, completion: @escaping (String?) -> Void) {
        let title = currentWord == nil ? "Новое слово" : "Редактировать"
        let message = "Пожалуйста, введите новое слово"
        let doneButtonName = currentWord == nil ? "Сохранить" : "Обновить"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            guard let newWord = alertTextField.text, !newWord.isEmpty else {
                completion(nil)
                return
            }
            
            completion(newWord)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { _ in
            completion(nil)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "Новое слово"
            
            if let currentWord = currentWord {
                alertTextField.text = currentWord.words
            }
        }
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func showSaveDictAlert(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Сохранить словарь", message: "Введите название словаря", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let dictName = alertTextField.text, !dictName.isEmpty else {
                completion(nil)
                return
            }
            
            completion(dictName)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { _ in
            completion(nil)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "Название словаря"
        }
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
