//
//  EditProfileTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var buttonChangePassword : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
    }
}
extension EditProfileTableViewController {
    func intialLoads() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.editProfile.localize()
        self.buttonChangePassword.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
    }
    
    @IBAction func changePassword() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangePasswordViewController) as! ChangePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
