//
//  SongStruct.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/6/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import Foundation
struct Song {
    var name: String?
    var id: String?
    var artist: String?
    var liked: Bool
    
    init(name: String?, songId: String?, artist: String?, liked: Bool?) {
        self.name = name
        self.id = songId
        self.artist = artist
        self.liked = liked ?? false
    }
}
