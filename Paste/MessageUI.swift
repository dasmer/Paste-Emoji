//
//  MessageUI.swift
//  Paste
//
//  Created by Dasmer Singh on 1/10/16.
//  Copyright © 2016 Dastronics Inc. All rights reserved.
//

import MessageUI

enum MessageUIKind: String {
    case Message
    case Mail
}

enum MessageUIFinishedResultKind: String {
    case Sent
    case Saved
    case Cancelled
    case Failed
    case Unknown

    init(messageComposeResult: MessageComposeResult) {
        switch messageComposeResult {
        case .sent: self = .Sent
        case .cancelled: self = .Cancelled
        case .failed: self = .Failed
        default: self = .Unknown
        }
    }

    init(mailComposeResult: MFMailComposeResult) {
        switch mailComposeResult {
        case .sent: self = .Sent
        case .saved: self = .Saved
        case .cancelled: self = .Cancelled
        case .failed: self = .Failed
        default: self = .Unknown
        }
    }
}
