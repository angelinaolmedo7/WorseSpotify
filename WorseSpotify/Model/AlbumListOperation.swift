//
//  AlbumListOperation.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/7/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import Foundation

final class AlbumListOperation: AsyncOperation {
    
    var albumList: [Album]?
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let accessToken: String
    
    init(accessToken: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
      self.accessToken = accessToken
      self.completion = completion
      super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/browse/new-releases")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
                
            if let completion = self.completion {  // should this be later?
                completion(data, response, error)
                return
            }
                
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Could not retrieve albums")
                return
            }
                        
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
                return
            }
                    
            do {
                print(data)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                self.albumList = self.createAlbumArray(jsonResult)
//                print(self.createAlbumArray(jsonResult))
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
        
    func createAlbumArray(_ NSDict: NSDictionary?) -> [Album] {
        guard let NSDict = NSDict else {
            print("Could not retrieve NSDictionary.")
            return []
        }
        
        print(NSDict)
        
        let NSAlbumsDict = NSDict["albums"] as? NSDictionary
        guard let _ = NSAlbumsDict else {
            print("Could not retrieve NSAlbumsDict.")
            return []
        }
        let NSAlbumArray = NSAlbumsDict!["items"] as? NSArray
        guard let _ = NSAlbumArray else {
            print("Could not retrieve NSAlbumArray.")
            return []
        }
        
        var albumArray: [Album] = []
        
        for album in NSAlbumArray! {
            let artistArr = (album as! NSDictionary)["artists"]!
            let artistDict = (artistArr as! NSArray)[0]
            let artistName = (artistDict as! NSDictionary)["name"]! as! String
            
            let albumId = (album as! NSDictionary)["id"]! as! String
            let albumTitle = (album as! NSDictionary)["name"]! as! String
            
            let thisAlbum = Album(name: albumTitle, albumId: albumId, artist: artistName)
            albumArray.append(thisAlbum)
        }
        
        return albumArray
    }
}

final class GetAlbumSongsOperation: AsyncOperation {
    
    var songList: [Song]?
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let albumId: String
    let accessToken: String
    
    init(accessToken: String, albumId: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.accessToken = accessToken
        self.albumId = albumId
        self.completion = completion
        super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)/tracks")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
                
            if let completion = self.completion {  // should this be later?
                completion(data, response, error)
                return
            }
                
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Could not retrieve album details")
                return
            }
                        
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
                return
            }
                    
            do {
                print(data)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                self.songList = self.createSongArray(jsonResult)
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
        
        func createSongArray(_ NSDict: NSDictionary?) -> [Song] {
            guard let NSDict = NSDict else {
                print("Could not retrieve NSDictionary.")
                return []
            }
            
            let NSSongArray = NSDict["items"] as? NSArray
            guard let _ = NSSongArray else {
                print("Could not retrieve NSSongArray.")
                return []
            }
            
            var songArray: [Song] = []
            
            print(NSSongArray![0])
            
            for song in NSSongArray! {
                print(song)
                let trackDict = (song as! NSDictionary)
                let songName = (trackDict)["name"]! as! String
                let songId = (trackDict)["id"]! as! String
//                print(trackDict as! NSDictionary)
                let previewURL = ((trackDict)["preview_url"]! as? String) ?? nil
                
                let artistArr = (trackDict)["artists"]!
                let artistDict = (artistArr as! NSArray)[0]
                let artistName = (artistDict as! NSDictionary)["name"]! as! String
                
                let thisSong = Song(name: songName, songId: songId, previewURL: previewURL, artist: artistName, liked: nil)
                songArray.append(thisSong)
            }
            
            return songArray
        }
}
