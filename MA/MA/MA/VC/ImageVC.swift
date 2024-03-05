
import UIKit
import Vision

protocol TextVCDelegate: AnyObject {
    func setText(_ text: String)
    func getRecognizedText() -> String?
}

class ImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndic: UIActivityIndicatorView!
    @IBOutlet var recognizeButton: UIButton!
    
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
                
            if let textVC = storyboard?.instantiateViewController(withIdentifier: "TextVC") as? TextVC {
                textVC.textToDisplay = recognizedText
                navigationController?.pushViewController(textVC, animated: true)
            }
        }
    }
        
    private func fetchImage() {
        guard let url = URL(string: imageURL) else { return }
        
        activityIndic.startAnimating()
        
        ImageFetcher.fetchImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndic.stopAnimating()
                
                if let image = image {
                    self?.imageView.image = image
                }
            }
        }
    }
        
    func processImage(_ image: UIImage) {
        TextRecognizer.recognizeText(from: image) { [weak self] recognizedText in
            self?.recognizedText = recognizedText
        }
    }
}


