//
//  CoinCell.swift
//  API_Presenter
//
//  Created by Daniel Kawalsky on 8/4/18.
//  Copyright © 2018 Daniel Kawalsky. All rights reserved.
//

import UIKit

class CoinCell : UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
