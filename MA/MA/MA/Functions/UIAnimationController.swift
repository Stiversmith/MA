import UIKit
import Lottie

class AnimationController: AnimationControllerProtocol {
    private let animationView: LottieAnimationView
    
    init(animationViewName: String, animationSpeed: CGFloat) {
        animationView = LottieAnimationView(name: animationViewName)
        animationView.backgroundColor = .black
        animationView.animationSpeed = animationSpeed
    }
    
    func setupUI(in container: UIStackView) {
        container.addArrangedSubview(animationView)
    }
    
    func playAnimation() {
        animationView.play()
    }
}
