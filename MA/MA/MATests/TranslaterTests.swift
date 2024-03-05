import XCTest
import Alamofire

@testable import MA

class TranslationTests: XCTestCase {
    
    var sut: Translater!
    
    override func setUp() {
        super.setUp()
        sut = Translater()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testTranslate_SuccessfulTranslation_ReturnsTranslatedText() {
        // Given
        let expectation = XCTestExpectation(description: "Translation completed successfully")
        
        // When
        sut.translate(word: "hello") { translatedText in
            // Then
            XCTAssertNotNil(translatedText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTranslate_FailedTranslation_ReturnsNil() {
        // Given
        let expectation = XCTestExpectation(description: "Translation failed")
        
        // When
        sut.translate(word: "") { translatedText in
            // Then
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testTranslate_InvalidAPIKey_ReturnsNil() {
        // Given
        let expectation = XCTestExpectation(description: "Invalid API key")
        
        // When
        sut.apiKey = "AIzaSyAXSreJh4EFLFPqmNTVlDYL3qxPZxCfKSs"
        
         sut.translate(word: "hello") { translatedText in
            // Then
            XCTAssertNil(translatedText)
            expectation.fulfill()
         }
         
         wait(for: [expectation], timeout: 5.0)
     }

     func testTranslate_EmptyWord_ReturnsNil() {
         // Given
         let expectation = XCTestExpectation(description: "Empty word")
         
         // When
         sut.translate(word: "") { translatedText in
             // Then
             XCTAssertNil(translatedText)
             expectation.fulfill()
         }
         
         wait(for: [expectation], timeout: 5.0)
     }
     
     func testTranslate_NetworkError_ReturnsNil() {
         // Given
         let expectation = XCTestExpectation(description: "Network error")
         
         // When
         sut.translate(word: "hello") { translatedText in
             // Then
             XCTAssertNil(translatedText)
             expectation.fulfill()
         }
         
         wait(for: [expectation], timeout: 5.0)
     }
     
     func testTranslate_Timeout_ReturnsNil() {
         // Given
         let expectation = XCTestExpectation(description: "Timeout")
         
         // When
         sut.translate(word: "hello") { translatedText in
             // Then
             XCTAssertNil(translatedText)
             expectation.fulfill()
         }
         
         wait(for: [expectation], timeout: 5.0)
     }
}
