//
//  CardsTableViewCell.swift
//  MiDokter User
//
//  Created by Sethuram Vijayakumar on 23/11/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class CardsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCardNumber: UILabel!
    @IBOutlet weak var buttonSelected: UIButton!
    
    var selectedButton : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
