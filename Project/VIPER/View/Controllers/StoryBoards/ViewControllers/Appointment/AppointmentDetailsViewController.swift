//
//  AppointmentDetailsViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 28/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class AppointmentDetailsViewController: UIViewController {

    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var labelPatientName: UILabel!
    @IBOutlet weak var labelPatientID: UILabel!
    @IBOutlet weak var labelPatientDetails: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorString: UILabel!
    @IBOutlet weak var labelAppointmentDetailsString: UILabel!
    @IBOutlet weak var labelAppointmentDetails: UILabel!
    @IBOutlet weak var buttonCancelAppointment: UIButton!
    @IBOutlet weak var buttonMark: UIButton!
    @IBOutlet weak var buttonViewPatientDetails: UIButton!
    @IBOutlet weak var recentListTable: UITableView!
    @IBOutlet weak var recentListTableHeight: NSLayoutConstraint!
    
    var notifyView : NotifyView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension AppointmentDetailsViewController {
    
    func initialLoads(){
        registerCell()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.edit.localize(), style: .done, target: self, action: #selector(self.editAction))
        self.navigationItem.title = Constants.string.appointmentDetails.localize()
        self.buttonViewPatientDetails.addTarget(self, action: #selector(patientDetails), for: .touchUpInside)
        self.buttonMark.addTarget(self, action: #selector(MarkAction(sender:)), for: .touchUpInside)
        self.recentListTableHeight.constant = 30 + (10 * 60)
        
    }
    func registerCell(){
        self.recentListTable.tableFooterView = UIView()
        self.recentListTable.register(UINib(nibName: "RecentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentHistoryTableViewCell")
    }
    @objc func patientDetails(){
        self.push(id: Storyboard.Ids.PatientsInformationViewController, animation: true)
    }
    
    @IBAction func editAction() {
        
        self.push(id: Storyboard.Ids.EditAppointmentTableViewController, animation: true)
    }
    
    @IBAction func MarkAction(sender:UIButton){
        self.showNotify(sender: sender)
    }
    
    func showNotify(sender:UIButton) {
        
        if self.notifyView == nil, let couponViewObject = Bundle.main.loadNibNamed(XIB.Names.NotifyView, owner: self, options: [:])?.first as? NotifyView {
            
            couponViewObject.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: (UIApplication.shared.keyWindow?.frame.height)!))
            self.notifyView = couponViewObject
            self.notifyView?.show(with: .bottom, completion: nil)
            UIApplication.shared.keyWindow?.addSubview(notifyView!)
            
            self.notifyView.onTapDiscard = {
                self.notifyView = nil
            }
            self.notifyView.onTapNotify = {
                self.notifyView = nil
            }

        }

    }

    
}


extension AppointmentDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.recentListTable.dequeueReusableCell(withIdentifier: "RecentHistoryTableViewCell", for: indexPath) as! RecentHistoryTableViewCell
        tableCell.selectionStyle = .none
        return tableCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9607035518, green: 0.9608380198, blue: 0.9606611133, alpha: 1)
        let titleLabel = UILabel()
        titleLabel.text = "Recent History"
        titleLabel.textColor = .darkGray
        titleLabel.frame = CGRect(x: 16, y: 0, width: self.view.frame.width-16, height: 30)
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

}
