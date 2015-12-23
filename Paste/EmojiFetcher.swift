//
//  Fetcher.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import Foundation

struct EmojiFetcher {

    // MARK: - Properties

    private let backgroundQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.qualityOfService = .UserInitiated
        return queue
    }()

    func query(searchString: String, completion: ([Emoji] -> Void)) {
        backgroundQueue.cancelAllOperations()

        let operation = EmojiFetchOperation(searchString: searchString)

        operation.completionBlock = {

            if operation.cancelled {
                return;
            }

            dispatch_async(dispatch_get_main_queue()) {
                completion(operation.results)
            }
        }

        backgroundQueue.addOperation(operation)
    }

}

private final class EmojiFetchOperation: NSOperation {

    static let allEmoji: [Emoji] = {
        guard let path = NSBundle(forClass: EmojiFetchOperation.self).pathForResource("AllEmoji", ofType: "json"),
            data = NSData(contentsOfFile: path),
            jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            jsonDictionaries = jsonObject as? [JSONDictionary] else { return [] }

        return jsonDictionaries.flatMap { Emoji(dictionary: $0) }
    }()


    // MARK: - Properties

    let searchString: String
    var results: [Emoji] = []


    // MARK: - Initializers

    init(searchString: String) {
        self.searchString = searchString
    }


    // MARK: - NSOperation

    override func main() {
        let lowercaseSearchString = self.searchString.lowercaseString

        guard !cancelled else { return }

        let results = self.dynamicType.allEmoji.filter { emoji in
            var validResult = emoji.name.hasPrefix(lowercaseSearchString)

            if !validResult {
                let emojiNameWords = emoji.name.characters.split{$0 == " "}.map(String.init)
                for emojiNameWord in emojiNameWords {
                    if (emojiNameWord == lowercaseSearchString) {
                        validResult = true
                        break
                    }
                }
            }

            if !validResult {
                for alias in emoji.aliases {
                    if alias.hasPrefix(lowercaseSearchString) {
                        validResult = true
                        break
                    }
                }
            }

            if !validResult {
                for group in emoji.groups {
                    if group == lowercaseSearchString {
                        validResult = true
                        break
                    }
                }
            }

            return validResult
        }

        guard !cancelled else { return }
        self.results = results
    }
}
