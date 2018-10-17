//
//  ViewController.swift
//  Tweets
//
//  Created by Anastasia Veremiichyk on 10/11/18.
//  Copyright © 2018 Anastasia Veremiichyk. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, APITwitterDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var tweetz : [Tweet] = []
    var token : String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        makeRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func requestTweets(keyword: String) {
        if let token = self.token {
            let ap = APIController(delegate: self, token: token)
            ap.searchTweets(keyword: keyword)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            if let keyword = searchBar.text {
                requestTweets(keyword: keyword)
            }
            searchBar.endEditing(false)
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(false)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetz.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        cell.nameLabel?.text = tweetz[indexPath.row].name
        cell.tweetLabel?.text = tweetz[indexPath.row].text
        cell.dateLabel?.text = tweetz[indexPath.row].date
        cell.nameLabel?.numberOfLines = 0
        cell.tweetLabel?.numberOfLines = 0
        cell.dateLabel?.numberOfLines = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func processErrors(error: Error) {
        let myAlert = UIAlertController(title: "Alert", message: "Error loading the data occured.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        return
    }
    
    
    func processTweets(tweets: [Tweet]) {
        if !tweets.isEmpty {
            self.tweetz = tweets
            DispatchQueue.main.async {
                for tweet in self.tweetz {
                    print(tweet)
                }
                self.tableView.reloadData()
           
            }
        }
    }


    func makeRequest() {
        
        let CUSTOMER_KEY = "pUPct2WIOVclC5Pu7kNuAKfao"
        let CUSTOMER_SECRET = "XVrGktkgY4MbZEZN13QP6lrnTqbBcjlhmMbLAmtHty8I3AdPFN"
        let TOKEN_URL = "https://api.twitter.com/oauth2/token"
        var BEARER: String? {
            guard let data = "\(CUSTOMER_KEY):\(CUSTOMER_SECRET)".data(using: .utf8) else { return nil }
            let base64 =  data.base64EncodedData(options: Data.Base64EncodingOptions(rawValue: 0))
            return String(data: base64, encoding: .utf8)
        }
        
        guard let bearer = BEARER else { return }
        guard let url = URL(string: TOKEN_URL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
            
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
                if let err = error {
                    self.processErrors(error: err)
                }
                else if let d = data {
                    do {
                    //    if let result = try JSONDecoder().decode([String : String]?.self, from: d) {
                    //        print("JSON DECODED: \(result)")
                    //    } // <- this is option 1 of converting the data
                        if let dict : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                          //  print("JSON DECODED: \(dict)")
                            if let token = dict["access_token"] as? String {
                                self.token = token
                            }
                        } // <- this is option 2 of converting the data
                    }
                    catch (let err) {
                        self.processErrors(error: err)
                    }
                }
            
        }
        task.resume()

    }

}
