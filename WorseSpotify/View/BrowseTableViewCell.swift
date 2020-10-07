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

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var song: Song?
    
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
    @IBAction func playButtonPressed(_ sender: Any) {
        
        print("Attempting to play song")
        let url  = URL.init(string: song?.previewURL ?? "ERROR")
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        self.contentView.layer.addSublayer(playerLayer!)
        
//        self.view.layer.addSublayer(playerLayer)
        player!.play()
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
