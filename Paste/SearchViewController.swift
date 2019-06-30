//
//  SearchViewController
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import EmojiKit

final class SearchViewController: UIViewController {

    // MARK: - Properties

    private var results: [Emoji] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var recents: [Emoji] {
        set {
            RecentEmojiStore.set(items: newValue)
        }

        get {
            return RecentEmojiStore.get()
        }
    }

    private lazy var searchTextFieldView: SearchTextFieldView = {
        let view = SearchTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Type an emoji name to search"
        view.backgroundColor = .white
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
        tableViewController.tableView.contentInsetAdjustmentBehavior = .automatic

        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(optionsButtonAction(sender:)))

        view.backgroundColor = .white

        view.addSubview(searchTextFieldView)

        let separatorView = UIView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray
        view.addSubview(separatorView)

        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        searchTextFieldView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchTextFieldView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        separatorView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        searchTextFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchTextFieldView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        separatorView.topAnchor.constraint(equalTo: searchTextFieldView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)

        reset()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let _ = searchTextFieldView.becomeFirstResponder()
    }


    // MARK: - Private

    func reset() {
        fetcher.cancelFetches()
        results = recents
    }

    @objc private func optionsButtonAction(sender: AnyObject?) {
        present(UINavigationController(rootViewController: OptionsViewController()), animated: true, completion: nil)
    }
}


extension SearchViewController: SearchTextFieldViewDelegate {

    func searchTextFieldView(searchTextFieldView: SearchTextFieldView, didChangeText text: String) {
        if (text.count > 0) {
            fetcher.query(text) { [weak self] in
                self?.results = $0
            }
        } else {
            reset()
        }
    }

    func searchTextFieldViewWillClearText(searchTextFieldView: SearchTextFieldView) {
        reset()
    }
}


extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        let emoji = self.results[indexPath.row]
        cell.textLabel?.text = emoji.character
        cell.detailTextLabel?.text = emoji.name
        return cell
    }
}


extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let emoji = self.results[indexPath.row]

        UIPasteboard.general.string = emoji.character

        SVProgressHUD.showSuccess(withStatus: "Copied \(emoji.character)")

        let properties = [
            "Emoji Character": emoji.character,
            "Search Text": searchTextFieldView.text ?? "",
            "Search Text Count": String(searchTextFieldView.text?.count ?? 0)
        ]
        Analytics.sharedInstance.track(eventName: "Emoji Selected", properties: properties)

        RateReminder.sharedInstance.logEvent()

        var currentRecents = recents
        if let index = currentRecents.firstIndex(of: emoji) {
            currentRecents.remove(at: index)
        }
        currentRecents.insert(emoji, at: 0)

        recents = Array(currentRecents.prefix(10))

        self.searchTextFieldView.text = nil
        reset()
    }
}
