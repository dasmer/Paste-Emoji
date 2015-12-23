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

    var ID: String {
        // There will never be more that 1 emoji struct for a given character,
        // so we can use the character itself to represent the ID
        return character
    }

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


extension Emoji: Hashable {
    var hashValue: Int {
        return ID.hashValue
    }
}


func ==(lhs: Emoji, rhs: Emoji) -> Bool {
    return lhs.name == rhs.name
}
