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
    
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var song: Song?
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
    
    func updatePlayImage() {
        if self.isPlaying {
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else {
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
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
    }
    
    
    func setDetails(song: Song?) {
        guard let song = song else {
            print ("EMPTY SONG RECIEVED")
            return
        }
        self.song = song
        songTitleLabel.text = song.name ?? "TITLE NOT FOUND"
    }
    
//    func showActivityIndicator() {
//        activityView = UIActivityIndicatorView(style: .whiteLarge)
//        activityView?.center = self.contentView.center
//        activityView?.startAnimating()
//        self.contentView.addSubview(activityView!)
//    }

}
