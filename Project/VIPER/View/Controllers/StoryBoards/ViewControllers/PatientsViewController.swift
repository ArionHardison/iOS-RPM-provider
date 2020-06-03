//
//  PatientsViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController {

    @IBOutlet weak var patientsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }


}


extension PatientsViewController {
    func initialLoads(){
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.patients.localize()

    }
    func registerCell(){
        
        self.patientsTable.tableFooterView = UIView()
        self.patientsTable.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientTableViewCell")

    }
    
    @objc func showOptions(sender : UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call Patient", style: .default, handler: { (_) in
            print("User click Approve button")
        }))

        alert.addAction(UIAlertAction(title: "Add Appointment", style: .default, handler: { (_) in
            print("User click Edit button")
        }))

        alert.addAction(UIAlertAction(title: "Add File", style: .default, handler: { (_) in
            print("User click Edit button")
        }))

        alert.addAction(UIAlertAction(title: "Delete Patient", style: .destructive, handler: { (_) in
            print("User click Delete button")
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension PatientsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.patientsTable.dequeueReusableCell(withIdentifier: "PatientTableViewCell", for: indexPath) as! PatientTableViewCell
        tableCell.buttonOptions.tag = indexPath.row
        tableCell.buttonOptions.addTarget(self, action: #selector(showOptions(sender:)), for: .touchUpInside)
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.push(id: Storyboard.Ids.AppointmentDetailsViewController, animation: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
}
