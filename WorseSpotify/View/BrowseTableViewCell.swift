//
//  TableViewCell.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/7/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class BrowseTableViewCell: UITableViewCell {
    
    let queue = OperationQueue()  // i probably shouldnt be making this many of theese but oh well
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var song: Song?
    var spotifyDataObject: SpotifyDataObject?
    var isPlaying: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    var isLoading: Bool{
//        get{return activityView.isAnimating}
//        set{
//            if newValue{
//                activityView.startAnimating()
//            }else{
//                activityView.stopAnimating()
//            }
//        }
//    }
    
    func setDetails(song: Song?, spotifyData: SpotifyDataObject?) {
        guard let song = song else {
            print ("EMPTY SONG RECIEVED")
            return
        }
        guard spotifyData != nil else {
            print ("EMPTY USER RECIEVED")
            return
        }
        self.song = song
        self.spotifyDataObject = spotifyData
        self.songTitleLabel.text = song.name ?? "TITLE NOT FOUND"
        self.checkLiked()
        
    }
    
    func updatePlayImage() {
        if self.isPlaying {
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else {
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    
    func updateLikedImage() {
        if self.song?.liked ?? false {  // is liked
            self.likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else {
            self.likeButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func unlikeSong() {
        // IMPORTANT performs action in spotify
        guard song != nil else {
            print ("EMPTY SONG RECIEVED")
            return
        }
        guard spotifyDataObject != nil else {
            print ("EMPTY USER RECIEVED")
            return
        }
        
        let op = RemoveLikeOperation(songID: self.song!.id!, accessToken: self.spotifyDataObject!.accessToken!)
        op.completionBlock = {
          DispatchQueue.main.async {
            self.song!.liked = false
            self.updateLikedImage()
          }
        }
        queue.addOperation(op)
    }
    
    func checkLiked() {
        guard song != nil else {
            print ("EMPTY SONG RECIEVED")
            return
        }
        guard spotifyDataObject != nil else {
            print ("EMPTY USER RECIEVED")
            return
        }
            
        let op = CheckLikeOperation(songID: self.song!.id!, accessToken: self.spotifyDataObject!.accessToken!)
        op.completionBlock = {
            DispatchQueue.main.async {
                self.song!.liked = op.liked ?? false
                self.updateLikedImage()
            }
        }
        queue.addOperation(op)
    }
    
    func likeSong() {
        // IMPORTANT performs action in spotify
        guard song != nil else {
            print ("EMPTY SONG RECIEVED")
            return
        }
        guard spotifyDataObject != nil else {
            print ("EMPTY USER RECIEVED")
            return
        }
        
        let op = AddLikeOperation(songID: self.song!.id!, accessToken: self.spotifyDataObject!.accessToken!)
        op.completionBlock = {
          DispatchQueue.main.async {
            self.song!.liked = true
            self.updateLikedImage()
          }
        }
        queue.addOperation(op)
    }

    @IBAction func playButtonPressed(_ sender: Any) {
        
        if self.isPlaying {  // already playing
            self.isPlaying = false
            player!.pause()
            self.updatePlayImage()
            return
        }
        
        if self.player == nil {  // change to guard?
            let url  = URL.init(string: song?.previewURL ?? "ERROR")
            
            let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            
            self.contentView.layer.addSublayer(playerLayer!)
        }
        
//        self.view.layer.addSublayer(playerLayer)
        self.isPlaying = true
        player!.play()
        self.updatePlayImage()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if self.song!.liked {
           self.unlikeSong()
        }
        else {
            self.likeSong()
        }
        
    }
    
//    func showActivityIndicator() {
//        activityView = UIActivityIndicatorView(style: .whiteLarge)
//        activityView?.center = self.contentView.center
//        activityView?.startAnimating()
//        self.contentView.addSubview(activityView!)
//    }

}
