import UIKit
import Foundation

/**
 To fetch the image, use the model passed in the set(model: CatImageCellModel) function. If the fetch failed due to a timeout, retry two more times. At any point, if we cannot fetch and show the proper model image, show the placeholderImage in imageView instead. And finally, when the cell is about to be prepared for reuse, please remove any existing image from imageView.
 */

enum ImageFetchingError: Error {
    case timeout
    case unknown
}

protocol CatImageCellModel {
    var placeholderImage: UIImage { get }
    func fetchCatImage(completion: @escaping (Result<UIImage, ImageFetchingError>) -> ())
}

struct UIImage: Equatable { }

class UIImageView {
    var image: UIImage?
}

class UICollectionViewCell {
    func prepareForReuse() {
        
    }
}

class CatImageModel: CatImageCellModel {
    var placeholderImage: UIImage {
        return UIImage()
    }
    
    func fetchCatImage(completion: @escaping (Result<UIImage, ImageFetchingError>) -> ()) {
        // success response
        //let image = UIImage()
        //completion(Result.success(image))
        
        // failure response
        completion(Result.failure(.timeout))
    }
}

final class CatImageCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var retryCount: Int = 0

    private let RETRY_MAX: Int = 2
    
    convenience init(imageView: UIImageView) {
        self.init()
        self.imageView = imageView
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.retryCount = 0
    }
    
    func set(model: CatImageCellModel) {
        model.fetchCatImage(completion: { result in
            switch result {
            
            case .success(let image):
                self.imageView.image = image
                print("success!")
                
            case .failure(let error):
                
                switch error {
                case .timeout:
                    if self.retryCount < self.RETRY_MAX {
                        self.retryCount += 1
                        print("retry")
                        self.set(model: model)
                    }
                case .unknown:
                    self.imageView.image = model.placeholderImage
                }
            }
        })
    }
}

let model = CatImageModel()

var cell = CatImageCell(imageView: UIImageView())
cell.prepareForReuse()
cell.set(model: model)
