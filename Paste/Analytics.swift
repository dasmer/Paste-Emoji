//
//  Analytics.swift
//  Paste
//
//  Created by Dasmer Singh on 12/21/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import Foundation
import Mixpanel

struct Analytics {
   static let sharedInstance = Analytics()

    func start() {
        let token: String
        #if DEBUG
            token = Key.MixpanelDebug
        #else
            token = Key.MixpanelRelease
        #endif

        Mixpanel.sharedInstance(withToken: token)
    }

    func track(eventName: String, properties: [String: String]) {
        Mixpanel.sharedInstance().track(eventName, properties: properties)
        #if DEBUG
            print("Analytics Event Tracked ✒️\nName: \(eventName)\nProperties: \(properties))\n")
        #endif
    }
}
