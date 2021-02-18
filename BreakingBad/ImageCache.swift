/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Image cache.
*/
import UIKit
import Foundation


protocol ImageCachable {
	var cacheId: String { get }
	var url: String { get }
}

class ImageCache {
    
	static let publicCache = ImageCache()
    var placeholderImage = UIImage()
	private var cachedImages = [String: UIImage]()
    
	final func image(urlString: String) -> UIImage? {
        return cachedImages[urlString]
    }

	final func load(item: ImageCachable, completion: @escaping (ImageCachable, UIImage?) -> Swift.Void) {
		guard let swiftUrl = URL(string: item.url) else {
			completion(item, nil)
			return
		}
		if let cachedImage = image(urlString: item.cacheId) {
			completion(item, cachedImage)
            return
        }

		URLSession.shared.dataTask(with: swiftUrl) { (data, response, error) in
			if let _ = error {
				completion(item, nil)
                return
			}
			
            guard let responseData = data, let image = UIImage(data: responseData) else {
				completion(item, nil)
                return
            }
			
			if self.cachedImages.count > 50 {
				self.cachedImages.removeAll()
			}
			self.cachedImages.updateValue(image, forKey: item.cacheId)
			completion(item, image)
        }.resume()
    }
}
