import UIKit

class ImageFetcher {
    static func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image data")
                completion(nil)
                return
            }
            
            completion(image)
        }
        task.resume()
    }
}
