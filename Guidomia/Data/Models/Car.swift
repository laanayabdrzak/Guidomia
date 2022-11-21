import UIKit

struct Car: Codable {
    
    var consList: [String]
    var customerPrice: Double
    var make: String
    var marketPrice: Double
    var model: String
    var prosList: [String]
    var rating: Int
    
    func carModelAndMake() -> String {
        return make + Constants.space + model
    }
    
    func carDisplayPrice() -> String {
        let intPrice = Int((customerPrice/1000))
        return Constants.priceLabel + String(intPrice) + Constants.thousand
    }
    
    func carRating() -> String {
        var star = Constants.star
        let spacePlusStar = Constants.space + star
        for _ in 1..<rating {
            star.append(spacePlusStar)
        }
        return star
    }
    
    func carProsHidden() -> Bool {
        return prosList.count == 0 ? true: false
    }
    
    func carConsHidden() -> Bool {
        return consList.count == 0 ? true: false
    }
    
    func carThumb() -> UIImage {
        
        switch CarThumbnails(rawValue: make) {
        case .bmw :
            return CarThumbnails.bmw.pngImage
        case .mercedes:
            return CarThumbnails.mercedes.pngImage
        case .rangeRover:
            return CarThumbnails.rangeRover.pngImage
        case .alpine:
            return CarThumbnails.alpine.pngImage
        case .toyota:
            return CarThumbnails.toyota.pngImage
        default:
            return UIImage()
        }
    }
}
