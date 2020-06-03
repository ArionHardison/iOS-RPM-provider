//
//  FeedBackTableViewCell.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class FeedBackTableViewCell: UITableViewCell {

    @IBOutlet weak var satusImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelVisitedFor: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
