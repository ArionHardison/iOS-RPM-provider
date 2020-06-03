//
//  EditPatientInformationTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 28/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class EditPatientInformationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        initialLoads()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }


}

extension EditPatientInformationTableViewController {
    func initialLoads(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.doneAction))

        self.navigationItem.title = Constants.string.patientInformation.localize()

    }
    
    @objc func doneAction(){
    }
}
