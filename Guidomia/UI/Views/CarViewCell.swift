//
//  CarViewCell.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

class CarViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carRating: UILabel!
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var prosLabel: UILabel!
    @IBOutlet weak var consLabel: UILabel!
    @IBOutlet weak var prosDetails: UILabel!
    @IBOutlet weak var consDetails: UILabel!
    @IBOutlet private weak var heightDetailVConstraint: NSLayoutConstraint!
    //MARK: - Props
    static let identifier = "CarViewCell"
    static let nibName = "CarViewCell"
    
    public var car: Car? {
        didSet { self.fillData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [carName, carPrice, prosDetails, consDetails].forEach({$0?.text = ""})
        carImageView.image = nil
    }
    
    private func fillData() {
        fillThumb()
        fillCarName()
        fillCarPrice()
        fillCarRating()
        fillProsDetails()
        fillConsDetails()
    }
    
    private func fillThumb() {
        carImageView.image = car?.carThumb()
    }
    
    private func fillCarName() {
        carName.text = car?.carModelAndMake()
    }
    
    private func fillCarPrice() {
        carPrice.text = car?.carDisplayPrice()
    }
    
    private func fillCarRating() {
        carRating.text = car?.carRating()
    }
    
    private func fillProsDetails() {
        prosLabel.isHidden = car?.carProsHidden() ?? false
        if !prosLabel.isHidden {
            if let prosArray = car?.prosList.filter({ $0.isEmpty == false }) {
                prosDetails.attributedText = NSAttributedString().displayBulletedText(for: prosArray)
            }
        }
    }
    
    private func fillConsDetails() {
        consLabel.isHidden = car?.carConsHidden() ?? false
        if !consLabel.isHidden {
            if let consArray = car?.consList.filter({ $0.isEmpty == false }) {
                consDetails.attributedText = NSAttributedString().displayBulletedText(for: consArray)
            }
        }
    }
    
}

extension CarViewCell {
    
    var isDetailViewHidden: Bool {
        return detailView.isHidden
    }
    
    func showDetailView() {
        heightDetailVConstraint.constant = Constants.selectedDetailCellHeight
        detailView.isHidden = false
    }
    
    func hideDetailView() {
        heightDetailVConstraint.constant = Constants.selectedDetailCellHeight
        detailView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
}
