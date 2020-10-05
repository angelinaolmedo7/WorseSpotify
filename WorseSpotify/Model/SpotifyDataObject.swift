//
//  SpotifyDataObject.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/4/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import Foundation

struct SpotifyDataObject {
    
    var accessToken: String?
    var user: User?
//    let
    
    init() {
        self.accessToken = nil
        self.user = nil
    }
    
    init(_ accessToken: String?, _ user: User?) {
        self.accessToken = accessToken
        self.user = user
    }
    
}
