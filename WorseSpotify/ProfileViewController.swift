//
//  ProfileViewController.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 10/5/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameLabel.text = (self.presentingViewController as! AuthViewController).spotifyDataObject.user?.display_name
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
