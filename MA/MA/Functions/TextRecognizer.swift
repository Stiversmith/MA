
import UIKit
import Vision

class TextRecognizer {
    static func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else { return }
        
        let textRecognizer = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Text recognition error: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Error processing recognition results")
                return
            }
            
            var recognizedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
            }
            completion(recognizedText)
        }
        
        let requests = [textRecognizer]
        
        do {
            let imageHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try imageHandler.perform(requests)
        } catch {
            print("Error processing image: \(error)")
        }
    }
    
    static func getWordCount(from text: String) -> Int {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        let filteredComponents = components.filter { !$0.isEmpty }
        return filteredComponents.count
    }
}
