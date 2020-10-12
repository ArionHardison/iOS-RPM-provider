//
//  ChatRightCell.swift
//  MiDokter User
//
//  Created by AppleMac on 13/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class ChatRightCell: UITableViewCell {
    
    @IBOutlet weak var msgLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var tickImage : UIImageView!
    @IBOutlet weak var msgBGView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.tickImage.isHidden = true
        msgBGView.setCorneredElevation(shadow: 1, corner: 10, color: UIColor.clear)
        Common.setFont(to: self.msgLbl, isTitle: false, size: 16)
        Common.setFont(to: self.timeLbl, isTitle: false, size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


class ChatLeftCell: UITableViewCell {
    
    @IBOutlet weak var msgLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var msgBGView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        msgBGView.setCorneredElevation(shadow: 1, corner: 10, color: UIColor.clear)
        Common.setFont(to: self.msgLbl, isTitle: false, size: 16)
        Common.setFont(to: self.timeLbl, isTitle: false, size: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
