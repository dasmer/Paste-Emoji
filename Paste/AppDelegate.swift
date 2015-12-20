//
//  AppDelegate.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = UINavigationController(rootViewController: SearchViewController())
        return window
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.makeKeyAndVisible()
        return true
    }
}

