//
//  NotifyVView.swift
//  Project
//
//  Created by Vinod Reddy Sure on 29/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit


class NotifyView: UIView {
    @IBOutlet weak var buttonDiscard: UIButton!
    @IBOutlet weak var buttonNotify: UIButton!
    @IBOutlet weak var buttonSMSNotifyPatient: UIButton!
    @IBOutlet weak var buttonEmailPatient: UIButton!
    @IBOutlet weak var buttonSMSHospital: UIButton!
    @IBOutlet weak var buttonEmailHospital: UIButton!
    
    
    
    var onTapNotify : (()->Void)?
    var onTapDiscard : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    
}


extension NotifyView {
    
    func initialLoads() {
        
        self.buttonNotify.addTarget(self, action: #selector(notify), for: .touchUpInside)
        self.buttonDiscard.addTarget(self, action: #selector(disCard), for: .touchUpInside)

    }
    
    @IBAction func disCard() {
        
        self.dismissView {
            self.onTapDiscard?()
        }

    }
    @IBAction func notify() {
        
        self.dismissView {
            self.onTapNotify?()
        }

    }

}

