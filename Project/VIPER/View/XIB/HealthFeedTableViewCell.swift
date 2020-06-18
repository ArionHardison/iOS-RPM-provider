//
//  HealthFeedTableViewCell.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class HealthFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImage : UIImageView!
    @IBOutlet weak var articleTitle : UILabel!
    @IBOutlet weak var articleContent : UILabel!
    @IBOutlet weak var articledate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
