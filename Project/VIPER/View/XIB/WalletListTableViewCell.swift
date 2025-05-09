//
//  WalletListTableViewCell.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var labelTransactionId : UILabel!
    @IBOutlet private weak var labelDate : UILabel!
    @IBOutlet private weak var labelAmount : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WalletListTableViewCell  {
    
    private func setDesign() {
        Common.setFont(to: labelAmount, size : 12)
        Common.setFont(to: labelTransactionId, size : 12)
        Common.setFont(to: labelDate, size : 12)
    }
    
    func set(values : Payment_log) {
        
        self.set(date: values.created_at, amount: values.amount, tranId: values.transaction_id ?? values.transaction_code)
//        self.labelAmount.textColor = values.type?.color
        self.labelAmount.textColor = UIColor.appColor
        
    }
    
    
    private func set(date : String?, amount : Float?, tranId : String?) {
        if let dateObject = Formatter.shared.getDate(from: date, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss){
            self.labelDate.text = Formatter.shared.getString(from: dateObject, format: DateFormat.list.dd_MM_yyyy)
        }
        self.labelTransactionId.text = tranId
        self.labelAmount.text = "$ \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2) ?? "0")"
    }
}
