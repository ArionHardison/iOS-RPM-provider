//
//  SuggestedCell.swift
//  MiDokter User
//
//  Created by AppleMac on 13/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class SuggestedCell : UITableViewCell{
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var priceLbl : UILabel!
    @IBOutlet weak var planDescription : UILabel!
    @IBOutlet weak var suggetionView: UIView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        self.selectionStyle = .none
    }
    
    
    func setupFont(){
//        Common.setFont(to: self.titleLbl, isTitle: true, size: 20)
//        Common.setFont(to: self.offerPriceLbl, isTitle: false, size: 15)
//        Common.setFont(to: self.priceLbl, isTitle: false, size: 18)
//        Common.setFont(to: self.allSplistLbl, isTitle: true, size: 20)
    }
}
