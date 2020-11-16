//
//  CountryListCell.swift
//  User
//
//  Created by Developer Appoets on 06/08/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell {

    
    @IBOutlet weak var codeLbl:UILabel!
    @IBOutlet weak var countryNameLbl:UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
