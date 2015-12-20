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

            completion(operation.results)
        }

        backgroundQueue.addOperation(operation)
    }

}

private final class EmojiFetchOperation: NSOperation {

    static let allEmoji = [Emoji]()


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

        let results = self.dynamicType.allEmoji.filter {
            $0.name.hasPrefix(lowercaseSearchString)
        }

        guard !cancelled else { return }
        self.results = results
    }
}
