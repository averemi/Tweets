//
//  APIController.swift
//  Tweets
//
//  Created by Anastasia Veremiichyk on 10/14/18.
//  Copyright © 2018 Anastasia Veremiichyk. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    func processTweets (tweets : [Tweet])
    func processErrors (error : Error)
}

class APIController {
    
    let SEARCH_URL = "https://api.twitter.com/1.1/search/tweets.json"
    
    weak var delegate : APITwitterDelegate?
    
    let token : String
    
    var tweets : [Tweet] = []
    
    init(delegate : APITwitterDelegate?, token : String) {
        self.token = token
        self.delegate = delegate
    }
    
    func searchTweets(keyword : String) {
        
        guard let keywordEncoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "\(SEARCH_URL)?lang=en&count=100&q=\(keywordEncoded)") else { return }
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            print("RESPONSE: \(String(describing: response))")
            if let err = error {
                print("ERROR: \(err)")
            }
            else if let d = data {
                print("DATA: \(d)")
                do {
                  //      if let result = try JSONDecoder().decode([String : String]?.self, from: d) {
                    //        print("JSON DECODED: \(result)")
                        //    self.delegate?.processTweets(tweet: )
                      //  } // <- this is option 1 of converting the data
                    if let resp : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print("JSON DECODED: \(resp)")
                     //       tweets =
                        
                        
                    } // <- this is option 2 of converting the data
                }
                catch (let err) {
                    print("ERROR: \(err)")
                    self.delegate?.processErrors(error: err)
                }
            }
            
        }
        task.resume()

        
    }
}

/*
 if let tweetsD: [NSDictionary] = resp["statuses"] as? [NSDictionary] {
 for tweet in tweetsD {
 if let name = tweet["user"]?["name"] as? String {
 if let text = tweet["text"] as? String {
 if let date = tweet["created_at"] as? String {
 let dateFormatter = NSDateFormatter()
 dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
 if let date = dateFormatter.dateFromString(date) {
 dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
 let newDate = dateFormatter.stringFromDate(date)
 tweets.append(Tweet(name: name, text: text, date: newDate))
 }
 }
 }
 }
 */

