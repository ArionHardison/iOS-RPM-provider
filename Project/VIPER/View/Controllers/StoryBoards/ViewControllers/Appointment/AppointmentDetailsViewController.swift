//
//  AppointmentDetailsViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 28/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

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
//    @IBOutlet weak var recentListTableHeight: NSLayoutConstraint!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var enterPrescriptionButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!

    var notifyView : NotifyView!
    var appoinment : All_appointments = All_appointments()
    var invoiceView : InvoiceView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.populateData()
        self.setupAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.patientImage.makeRoundedCorner()

    }
    
    func populateData(){
       let appoinment : All_appointments = self.appoinment
            
            if let data : Patient = appoinment.patient{
            
            self.patientImage.setURLImage(data.profile?.profile_pic ?? "")
            self.labelPatientName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
            self.labelPatientID.text = "\(data.id ?? 0)"
            self.labelPatientDetails.text = "\(data.profile?.age ?? "" ) years, \(data.profile?.gender ?? "")"
            }
            
            self.labelDoctorName.text = "\(profile.doctor?.first_name ?? "") \(profile.doctor?.last_name ?? "")"
            self.labelAppointmentDetails.text = dateConvertor(appoinment.scheduled_at ?? "", _input: .date_time, _output: .DMY_Time)
            let scheduledDAte = dateConvertor(appoinment.scheduled_at ?? "", _input: .date_time, _output: .YMD)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date())
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "YYYY-MM-dd"
            let convertedDate = formatter.string(from: yourDate!)

            
            if scheduledDAte != convertedDate{
                self.videoCallButton.isHidden = true
            }else{
                self.videoCallButton.isHidden = false
            }
        
    }
    
    func setupAction(){
        self.buttonCancelAppointment.addTap {
            self.cancelAppointmentDetail(id: self.appoinment.id?.description ?? "0")
        }
    }
    
    @IBAction private func addPrescriptionAction(sender:UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AddPrescriptionViewController) as! AddPrescriptionViewController
        vc.appoitmentID = self.appoinment.id ?? 0
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
        
        
    }
    
}
extension AppointmentDetailsViewController {
    
    func initialLoads(){
        registerCell()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.edit.localize(), style: .done, target: self, action: #selector(self.editAction))
        self.enterPrescriptionButton.addTarget(self, action: #selector(addPrescriptionAction(sender:)), for: .touchUpInside)
        self.navigationItem.title = Constants.string.appointmentDetails.localize()
        self.buttonViewPatientDetails.addTarget(self, action: #selector(patientDetails), for: .touchUpInside)
        self.videoCallButton.addTarget(self, action: #selector(videoCallAction(_sender:)), for: .touchUpInside)
        self.buttonMark.addTarget(self, action: #selector(MarkAction(sender:)), for: .touchUpInside)
        self.completionButton.addTarget(self, action: #selector(completedAction(sender:)), for: .touchUpInside)
//        self.recentListTableHeight.constant = 30 + (10 * 60)
        
        
        
    }
    func registerCell(){
        self.recentListTable.tableFooterView = UIView()
        self.recentListTable.register(UINib(nibName: "RecentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentHistoryTableViewCell")
    }
    @objc func patientDetails(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  Storyboard.Ids.PatientsInformationViewController) as! PatientsInformationViewController
        vc.Patients = self.appoinment.patient!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editAction() {
        let vc = EditAppointmentTableViewController.initVC(storyBoardName: .main, vc: EditAppointmentTableViewController.self, viewConrollerID: Storyboard.Ids.EditAppointmentTableViewController)
        vc.appoinment = self.appoinment
        self.push(from: self, ToViewContorller: vc)
//        self.push(id: Storyboard.Ids.EditAppointmentTableViewController, animation: true)
    }
    
    @IBAction private func completedAction(sender:UIButton)
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AppointmentFeedBackViewController) as! AppointmentFeedBackViewController
//        vc.appoitments = self.appoinment
//        self.navigationController?.pushViewController(vc, animated: true)
        if self.invoiceView == nil, let invoice = Bundle.main.loadNibNamed(XIB.Names.InvoiceView, owner: self, options: [:])?.first as? InvoiceView {
            invoice.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            invoiceView = invoice
            invoiceView.populateData(invoice: self.appoinment.invoice)
            invoiceView.onClickDone = {
                self.invoiceView.removeFromSuperview()
                self.invoiceView = nil
                let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AppointmentFeedBackViewController) as! AppointmentFeedBackViewController
                    vc.appoitments = self.appoinment
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            self.view.addSubview(invoiceView!)
        }
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
    
    @IBAction private func videoCallAction(_sender:UIButton){
        if #available(iOS 13.0, *) {
         let twilioVideoController = self.storyboard?.instantiateViewController(identifier: "audioVideoCallCaontroller") as! audioVideoCallCaontroller
            twilioVideoController.modalPresentationStyle = .fullScreen
            self.present(twilioVideoController, animated: true, completion: {
                twilioVideoController.video = 1
                twilioVideoController.receiverId = "\(self.appoinment.patient_id ?? 0 )"
                twilioVideoController.receiverName = (self.appoinment.patient?.first_name ?? "") + (self.appoinment.patient?.last_name ?? "")
                twilioVideoController.isCallType = .makeCall
                twilioVideoController.handleCall(roomId: "12345", receiverId: "\(self.appoinment.patient_id ?? 0 )",isVideo : 1)
                               })
                           } else {
                             // Fallback on earlier versions
                           }

        
    }

    
}


extension AppointmentDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        Common.setFontWithType(to: titleLabel, size: 14, type: .meduim)
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

//Api calls
extension AppointmentDetailsViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                self.popOrDismiss(animation: true)
                print("Datatata",data)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        showToast(msg: error.localizedDescription, bgcolor: .red)
        
    }
  
    
    func cancelAppointmentDetail(id : String){
        
        let url = "\(Base.cancelAppoinemnt.rawValue)"
        self.presenter?.HITAPI(api: url, params: ["id": id], methodType: .POST, modelClass: CommonModel.self, token: true)
    }
}
