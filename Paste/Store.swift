//
//  Store.swift
//  Paste
//
//  Created by Dasmer Singh on 12/22/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import Foundation
import EmojiKit

let RecentEmojiStore = Store<Emoji>(dbFileName: "RecentEmojiStoreV1.txt", queueLabel: "com.dastronics.Paste.RecentEmojiStore")!

struct Store<T> where T:DictionaryDeserializable, T:DictionarySerializable {

    private let dbFilePath: String

    private let queue: DispatchQueue

    init?(dbFileName: String, queueLabel: String) {
        guard let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)).first else { return nil }
        dbFilePath = (documentsDirectory as NSString).appendingPathComponent(dbFileName)
        queue = DispatchQueue(label: queueLabel)
    }

    func get() -> [T] {
        var items = [T]()
        queue.sync {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: self.dbFilePath), options: .mappedIfSafe),
                let objects = try? JSONSerialization.jsonObject(with: data, options: []),
                let dictionaries = objects as? [JSONDictionary] else { return }
            items = dictionaries.compactMap { T(dictionary: $0) }
        }
        return items
    }

    func set(items: [T]) {

        queue.async { () -> Void in
            let dictionaries = items.map { $0.dictionary }
            guard let data = try? JSONSerialization.data(withJSONObject: dictionaries, options: []) else { return }
            try? data.write(to: URL(fileURLWithPath: self.dbFilePath), options: .atomic)
        }
    }
}
