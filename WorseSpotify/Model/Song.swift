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
    var previewURL: String?
    var artist: String?
    var liked: Bool
    
    init(name: String?, songId: String?, previewURL: String?, artist: String?, liked: Bool?) {
        self.name = name
        self.id = songId
        self.previewURL = previewURL
        self.artist = artist
        self.liked = liked ?? false
    }
}


