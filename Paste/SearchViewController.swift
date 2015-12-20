//
//  ViewController.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let searchTextView: SearchTextView = {
        let view = SearchTextView()
        view.backgroundColor = .greenColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let tableViewController: UITableViewController = {
        let viewController = UITableViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Emoji Search"

        view.addSubview(searchTextView)

        addChildViewController(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMoveToParentViewController(self)

        let views: [String: AnyObject] = [
            "searchView": searchTextView,
            "tableView": tableViewController.view,
            "topLayoutGuide": topLayoutGuide
        ]

        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][searchView(44)][tableView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)

        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .blueColor()
        return cell
    }


}


extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIPasteboard.generalPasteboard().string = "😀"
    }
}
