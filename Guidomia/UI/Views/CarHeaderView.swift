//
//  CarHeaderView.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

class CarHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var makeTxtView: UITextField!
    @IBOutlet weak var modelTxtView: UITextField!
    @IBOutlet weak var filterView: UIView!
    
    static let headerID: String = "CarHeaderView"
    static let nibName = "CarHeaderView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [modelTxtView, makeTxtView, filterView].forEach({ $0?.layer.cornerRadius = Constants.viewRadius;
            $0?.layer.masksToBounds = true })
    }
    
}
