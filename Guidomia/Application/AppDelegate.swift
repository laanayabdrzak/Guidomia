//
//  AppDelegate.swift
//  Guidomia
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBarAppearance()
        setupRootViewController()
        return true
    }
    
    private func setupNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "Orange")
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isOpaque = true
    }
    
    private func setupRootViewController() {
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: CarsVC())
        window?.makeKeyAndVisible()
    }
    
}

