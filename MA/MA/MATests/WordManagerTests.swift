import XCTest
@testable import MA

class WordManagerTests: XCTestCase {
    
    var wordManager: WordManager!
    
    override func setUp() {
        super.setUp()
        wordManager = WordManager.shared
    }
    
    override func tearDown() {
        wordManager = nil
        super.tearDown()
    }
    
    func testAddWord() {
        let word = "Test"
        
        wordManager.addWord(word)
        
        XCTAssertEqual(wordManager.availableWords.count, 1)
        XCTAssertEqual(wordManager.availableWords.first, word)
    }
    
    func testSaveName() {
        let dictName = "Test Dictionary"
        let words = ["Word1", "Word2", "Word3"]
        
        let viewController = UIViewController()
        
        wordManager.saveName(dictName: dictName, words: words, from: viewController)
        
    }
    
    
}
