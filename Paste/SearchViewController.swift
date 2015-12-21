//
//  ViewController.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SearchViewController: UIViewController {

    // MARK: - Properties

    private var results: [Emoji] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var searchView: SearchView = {
        let view = SearchView()
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var tableViewController: UITableViewController = {
        let viewController = UITableViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.tableView.dataSource = self
        viewController.tableView.delegate = self
        return viewController
    }()

    private lazy var fetcher: EmojiFetcher = {
        return EmojiFetcher()
    }()

    private var tableView: UITableView {
        return tableViewController.tableView
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Emoji Search"

        view.backgroundColor = .whiteColor()

        view.addSubview(searchView)

        let separatorView = UIView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .grayColor()
        view.addSubview(separatorView)

        addChildViewController(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMoveToParentViewController(self)

        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "searchView": searchView,
            "separatorView": separatorView,
            "tableView": tableViewController.view
        ]

        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchView]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][searchView(50)][separatorView(1)][tableView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)

        searchView.becomeFirstResponder()
    }
}


extension SearchViewController: SearchViewDelegate {

    func searchView(searchView: SearchView, didChangeText text: String) {
        fetcher.query(text) { [weak self] in
            self?.results = $0
        }
    }
}


extension SearchViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "")
        let emoji = self.results[indexPath.row]
        cell.textLabel?.text = emoji.character
        cell.detailTextLabel?.text = emoji.name
        return cell
    }
}


extension SearchViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        guard let cell = tableView.cellForRowAtIndexPath(indexPath),
            text = cell.textLabel?.text else { return }

        UIPasteboard.generalPasteboard().string = text
        SVProgressHUD.showSuccessWithStatus("Copied \(text)")
    }
}
