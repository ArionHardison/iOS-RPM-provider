//
//  CalendarTableViewCell.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTreatment: UILabel!
    @IBOutlet weak var buttonOptions: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
