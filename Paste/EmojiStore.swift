//
//  SearchView.swift
//  Paste
//
//  Created by Dasmer Singh on 7/2/19.
//  Copyright © 2019 Dastronics Inc. All rights reserved.
//
import SwiftUI
import Combine
import EmojiKit

class EmojiStore: BindableObject {

    // MARK: - Properties

    var didChange = PassthroughSubject<EmojiStore, Never>()

    var results: [Emoji] = [] {
        didSet {
            didChange.send(self)
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

    private let fetcher = EmojiFetcher ()

    var searchText: String = "" {
        didSet {
            fetcher.cancelFetches()
            if searchText.count == 0 {
                results = recents
            } else {
                results = []
                fetch(matching: searchText)
            }
        }
    }


    // MARK: - Functions

    init() {
        results = recents
    }

    func didTap(emoji: Emoji) {
        let properties = [
            "Emoji Character": emoji.character,
            "Search Text": searchText,
            "Search Text Count": String(searchText.count)
        ]
        Analytics.sharedInstance.track(eventName: "Emoji Selected", properties: properties)
        RateReminder.sharedInstance.logEvent()

        var currentRecents = recents
        if let index = currentRecents.firstIndex(of: emoji) {
            currentRecents.remove(at: index)
        }

        currentRecents.insert(emoji, at: 0)
        recents = Array(currentRecents.prefix(10))
        searchText = ""
    }


    // MARK: - Private Functions

    private func fetch(matching query: String) {
        fetcher.cancelFetches()
        fetcher.query(query) { [weak self] in
            self?.results = $0
        }
    }
}
