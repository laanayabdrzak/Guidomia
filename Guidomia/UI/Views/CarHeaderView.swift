//
//  CarHeaderView.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

protocol CarHeaderDelegate: AnyObject {
    
    func didSearchFor(make: String)
    func didSearchFor(model: String)
}

class CarHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var makeTxtView: UITextField!
    @IBOutlet weak var modelTxtView: UITextField!
    @IBOutlet weak var filterView: UIView!
    
    //MARK: - Props
    static let headerID: String = "CarHeaderView"
    static let nibName = "CarHeaderView"
    var delegate: CarHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [modelTxtView, makeTxtView, filterView].forEach({ $0?.layer.cornerRadius = Constants.viewRadius;
            $0?.layer.masksToBounds = true })
        
        makeTxtView.addTarget(self, action: #selector(CarHeaderView.textFieldDidChange(_:)),
                              for: .editingChanged)
        
        modelTxtView.addTarget(self, action: #selector(CarHeaderView.textFieldDidChange(_:)),
                               for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case makeTxtView: self.delegate?.didSearchFor(make: textField.text ?? "")
        case modelTxtView: self.delegate?.didSearchFor(model: textField.text ?? "")
        default: break
        }
    }
    
}
