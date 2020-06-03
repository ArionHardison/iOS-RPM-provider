//
//  LaunchViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    

}

extension LaunchViewController {
    func initialLoads() {
        self.buttonLogin.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)
        self.buttonRegister.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)

    }
    
    func setDesign(){
        
    }
    
    @objc func onTapLogin(){
        
        self.push(id: Storyboard.Ids.SignInMobileViewController, animation: true)
    }
    @objc func onTapRegistration(){
        self.push(id: Storyboard.Ids.SignInMobileViewController, animation: true)

    }
}
