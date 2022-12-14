//
//  Constants.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

struct Constants {
    
    static let appName: String = "Guidomia"
    static let carsJSonFile: String = "CarList"
    static let star: String = "★"
    static let space: String = " "
    static let bulletIcon: String = "•  "
    static let priceLabel = "Price : "
    static let thousand: String = "k"
    static let viewRadius: CGFloat = 6.0
    static let headerHeight: CGFloat = 400.0
    static let selectedCellHeight: CGFloat = 340.0
    static let unselectedCellHeight: CGFloat = 140.0
    static let selectedDetailCellHeight: CGFloat = 200.0
    static let unselectedDetailCellHeight: CGFloat = 0.0
    
    static let firstLaunchKey: String = "First Launch"
    
    static let makeAttKeyEntity: String = "make"
    static let modelAttKeyEntity: String = "model"
    static let customerPriceAttKeyEntity: String = "customerPrice"
    static let marketPriceAttKeyEntity: String = "marketPrice"
    static let ratingAttKeyEntity: String = "rating"
    static let prosListAttKeyEntity: String = "prosList"
    static let consListAttKeyEntity: String = "consList"

}

public enum CarThumbnails: String {
    case bmw        = "BMW"
    case mercedes   = "Mercedes Benz"
    case alpine     = "Alpine"
    case rangeRover = "Land Rover"
    case toyota     = "Toyota"
    
    public var pngImage: UIImage {
        
        var imageName: String!
        
        switch self {
        case .mercedes:
            imageName = "Mercedez_benz_GLC"
        case .bmw:
            imageName = "BMW_330i"
        case .toyota:
            imageName = "Tacoma"
        case .rangeRover:
            imageName = "Range_Rover"
        case .alpine:
            imageName = "Alpine_roadster"
        }
        return UIImage(named: imageName) ?? UIImage()
    }
}
