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
    
    var spotifyDataObject = SpotifyDataObject()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    @IBAction func LogInPushed(_ sender: Any) {
        getAuthCode()
    }
    
    func getAuthCode() {
        let scope = "user-library-read%20user-library-modify"
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(Constants.clientID)&response_type=code&redirect_uri=\(Constants.redirectURI)&scope=\(scope)")!
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
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.absoluteString),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "client_secret", value: Constants.client_secret)
        ]
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("ERROR", error ?? "uhhh i dunno man")
                return
            }
            
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
//                print("response = \(response)")
                return
            }
            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                print(jsonResult!)
                let token = jsonResult?["access_token"] as! String
//                print(token)
                self.spotifyDataObject.accessToken = token
                self.getUser(accessToken: token)
            }
            catch let error as NSError {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    func getUser(accessToken: String) {
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "i cant help u with this one buddy")
                return
            }
            
            guard (200...299) ~= response.statusCode else { // not sure what ~= means?
                print("status code: \(response.statusCode)")
//                print("response for getUser = \(response)")
                
                return
            }
            
            do {
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//                print(jsonResult!)
                
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                self.spotifyDataObject.user = user
                print(self.spotifyDataObject)
                
                DispatchQueue.main.async { // i think?
                   self.performSegue(withIdentifier: "nextScene", sender: self.spotifyDataObject)
                }
            }
            catch let error as NSError {
                print("NSError: \(error.debugDescription)")
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! MainTabViewController).spotifyDataObject = (sender as! SpotifyDataObject)
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
