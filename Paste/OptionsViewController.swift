//
//  OptionsViewController.swift
//  Paste
//
//  Created by Dasmer Singh on 1/10/16.
//  Copyright © 2016 Dastronics Inc. All rights reserved.
//

import UIKit
import MessageUI

class OptionsViewController: UITableViewController {

    // MARK: Enums

    private enum Options: Int {
        case Share
        case Rate
        case Feedback

        static var all: [Options] {
            return [.Share, .Rate, .Feedback]
        }

        var title: String {
            switch self {
            case .Share: return "Share with Friends"
            case .Rate: return "Rate on the App Store"
            case .Feedback: return "Send Feedback"
            }
        }

        var subtitle: String {
            switch self {
            case .Share: return "👯"
            case .Rate: return "⭐️"
            case .Feedback: return "📧"
            }
        }

        var analyticsTitle: String {
            switch self {
            case .Share: return "Share"
            case .Rate: return "Rate"
            case .Feedback: return "Feedback"
            }
        }

        var indexPath: NSIndexPath {
            return NSIndexPath(forRow: self.rawValue, inSection: 0)
        }
    }


    // MARK: Initializers

    init() {
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: UIViewController

    override func viewDidLoad() {
        title = "Options"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismissButtonAction:")
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    }


    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.all.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.reuseIdentifier, forIndexPath: indexPath)
        let option = Options(rawValue: indexPath.row)
        cell.textLabel?.text = option?.title
        cell.detailTextLabel?.text = option?.subtitle
        return cell
    }


    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let option = Options(rawValue: indexPath.row) else {
            return
        }

        switch option {
        case .Share: shareAction()
        case .Rate: rateAction()
        case .Feedback: feedbackAction()
        }

        Analytics.sharedInstance.track("Options View Cell Selected", properties: ["Type": option.analyticsTitle])
    }


    // MARK: Private Functions

    @objc private func dismissButtonAction(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func shareAction() {
        let messageBody = "Download Paste, an app that lets you find emoji faster than ever: bit.ly/usepaste"
        if MFMessageComposeViewController.canSendText() {
            let viewController = MFMessageComposeViewController()
            viewController.messageComposeDelegate = self
            viewController.body = messageBody
            presentViewController(viewController, animated: true, completion: nil)
        } else {
            tableView.deselectRowAtIndexPath(Options.Share.indexPath, animated: true)
            let activityController = UIActivityViewController(activityItems: [messageBody], applicationActivities: nil)
            presentViewController(activityController, animated: true, completion: nil)
        }
    }

    private func rateAction() {
        guard let url = NSURL(string: "https://itunes.apple.com/app/paste-emoji-search/id1070640289") else { return }
        UIApplication.sharedApplication().openURL(url)

        tableView.deselectRowAtIndexPath(Options.Rate.indexPath, animated: false)
    }

    private func feedbackAction() {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients(["usepaste@gmail.com"])
            viewController.setSubject("[Paste Feedback]")
            presentViewController(viewController, animated: true, completion: nil)
        } else {
            tableView.deselectRowAtIndexPath(Options.Feedback.indexPath, animated: true)
            let alertController = UIAlertController(title: "Send Feedback", message: "Email us at usepaste@gmail.com", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    private func logMessageUIComposeFinished(composeKind composeKind: MessageUIKind, resultKind: MessageUIFinishedResultKind) {
        let properties: [String: String] = [
            "Type": composeKind.rawValue,
            "Result": resultKind.rawValue,
            "Source": "Options View"
        ]
        Analytics.sharedInstance.track("MessageUI Compose Finished", properties: properties)
    }
}


extension OptionsViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)

        logMessageUIComposeFinished(composeKind: MessageUIKind.Mail, resultKind: MessageUIFinishedResultKind(messageComposeResult: result))
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)

        logMessageUIComposeFinished(composeKind: MessageUIKind.Mail, resultKind: MessageUIFinishedResultKind(mailComposeResult: result))
    }
}
