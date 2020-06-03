//
//  NotifyVView.swift
//  Project
//
//  Created by Vinod Reddy Sure on 29/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit


class NotifyView: UIView {

    @IBOutlet weak var buttonPatientSMS: UIButton!
    @IBOutlet weak var buttonPatientEmail: UIButton!
    @IBOutlet weak var buttonDoctorSMS: UIButton!
    @IBOutlet weak var buttonDoctorEmail: UIButton!
    @IBOutlet weak var buttonDiscard: UIButton!
    @IBOutlet weak var buttonNotify: UIButton!
    @IBOutlet var buttons : [UIButton]!
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
        
        self.buttonPatientSMS.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonPatientEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonDoctorSMS.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonDoctorEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 8, state: .normal)

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
