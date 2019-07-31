//
//  AppDelegate.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        RateReminder.sharedInstance.start()
        Analytics.sharedInstance.start()
        UINavigationBar.appearance().tintColor = UIColor(red: 0, green: 188.0/255.0, blue: 242.0/255.0, alpha: 1.0)


        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: SearchView().environmentObject(EmojiStore()))
        window.makeKeyAndVisible()

        Analytics.sharedInstance.track(eventName: "Application Opened", properties: ["Type": "Launch"])

        self.window = window

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Analytics.sharedInstance.track(eventName: "Application Opened", properties: ["Type": "From Background"])
    }
}
