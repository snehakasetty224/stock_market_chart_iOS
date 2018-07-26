//
//  StockTableViewCell.swift
//  
//
//  Created by Sneha Kasetty Sudarshan on 7/22/18.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var symbolTitle: UILabel!
    
    @IBOutlet weak var symbolName: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var changePercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
