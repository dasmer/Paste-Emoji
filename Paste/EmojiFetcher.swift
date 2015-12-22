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
            jsonDictionary = jsonObject as? [String: String] else { return [] }

        return jsonDictionary.map { Emoji(name: $0.0, character: $0.1) }
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
            var validResult = false
            let characters = emoji.name.characters.split{$0 == " "}.map(String.init)
            for character in characters {
                if (character.hasPrefix(lowercaseSearchString)) {
                    validResult = true
                    break
                }
            }
            return validResult
        }

        guard !cancelled else { return }
        self.results = results
    }
}
