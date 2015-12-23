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
        Mixpanel.sharedInstanceWithToken("547e5d6894da24ac5876599ffa3ebb12")
    }

    func track(eventName: String, properties: [String: String]) {
        Mixpanel.sharedInstance().track(eventName, properties: properties)
        #if DEBUG
            print("✒️ Event Tracked == Name:\(eventName) Properties:\(properties))")
        #endif
    }
}
