//
//  Emoji.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

struct Emoji: Equatable {
    let name: String
    let character: String

    init(name: String, character: String) {
        self.name = name
        self.character = character
    }
}


extension Emoji: DictionaryDeserializable, DictionarySerializable {

    init?(dictionary: JSONDictionary) {
        guard let name = dictionary["name"] as? String,
            character = dictionary["character"] as? String else { return nil }

        self.name = name
        self.character = character
    }

    var dictionary: JSONDictionary {
        return [
            "name": name,
            "character": character
        ]
    }
}


func ==(lhs: Emoji, rhs: Emoji) -> Bool {
    return lhs.name == rhs.name
}
