import Foundation
import Alamofire

struct TranslationResponse: Decodable {
    let data: TranslationData
}

struct TranslationData: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
}

class Translater {
    var apiKey = "AIzaSyAXSreJh4EFLFPqmNTVlDYL3qxPZxCfKSs"
    
    func translate(word: String, completion: @escaping (String?) -> Void) {
        let url = "https://translation.googleapis.com/language/translate/v2"
        let parameters: [String: String] = [
            "q": word,
            "key": apiKey,
            "source": "en",
            "target": "ru"
        ]
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                .validate()
                .responseDecodable(of: TranslationResponse.self) { response in
                    switch response.result {
                    case .success(let translationResponse):
                        if let translatedText = translationResponse.data.translations.first?.translatedText {
                            DispatchQueue.main.async {
                                completion(translatedText)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
        }
    }
}
