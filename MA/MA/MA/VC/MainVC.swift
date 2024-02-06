import Lottie
import UIKit

protocol AnimationControllerProtocol {
    func setupUI(in container: UIStackView)
    func playAnimation()
}

class MainVC: UIViewController {
    
    @IBOutlet var textBtn: UIButton!
    @IBOutlet var dictionaryBtn: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewS: UIStackView!
    
    private var animationController: AnimationControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationViewName = "wired-lineal-35-edit"
        let animationSpeed: CGFloat = 0.6
        
        animationController = AnimationController(animationViewName: animationViewName, animationSpeed: animationSpeed)
        animationController.setupUI(in: stackView)
        animationController.playAnimation()
    }
}
