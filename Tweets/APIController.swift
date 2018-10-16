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
            if let err = error {
                self.delegate?.processErrors(error: err)
            }
            else if let d = data {
                do {
                  /*    if let result = try JSONDecoder().decode([String : String]?.self, from: d) {
                            print("JSON DECODED: \(result)")
                        } // <- this is option 1 of converting the data*/
                    if let resp : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let statuses = resp["statuses"] as? [[String : AnyObject]] {
                            for dictArray in statuses {
                                
                                if let text = dictArray["text"] as? String, let userName = dictArray["user"]?["name"] as? String, let dateString = dictArray["created_at"] as? String {
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                    if let date = dateFormatter.date(from: dateString) {
                                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                        let newDateString = dateFormatter.string(from: date)
                                        
                                        self.tweets.append(Tweet(name: userName, text: text, date: newDateString))
                                    }
                                }
                            }
                            
                            self.delegate?.processTweets(tweets: self.tweets)
                            
                        }
                    } // <- this is option 2 of converting the data
                }
                catch (let err) {
                    self.delegate?.processErrors(error: err)
                }
            }
            
        }
        task.resume()

        
    }
}
