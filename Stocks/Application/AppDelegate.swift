//
//  AppDelegate.swift
//  Stocks
//
//  Created by  User on 24.05.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewNavControl = UINavigationController(rootViewController: MainScreenViewController())
        
        let tabBar = UITabBarController()
        tabBar.setViewControllers([mainViewNavControl], animated: false)
        
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()// Override point for customization after application launch.
        return true
    }
}
