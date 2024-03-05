import UIKit
import Vision

class TextVC: UIViewController, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var takePicButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var buttonStack: UIStackView!
    @IBOutlet var actInd: UIActivityIndicatorView!
    
    weak var delegate: TextVCDelegate?
    var text: String?
    var textToDisplay: String?
    var keyboardHeight: CGFloat = 0
    var isKeyboardShown = false
    let imagePickerController = UIImagePickerController()
    var selectedImage: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        textField.delegate = self
        
        if let text = delegate?.getRecognizedText() {
            textView.text = text
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        sendButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        if let text = textToDisplay { textView.text = text }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if let text = textField.text { textView.text = text }
    }
        
    @IBAction func takePicButtonTapped(_ sender: UIButton) { openCamera() }
        
    @IBAction func galleryButtonTapped(_ sender: UIButton) { openGalleryMenu() }
        
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let text = textView.text else { return }
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let uniqueWords = Array(Set(words))

        NotificationCenter.default.post(name: Notification.Name("UpdateTableViewData"), object: uniqueWords)

        if let dictionaryTVC = storyboard?.instantiateViewController(withIdentifier: "DictionaryTVC") as? DictionaryTVC {
            dictionaryTVC.words = uniqueWords

            if let selectedWord = textField.text,
               let sentence = getSentenceContainingWord(selectedWord, in: text)
            {
                dictionaryTVC.selectedSentence = sentence
            }

            dictionaryTVC.delegate = self
            
            navigationController?.pushViewController(dictionaryTVC, animated: true)
        }
    }

    func getSentenceContainingWord(_ word: String, in text: String) -> String? {
        let sentences = text.components(separatedBy: ".")
        for sentence in sentences {
            if sentence.contains(word) {
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else { showErrorAlert(message: "Камера недоступна.") }
    }
        
    func openGallery() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
        
    func openGalleryMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let downloadAction = UIAlertAction(title: "Скачать файл", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "toImageVC", sender: nil)
        }
        let galleryAction = UIAlertAction(title: "Открыть галерею", style: .default) { [weak self] _ in
            self?.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
        alertController.addAction(downloadAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
            
        present(alertController, animated: true, completion: nil)
    }
        
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
            
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showErrorAlert(message: "Не удалось получить изображение.")
            return
        }
            
        processImage(image)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
        
    func processImage(_ image: UIImage) {
        TextRecognizer.recognizeText(from: image) { [weak self] recognizedText in
            DispatchQueue.main.async {
                if recognizedText.isEmpty {
                    self?.showErrorAlert(message: "Не удалось распознать текст на фото.")
                } else { self?.textView.text = recognizedText }
            }
        }
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
            
        keyboardHeight = keyboardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) { animateTextField(0) }

    func animateTextField(_ up: Bool) {
        let movement = (up ? -keyboardHeight : 0)
        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            self.buttonStack.frame = self.buttonStack.frame.offsetBy(dx: 10, dy: movement)
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
            
        let keyboardY = keyboardFrame.origin.y
        let buttonStackMaxY = buttonStack.frame.maxY
        let bottomInset = view.safeAreaInsets.bottom
            
        let movement = keyboardY - buttonStackMaxY - bottomInset
        if movement < 0 { animateTextField(movement) }
        else { animateTextField(0) }
    }
        
    func animateTextField(_ movement: CGFloat) {
        UIView.animate(withDuration: 0.3) { self.view.frame.origin.y = movement }
    }
}
