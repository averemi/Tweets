//
//  ViewController.swift
//  Tweets
//
//  Created by Anastasia Veremiichyk on 10/11/18.
//  Copyright © 2018 Anastasia Veremiichyk. All rights reserved.
//

import UIKit
import Foundation



class ViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
        // Do any additional setup after loading the view, typically from a nib.
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
            print("RESPONSE: \(String(describing: response))")
                if let err = error {
                    print("ERROR: \(err)")
                }
                else if let d = data {
                    print("DATA: \(d)")
                    do {
                    //    if let result = try JSONDecoder().decode([String : String]?.self, from: d) {
                    //        print("JSON DECODED: \(result)")
                    //    } // <- this is option 1 of converting the data
                        if let dict : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print("JSON DECODED: \(dict)")
                            } // <- this is option 2 of converting the data
                    }
                    catch (let err) {
                        print("ERROR: \(err)")
                    }
                }
            
        }
        task.resume()

    }
    
}


