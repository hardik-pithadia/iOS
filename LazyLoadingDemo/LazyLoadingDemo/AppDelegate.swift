//
//  AppDelegate.swift
//  LazyLoadingDemo
//
//  Created by Hardik Pithadia on 09/07/20.
//  Copyright © 2020 Hardik Pithadia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        
        self.window?.rootViewController = homeVC
        self.window?.makeKeyAndVisible()
        
        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
        }
        
        return true
    }
}

