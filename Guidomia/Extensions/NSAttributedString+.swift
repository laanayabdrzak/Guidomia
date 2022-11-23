//
//  NSAttributedStringHelper.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

extension NSAttributedString {
    
    private func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
    
    private func withOrangeBullet() -> NSAttributedString {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = UIColor.orange
        attributes[.font] = UIFont.systemFont(ofSize: 24, weight: .heavy)
        let attributedString = NSAttributedString(string: Constants.bulletIcon, attributes: attributes)
        return attributedString
    }
    
    
    func displayBulletedText(for inputArray:[String]) -> NSAttributedString {
        let bullet = withOrangeBullet()
        
        let eas = NSMutableAttributedString()
        inputArray.forEach {
            eas.append(bullet)
            eas.append(NSAttributedString(string: $0))
            eas.append(NSAttributedString(string: "\n"))
        }
        
        let combination = NSMutableAttributedString()
        combination.append(eas)
        return combination.withLineSpacing(5.0)
    }
}
