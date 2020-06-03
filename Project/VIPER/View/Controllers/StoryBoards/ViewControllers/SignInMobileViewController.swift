//
//  SignInMobileViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class SignInMobileViewController: UIViewController {

    @IBOutlet weak var textFieldCountryCode: HoshiTextField!
    @IBOutlet weak var textFieldMobile: HoshiTextField!
    @IBOutlet weak var buttonUsingEmail: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func usingEmailAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignInEmailViewController, animation: true)

    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.DashBoardViewController, animation: true)

    }
    

}
