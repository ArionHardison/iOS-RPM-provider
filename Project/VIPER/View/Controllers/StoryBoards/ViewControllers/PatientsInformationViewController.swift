//
//  PatientsInformationViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class PatientsInformationViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPatientID: UILabel!
    @IBOutlet weak var labelPatientDetails: UILabel!
    @IBOutlet weak var buttonCharting: UIButton!
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusCenter: NSLayoutConstraint!
    @IBOutlet weak var chartingTable: UITableView!
    @IBOutlet weak var profileView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension PatientsInformationViewController {
    func initialLoads(){
        profileView.isHidden = true
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Add").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.addAction))

        self.navigationItem.title = Constants.string.patientInformation.localize()
        self.buttonProfile.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        self.buttonCharting.addTarget(self, action: #selector(chartingAction), for: .touchUpInside)

    }
    func registerCell(){
        
        self.chartingTable.tableFooterView = UIView()
        
        self.chartingTable.register(UINib(nibName: "ChartingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartingTableViewCell")

    }
    
    @objc func chartingAction() {
        
        profileView.isHidden = true
        self.labelStatusCenter.constant = self.buttonCharting.frame.origin.x
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Add").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.addAction))

    }

    @objc func profileAction() {
        
        profileView.isHidden = false
        self.labelStatusCenter.constant = self.buttonProfile.frame.origin.x
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.edit.localize(), style: .done, target: self, action: #selector(self.profileEditAction))

    }
    
    @objc func profileEditAction() {
        
        self.push(id: Storyboard.Ids.EditPatientInformationTableViewController, animation: true)
    }
    
    @objc func addAction() {
        
    }
}

extension PatientsInformationViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = chartingTable.dequeueReusableCell(withIdentifier: "ChartingTableViewCell", for: indexPath) as! ChartingTableViewCell
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9607035518, green: 0.9608380198, blue: 0.9606611133, alpha: 1)
        let titleLabel = UILabel()
        titleLabel.text = "Scheduled - Sat 23 Oct 2019"
        titleLabel.textColor = .darkGray
        titleLabel.frame = CGRect(x: 16, y: 0, width: self.view.frame.width-16, height: 30)
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
