
import UIKit
import Vision

protocol TextVCDelegate: AnyObject {
    func setText(_ text: String)
    func getRecognizedText() -> String?
}

class ImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    @IBOutlet weak var recognizeButton: UIButton!
    
    var image: UIImage?
    var recognizedText: String?
    weak var delegate: TextVCDelegate?
        
    private let imageURL = "https://mulino58.ru/wp-content/uploads/0/2/7/0272c547749fb7a44fcf7700dd96bac3.jpg"
        
    override func viewDidLoad() {
            super.viewDidLoad()
            fetchImage()
            delegate = self
        }
        
    @IBAction func recognizeButtonTapped(_ sender: UIButton) {
            if let image = imageView.image {
                processImage(image)
            }
        }
        
    private func fetchImage() {
            guard let url = URL(string: imageURL) else { return }
            
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.activityIndic.stopAnimating()
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let response = response { print(response) }
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.imageView.image = image
                    } else { print("Error loading image data") }
                }
            }
            task.resume()
        }
        
    func processImage(_ image: UIImage) {
            TextRecognizer.recognizeText(from: image) { [weak self] recognizedText in
                self?.recognizedText = recognizedText
            }
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ToTextVC" {
                if let destinationVC = segue.destination as? TextVC {
                    destinationVC.delegate = self
                }
            }
        }
    }

extension ImageVC: TextVCDelegate {
    func setText(_ text: String) {
        let wordCount = TextRecognizer.getWordCount(from: text)
        let message = "Получено \(wordCount) слов"
        let alertController = UIAlertController(title: "Информация", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getRecognizedText() -> String? {
        return recognizedText
    }
}
