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
        Mixpanel.sharedInstanceWithToken("")
    }

    func track(eventName: String, properties: [String: String]) {
        Mixpanel.sharedInstance().track(eventName, properties: properties)
    }
}
