//
//  TweetModel.swift
//  Tweets
//
//  Created by Anastasia Veremiichyk on 10/14/18.
//  Copyright © 2018 Anastasia Veremiichyk. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    
    let name : String
    let text : String
    let date : String
    
    var description: String {
        return "NAME: \(name): DATE: \(date) TEXT: \(text)"
    }
    
}
