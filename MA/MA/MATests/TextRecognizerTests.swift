import XCTest
@testable import MA

class TextRecognizerTests: XCTestCase {
    
    func testRecognizeText() {
        let image = UIImage(named: "testImage")!
        
        let expectation = XCTestExpectation(description: "Recognize text")
        
        TextRecognizer.recognizeText(from: image) { recognizedText in
            XCTAssertNotNil(recognizedText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWordCount() {
        let text = "This is a test string"
        
        let wordCount = TextRecognizer.getWordCount(from: text)
        
        XCTAssertEqual(wordCount, 5)
    }
    
    func testGetWordCountWithEmptyString() {
        let text = ""
        
        let wordCount = TextRecognizer.getWordCount(from: text)
        
        XCTAssertEqual(wordCount, 0)
    }
    
    func testGetWordCountWithWhitespaceString() {
        let text = "   "
        
        let wordCount = TextRecognizer.getWordCount(from: text)
        
        XCTAssertEqual(wordCount, 0)
    }
    
    func testGetWordCountWithMultipleSpacesBetweenWords() {
        let text = "This   is   a   test   string"
        
        let wordCount = TextRecognizer.getWordCount(from: text)
        
        XCTAssertEqual(wordCount, 5)
    }
    
    func testGetWordCountWithNewlines() {
        let text = """
                   This
                   is
                   a
                   test
                   string
                   """
        
        let wordCount = TextRecognizer.getWordCount(from: text)
        
        XCTAssertEqual(wordCount, 5)
    }
}

