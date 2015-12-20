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

func ==(lhs: Emoji, rhs: Emoji) -> Bool {
    return lhs.name == rhs.name
}
