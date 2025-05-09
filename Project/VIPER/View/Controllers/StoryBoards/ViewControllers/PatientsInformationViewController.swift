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
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var labelPatientID: UILabel!
    @IBOutlet weak var labelPatientDetails: UILabel!
    @IBOutlet weak var buttonCharting: UIButton!
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusCenter: NSLayoutConstraint!
    @IBOutlet weak var chartingTable: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    var horizontalConstraintCharting : NSLayoutConstraint!
    var horizontalConstraintProfile : NSLayoutConstraint!

    
    var Patients : Patient = Patient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.populateData()
    }

}

extension PatientsInformationViewController {
    func initialLoads(){
        profileView.isHidden = true
        registerCell()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addAction))

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
        self.buttonProfile.setTitleColor(UIColor.darkGray, for: .normal)
        self.buttonCharting.setTitleColor(UIColor.AppBlueColor, for: .normal)
        self.labelStatusCenter.constant = 0
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Add").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.addAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addAction))

        self.buttonProfile.setTitleColor(UIColor(named: "TextForegroundColor"), for: .normal)
        self.buttonCharting.setTitleColor(UIColor.AppBlueColor, for: .normal)

    }

    @objc func profileAction() {
        
        self.buttonProfile.setTitleColor(UIColor.AppBlueColor, for: .normal)
        self.buttonCharting.setTitleColor(UIColor(named: "TextForegroundColor"), for: .normal)
        profileView.isHidden = false
        self.labelStatusCenter.constant = self.buttonProfile.frame.origin.x
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.edit.localize(), style: .done, target: self, action: #selector(self.profileEditAction))

    }
    
    @objc func profileEditAction() {
        let vc = EditPatientInformationTableViewController.initVC(storyBoardName: .main, vc: EditPatientInformationTableViewController.self, viewConrollerID: Storyboard.Ids.EditPatientInformationTableViewController)
        vc.Patients = self.Patients
        self.push(from: self, ToViewContorller: vc)
    }
    
    @objc func addAction() {
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.profileImg.makeRoundedCorner()

    }
    func populateData(){
        let data : Patient = self.Patients
            self.labelName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
            self.labelPatientID.text = "\(data.id ?? 0)"
            self.labelPatientDetails.text = "\(data.profile?.age ?? "") Year ,\(data.profile?.gender ?? "")"
            self.profileImg.setURLImage(data.profile?.profile_pic ?? "")
            
        }
  
}

extension PatientsInformationViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Patients.appointments?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = chartingTable.dequeueReusableCell(withIdentifier: "ChartingTableViewCell", for: indexPath) as! ChartingTableViewCell
        self.setupData(cell: tableCell, data: self.Patients.appointments?[indexPath.row] ?? Appointments())
        return tableCell
    }
    
    func setupData(cell : ChartingTableViewCell , data : Appointments){
        cell.labelAppointmentDetails.text = "\(data.hospital?.first_name ?? "") - \(dateConvertor(data.scheduled_at ?? "", _input: .date_time, _output: .N_hour))"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "TextBackgroudCOlor")
        let titleLabel = UILabel()
        titleLabel.text = "Scheduled - \(dateConvertor(self.Patients.appointments?[section].scheduled_at ?? "", _input: .date_time, _output: .edmy))"
        Common.setFontWithType(to: titleLabel, size: 14.0, type: .meduim)
        titleLabel.textColor = UIColor(named: "TextBlackColor")
        titleLabel.frame = CGRect(x: 16, y: headerView.frame.height/2, width: self.view.frame.width-16, height: 40)
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
