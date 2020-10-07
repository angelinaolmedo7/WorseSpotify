//
//  SongListOperation.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/6/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import Foundation

final class SongListOperation: AsyncOperation {
    
    var songList: [Song]?
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let accessToken: String
    
    init(accessToken: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
      self.accessToken = accessToken
      self.completion = completion
      super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/me/tracks")!
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
                print("error", error ?? "i cant help u with this one buddy")
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
                let trackDict = (song as! NSDictionary)["track"]!
                let songName = (trackDict as! NSDictionary)["name"]! as! String
                let songId = (trackDict as! NSDictionary)["id"]! as! String
//                print(trackDict as! NSDictionary)
                let previewURL = ((trackDict as! NSDictionary)["preview_url"]! as? String) ?? nil
                
                let albumDict = (trackDict as! NSDictionary)["album"]!
                let artistArr = (albumDict as! NSDictionary)["artists"]!
                let artistDict = (artistArr as! NSArray)[0]
                let artistName = (artistDict as! NSDictionary)["name"]! as! String
                
                let thisSong = Song(name: songName, songId: songId, previewURL: previewURL, artist: artistName, liked: nil)
                songArray.append(thisSong)
            }
            
            return songArray
        }
}

final class CheckLikeOperation: AsyncOperation {
    
    var liked: Bool?
    
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let songID: String
    let accessToken: String
    
    init(songID: String, accessToken: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.songID = songID
        self.accessToken = accessToken
        self.completion = completion
        super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/me/tracks/contains?ids=\(self.songID)")!
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
                print("error", error ?? "Unknown error: Could not check song")
                return
            }
                        
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
                return
            }
                    
            do {
                print(data)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                self.liked = jsonResult![0] as! Bool
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
}


final class RemoveLikeOperation: AsyncOperation {
    
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let songID: String
    let accessToken: String
    
    init(songID: String, accessToken: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.songID = songID
        self.accessToken = accessToken
        self.completion = completion
        super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/me/tracks?ids=\(self.songID)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
                
            if let completion = self.completion {  // should this be later?
                completion(data, response, error)
                return
            }
                
            guard let _ = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unknown error: Could not add song")
                return
            }
                        
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
                return
            }
                    
            do {
                print("Removed \(self.songID) from likes")
                // nothing (mood)
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
}

final class AddLikeOperation: AsyncOperation {
    
    private let completion: ((Data?, URLResponse?, Error?) -> Void)?
    let songID: String
    let accessToken: String
    
    init(songID: String, accessToken: String, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.songID = songID
        self.accessToken = accessToken
        self.completion = completion
        super.init()
    }
    
    override func main() {
        let url = URL(string: "https://api.spotify.com/v1/me/tracks?ids=\(self.songID)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.state = .finished }
                
            if let completion = self.completion {  // should this be later?
                completion(data, response, error)
                return
            }
                
            guard let _ = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unknown error: Could not add song")
                return
            }
                        
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
                return
            }
                    
            do {
                print("Added \(self.songID) to likes")
                // nothing (mood)
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
}
