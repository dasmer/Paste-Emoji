//
//  Rate.swift
//  Paste
//
//  Created by dasmer on 12/28/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import Foundation
import iRate

struct RateReminder {
    static let sharedInstance = RateReminder()

    func start() {
        iRate.sharedInstance().daysUntilPrompt = 5
        iRate.sharedInstance().eventsUntilPrompt = 3
    }

    func logEvent() {
        iRate.sharedInstance().logEvent(false)
    }
}
