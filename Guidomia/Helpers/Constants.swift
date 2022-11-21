//
//  Constants.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

struct Constants {
    static let carList: String = "CarList"
    static let star: String = "★"
    static let space: String = " "
    static let priceLabel = "Price : "
    static let thousand: String = "k"
    static let viewRadius: CGFloat = 6.0
    static let headerHeight: CGFloat = 400.0
    static let selectedCellHeight: CGFloat = 340.0
    static let unselectedCellHeight: CGFloat = 140.0
    static let selectedDetailCellHeight: CGFloat = 200.0
    static let unselectedDetailCellHeight: CGFloat = 0.0

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
