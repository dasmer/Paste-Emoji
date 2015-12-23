//
//  Store.swift
//  Paste
//
//  Created by Dasmer Singh on 12/22/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import Foundation

let RecentEmojiStore = Store<Emoji>(dbFileName: "RecentEmojiStoreV1.txt", queueLabel: "com.dastronics.Paste.RecentEmojiStore")!

struct Store<T where T:DictionaryDeserializable, T:DictionarySerializable> {

    private let dbFilePath: String

    private let queue: dispatch_queue_t

    init?(dbFileName: String, queueLabel: String) {
        guard let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)).first else { return nil }
        dbFilePath = (documentsDirectory as NSString).stringByAppendingPathComponent(dbFileName)
        queue = dispatch_queue_create(queueLabel, DISPATCH_QUEUE_CONCURRENT)
    }

    func get() -> [T] {
        var items = [T]()
        dispatch_sync(queue) {
            guard let data = NSData(contentsOfFile: self.dbFilePath),
                objects = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                dictionaries = objects as? [JSONDictionary] else { return }
            items = dictionaries.flatMap { T(dictionary: $0) }
        }
        return items
    }

    func set(items: [T]) {

        dispatch_barrier_async(queue) { () -> Void in
            let dictionaries = items.map { $0.dictionary }
            guard let data = try? NSJSONSerialization.dataWithJSONObject(dictionaries, options: []) else { return }
            data.writeToFile(self.dbFilePath, atomically: true)
        }
    }
}
