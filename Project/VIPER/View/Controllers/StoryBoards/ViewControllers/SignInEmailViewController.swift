//
//  SignInEmailViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class SignInEmailViewController: UIViewController {

    @IBOutlet weak var buttonUsingMobile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func usingMobileAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignInMobileViewController, animation: true)
    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.DashBoardViewController, animation: true)

    }

    
}
extension SignInEmailViewController {
    
}
