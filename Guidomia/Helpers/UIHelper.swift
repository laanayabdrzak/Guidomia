//
//  UIHelper.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 22/11/2022.
//

import Foundation
import UIKit

class UIHelper {
    
    func setNavigationBar(tintColor: UIColor, navController: UINavigationController?, navItem: UINavigationItem) {
        navController?.navigationBar.isTranslucent = false
        navController?.navigationBar.tintColor = tintColor
        navController?.navigationBar.barTintColor = UIColor(named: "Orange")
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .orange
            navController?.navigationBar.standardAppearance = appearance
            navController?.navigationBar.scrollEdgeAppearance = appearance
        }
        navController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor]
        navController?.navigationBar.backItem?.title = ""
        /** Remove "Back" from Navigation Bar*/
        navItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        /** Just to make it close as possible to the mock-up  **/
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    }
    
    func setCustomNavigationTitle(title: String, navItem: UINavigationItem) {
        let titlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 40))
        titlelabel.text = title
        titlelabel.textColor = .white
        titlelabel.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        titlelabel.backgroundColor = UIColor.clear
        titlelabel.textAlignment = .left
        navItem.titleView = titlelabel
    }
}
