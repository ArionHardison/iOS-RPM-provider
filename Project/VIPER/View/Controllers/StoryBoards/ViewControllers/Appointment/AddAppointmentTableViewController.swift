//
//  AddAppointmentTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class AddAppointmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        intialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}

extension AddAppointmentTableViewController {
    func intialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.string.Cancel.localize(), style: .done, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.addAppointment.localize()

    }
}
