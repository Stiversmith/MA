import XCTest
@testable import MA

class AnimationControllerTests: XCTestCase {
    var animationController: AnimationController!
    
    override func setUp() {
        super.setUp()
        animationController = AnimationController(animationViewName: "wired-lineal-35-edit", animationSpeed: 1.0)
    }
    
    override func tearDown() {
        animationController = nil
        super.tearDown()
    }
    
    func testAnimationViewInitialization() {
        XCTAssertNotNil(animationController.animationView)
        XCTAssertEqual(animationController.animationView.backgroundColor, .black)
        XCTAssertEqual(animationController.animationView.animationSpeed, 1.0)
    }
    
    func testSetupUI() {
        let container = UIStackView()
        
        animationController.setupUI(in: container)
        
        XCTAssertTrue(container.arrangedSubviews.contains(animationController.animationView))
    }
    
    func testPlayAnimation() {
        animationController.playAnimation()
        
        XCTAssertTrue(animationController.animationView.isAnimationPlaying)
    }
}

