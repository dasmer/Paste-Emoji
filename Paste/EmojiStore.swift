import SwiftUI
import Combine
import EmojiKit

class EmojiStore: BindableObject {

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

    var didChange = PassthroughSubject<EmojiStore, Never>()

    let fetcher = EmojiFetcher ()
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

    init() {
        results = recents
    }

    private func fetch(matching query: String) {
        fetcher.cancelFetches()
        fetcher.query(query) { [weak self] in
            self?.results = $0
        }
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
}
