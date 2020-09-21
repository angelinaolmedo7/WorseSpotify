//
//  AuthViewController.swift
//  WorseSpotify
//
//  Created by Angelina Olmedo on 9/21/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import UIKit
import AuthenticationServices
//import CryptoKit // do i need this?

class AuthViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAuthCode()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    func getAuthCode() {
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(Constants.clientID)&response_type=code&redirect_uri=\(Constants.redirectURI)")!
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "auth") { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else{return}
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let requestToken = queryItems?.first(where: {$0.name == "code"})?.value else {return}
            print("hey bitch take a code: \(requestToken)")
            self.startSession(code: requestToken)
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    func startSession(code: String) {
        
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
