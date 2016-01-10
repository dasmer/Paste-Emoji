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
        case MessageComposeResultSent: self = .Sent
        case MessageComposeResultCancelled: self = .Cancelled
        case MessageComposeResultFailed: self = .Failed
        default: self = .Unknown
        }
    }

    init(mailComposeResult: MFMailComposeResult) {
        switch mailComposeResult {
        case MFMailComposeResultSent: self = .Sent
        case MFMailComposeResultSaved: self = .Saved
        case MFMailComposeResultCancelled: self = .Cancelled
        case MFMailComposeResultFailed: self = .Failed
        default: self = .Unknown
        }
    }
}
