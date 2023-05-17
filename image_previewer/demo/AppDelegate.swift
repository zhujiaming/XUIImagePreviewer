//
//  AppDelegate.swift
//  image_previewer
//
//  Created by zhujiaming on 2023/4/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        self.window?.makeKeyAndVisible()
        return true
    }
}

