//
//  NewsTableViewCell.swift
//  ViewGlassAssignment
//
//  Created by Sneha Kasetty Sudarshan on 7/23/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headLine: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
