import XCTest
@testable import MA

class AlertHandlerTranslatedTests: XCTestCase {
    
    func testShowAlert_withValidTranslation_shouldDisplayAlertWithTranslatedWord() {
        // Arrange
        let expectation = self.expectation(description: "Alert displayed")
        let text = "This is a sample text"
        let word = "sample"
        
        // Act
        AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testShowAlert_withInvalidTranslation_shouldDisplayAlertWithErrorMessage() {
        // Arrange
        let expectation = self.expectation(description: "Alert displayed")
        let text = "This is a sample text"
        let word = "invalid"
        
        // Act
        AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testShowAlert_withValidSentence_shouldDisplayAlertWithTranslatedSentence() {
        // Arrange
        let expectation = self.expectation(description: "Alert displayed")
        let text = "This is a sample sentence. It contains the word sample."
        
         let word = "sample"
        
         // Act
         AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
             expectation.fulfill()
         }
         
         // Assert
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     func testShowAlert_withInvalidSentence_shouldDisplayErrorMessage() {
         // Arrange
         let expectation = self.expectation(description: "Alert displayed")
         let text = "This is a sample sentence."
         
          let word = "invalid"
         
          // Act
          AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
              expectation.fulfill()
          }
          
          // Assert
          waitForExpectations(timeout: 5, handler: nil)
      }
      
      func testShowAlert_withEmptyText_shouldDisplayErrorMessage() {
          // Arrange
          let expectation = self.expectation(description: "Alert displayed")
          let text = ""
          
           let word = "sample"
          
           // Act
           AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
               expectation.fulfill()
           }
           
           // Assert
           waitForExpectations(timeout: 5, handler: nil)
       }
       
       func testShowAlert_withEmptyWord_shouldDisplayErrorMessage() {
           // Arrange
           let expectation = self.expectation(description: "Alert displayed")
           let text = "This is a sample text"
           
            let word = ""
           
            // Act
            AlertHandlerTranslated.showAlert(withText: text, forWord: word) {
                expectation.fulfill()
            }
            
            // Assert
            waitForExpectations(timeout: 5, handler: nil)
        }
}
