//
//  InvoiceView.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 07/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class InvoiceView: UIView {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var specialityFeesLabel : UILabel!
    @IBOutlet weak var categoryFeesLabel : UILabel!
    @IBOutlet weak var discountLabel : UILabel!
    @IBOutlet weak var grossFessLabel : UILabel!
    @IBOutlet weak var totalFeesLabel : UILabel!
    @IBOutlet weak var specialityFeesValueLabel : UILabel!
    @IBOutlet weak var categoryFeesValueLabel : UILabel!
    @IBOutlet weak var discountValueLabel : UILabel!
    @IBOutlet weak var grossValueLabel : UILabel!
    @IBOutlet weak var totalValueLabel : UILabel!
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var discountView : UIView!
    
    

    var onClickDone : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initalLoads()
    }

}


extension InvoiceView {
    
    private func initalLoads(){
        self.setDesigns()
        
    }
    
    private func setDesigns(){
        Common.setFontWithType(to: titleLabel, size: 17, type: .semiBold)
        Common.setFontWithType(to: specialityFeesLabel, size: 14, type: .light)
        Common.setFontWithType(to: categoryFeesLabel, size: 14, type: .light)
        Common.setFontWithType(to: discountLabel, size: 14, type: .light)
        Common.setFontWithType(to: grossFessLabel, size: 14, type: .light)
        Common.setFontWithType(to: totalFeesLabel, size: 14, type: .light)
        Common.setFontWithType(to: specialityFeesValueLabel, size: 14, type: .meduim)
        Common.setFontWithType(to: categoryFeesValueLabel, size: 14, type: .meduim)
        Common.setFontWithType(to: discountValueLabel, size: 14, type: .meduim)
        Common.setFontWithType(to: grossValueLabel, size: 14, type: .meduim)
        Common.setFontWithType(to: totalValueLabel, size: 14, type: .meduim)
        Common.setFontWithType(to: doneButton, size: 14, type: .meduim)
        self.doneButton.addTarget(self, action: #selector(doneAction(sender:)), for: .touchUpInside)
        
    }
    
    func populateData(invoice:Invoice?){
        self.specialityFeesValueLabel.text = curreny + "\(invoice?.speciality_fees ?? 0)"
        self.categoryFeesValueLabel.text = curreny + "\(invoice?.consulting_fees ?? 0)"
        if invoice?.discount == 0{
            self.discountView.isHidden = true
        }else{
        self.discountValueLabel.text =  curreny + "\(invoice?.discount ?? 0)"
            self.discountView.isHidden = false
        }
        self.grossValueLabel.text =  curreny + "\(invoice?.gross ?? 0)"
        self.totalValueLabel.text = curreny + "\(invoice?.total_pay ?? 0)"
    }
    
    @IBAction private func doneAction(sender:UIButton){
        self.onClickDone?()
    }
    
}
