//
//  ChatListTableViewCell.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
