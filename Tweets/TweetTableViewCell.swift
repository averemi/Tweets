//
//  TweetTableViewCell.swift
//  Tweets
//
//  Created by Anastasia Veremiichyk on 10/16/18.
//  Copyright © 2018 Anastasia Veremiichyk. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
