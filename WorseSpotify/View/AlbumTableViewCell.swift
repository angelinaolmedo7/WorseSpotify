//
//  AlbumTableViewCell.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/7/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var song: Song?
    var spotifyDataObject: SpotifyDataObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
