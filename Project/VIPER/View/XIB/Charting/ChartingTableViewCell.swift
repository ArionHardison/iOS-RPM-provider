//
//  ChartingTableViewCell.swift
//  Project
//
//  Created by Vinod Reddy Sure on 28/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class ChartingTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAppointmentString: UILabel!
    @IBOutlet weak var labelAppointmentDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
