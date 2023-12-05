import UIKit
import Lottie

protocol AnimationControllerProtocol {
    func setupUI(in container: UIStackView)
    func playAnimation()
}


class MainVC: UIViewController {
    
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var dictionaryBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewS: UIStackView!
    
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
