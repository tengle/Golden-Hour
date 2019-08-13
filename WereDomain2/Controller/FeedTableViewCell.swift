//
//  FeedTableViewCell.swift
//  WereDomain2
//
//  Created by Tyler Engle on 2/2/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var specialTimeLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var specialDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
