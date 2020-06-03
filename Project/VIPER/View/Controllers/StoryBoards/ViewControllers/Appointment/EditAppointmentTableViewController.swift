//
//  EditAppointmentTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class EditAppointmentTableViewController: UITableViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var buttonPatientSms: UIButton!
    @IBOutlet weak var buttonPatientEmail: UIButton!

    @IBOutlet weak var buttonDoctorSms: UIButton!
    @IBOutlet weak var buttonDoctorEmail: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }


}

extension EditAppointmentTableViewController {
    func initialLoads() {
        setDesign()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.editAppointment.localize()

    }
    
    @IBAction func doneAction() {
        
    }
    
    func setDesign() {
        
        self.buttonPatientSms.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonPatientEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonDoctorSms.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 16, state: .normal)
        self.buttonDoctorEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 16, state: .normal)

    }
}
