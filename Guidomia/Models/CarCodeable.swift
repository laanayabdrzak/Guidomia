import UIKit

/****
 Codable will allow you to covert from JSON to a Struct
 with JSONDecoder().decode(_:from:).
 */
struct CarCodeable: Codable {
    
    var consList: [String]
    var customerPrice: Double
    var make: String
    var marketPrice: Double
    var model: String
    var prosList: [String]
    var rating: Int
    
    enum CodingKeys: String, CodingKey {
        case consList = "consList"
        case customerPrice = "customerPrice"
        case make = "make"
        case marketPrice = "marketPrice"
        case model = "model"
        case prosList = "prosList"
        case rating = "rating"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        consList = try values.decode([String].self, forKey: .consList)
        customerPrice = try values.decode(Double.self, forKey: .customerPrice)
        make = try values.decode(String.self, forKey: .make)
        marketPrice = try values.decode(Double.self, forKey: .marketPrice)
        model = try values.decode(String.self, forKey: .model)
        prosList = try values.decode([String].self, forKey: .prosList)
        rating = try values.decode(Int.self, forKey: .rating)
    }
    
    init(make: String, model: String, customerPrice: Double, marketPrice: Double,
         rating: Int, consList: [String], prosList: [String]) {
        self.make = make
        self.model = model
        self.customerPrice = customerPrice
        self.marketPrice = marketPrice
        self.rating = rating
        self.consList = consList
        self.prosList = prosList
    }
}

extension CarCodeable {
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
