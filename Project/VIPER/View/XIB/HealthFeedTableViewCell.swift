//
//  HealthFeedTableViewCell.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class HealthFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ArticleImage : UIImageView!
    @IBOutlet weak var ArticleTitle : UILabel!
    @IBOutlet weak var Articlecontent : UILabel!
    @IBOutlet weak var publishedDate : UILabel!
    @IBOutlet weak var shadowView : UIView!
    @IBOutlet weak var bgView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowView.addShadow(color: .lightGray, opacity: 0.4, offset: CGSize(width: 1.0,height: 1.0), radius: 2, rasterize: false, maskToBounds: false)
        self.bgView.cornerRadius = 10.0
    }
}
