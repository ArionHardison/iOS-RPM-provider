//
//  PatientTableViewCell.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPatientID: UILabel!
    @IBOutlet weak var labelPatientDetails: UILabel!
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
