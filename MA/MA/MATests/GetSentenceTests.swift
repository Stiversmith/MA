import XCTest
import RealmSwift
@testable import MA

class TextProcessorTests: XCTestCase {
    
    func testGetSentenceContainingWord_WhenWordExistsInText_ReturnsCorrectSentence() {
        // Arrange
        let word = "apple"
        let text = "I love eating apples. Apples are delicious."
        
        // Act
        let result = TextProcessor.getSentenceContainingWord(word, in: text)
        
        // Assert
        XCTAssertEqual(result, "I love eating apples")
    }
    
    func testGetSentenceContainingWord_WhenWordDoesNotExistInText_ReturnsNil() {
        // Arrange
        let word = "banana"
        let text = "I love eating apples. Apples are delicious."
        
        // Act
        let result = TextProcessor.getSentenceContainingWord(word, in: text)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func testGetSentenceContainingWord_WhenTextContainsMultipleSentencesWithTheSameWord_ReturnsFirstMatchingSentence() {
        // Arrange
        let word = "apple"
        let text = "I love eating apples. Apples are delicious. Apple pie is my favorite dessert."
        
        // Act
        let result = TextProcessor.getSentenceContainingWord(word, in: text)
        
        // Assert
        XCTAssertEqual(result, "I love eating apples")
    }
    
    func testGetSentenceContainingWord_WhenTextContainsSpecialCharacters_ReturnsCorrectSentence() {
         // Arrange
         let word = "apple"
         let text = "I love eating apples! Apples are delicious."
         
         // Act
         let result = TextProcessor.getSentenceContainingWord(word, in: text)
         
         // Assert
         XCTAssertEqual(result, "I love eating apples!")
     }
     
     func testGetSentenceContainingWord_WhenTextContainsWhitespaceBeforeAndAfterTheSentence_ReturnsCorrectSentence() {
         // Arrange
         let word = "apple"
         let text = "   I love eating apples.   "
         
         // Act
         let result = TextProcessor.getSentenceContainingWord(word, in: text)
         
         // Assert
         XCTAssertEqual(result, "I love eating apples")
     }
     
     func testGetSentenceContainingWord_WhenTextContainsMultipleOccurrencesOfTheWordInDifferentSentences_ReturnsFirstMatchingSentence() {
         // Arrange
         let word = "apple"
         let text = "I love eating apples. Apples are delicious. I also enjoy apple pie."
         
         // Act
         let result = TextProcessor.getSentenceContainingWord(word, in: text)
         
         // Assert
         XCTAssertEqual(result, "I love eating apples")
     }
}
