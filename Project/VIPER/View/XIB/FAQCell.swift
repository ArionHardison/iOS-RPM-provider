//
//  FAQCell.swift
//  MiDokter User
//
//  Created by Basha's MacBook Pro on 19/11/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var radioImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        // Configure the view for the selected state
    }
    
}
