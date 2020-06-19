//
//  EditAppointmentTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class EditAppointmentTableViewController: UITableViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelPatientName: UILabel!
    @IBOutlet weak var labelPatientID: UILabel!
    @IBOutlet weak var labelPatientDetails: UILabel!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelDoctorString: UILabel!
    @IBOutlet weak var labelAppointmentDetailsString: UILabel!
    @IBOutlet weak var labelAppointmentDetails: UILabel!
    @IBOutlet weak var editSchudleDate: UIButton!
    @IBOutlet weak var buttonPatientSms: UIButton!
    @IBOutlet weak var buttonPatientEmail: UIButton!

    @IBOutlet weak var buttonDoctorSms: UIButton!
    @IBOutlet weak var buttonDoctorEmail: UIButton!

    var appoinment : All_appointments = All_appointments()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
        self.setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.populateData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    func populateData(){
        if let appoinment : All_appointments = self.appoinment{
            
            if let data : Patient = appoinment.patient{
                
                self.profileImage.makeRoundedCorner()
                self.profileImage.setURLImage(data.profile?.profile_pic ?? "")
                self.labelPatientName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
                self.labelPatientID.text = "\(data.id ?? 0)"
                self.labelPatientDetails.text = "\(data.profile?.age ?? "" ) years, \(data.profile?.gender ?? "")"
            }
            
            self.labelDoctorName.text = "\(profile.doctor?.first_name ?? "") \(profile.doctor?.last_name ?? "")"
            self.labelAppointmentDetails.text = dateConvertor(appoinment.scheduled_at ?? "", _input: .date_time, _output: .DMY_Time)
            
        }
    }
    
    func setupAction(){
        self.editSchudleDate.addTap {
            let view = DatePickerAlert.getView
            view.alertdelegate = self
            AlertBuilder().addView(fromVC: self , view).show()
        }
    }
    
}

extension EditAppointmentTableViewController {
    func initialLoads() {
        setDesign()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.doneAction))
        self.navigationItem.title = Constants.string.editAppointment.localize()

    }
    
    @objc func doneAction() {
        var appoinment = EditAppointmentReq()
        appoinment.patient_id = self.labelPatientID.getText
        appoinment.id = self.appoinment.id?.description ?? ""
        appoinment.description = self.appoinment.description ?? ""
        appoinment.doctor_id = profile.doctor?.id?.description ?? "0"
        appoinment.service_id = "2"
        appoinment.scheduled_at = self.labelAppointmentDetails.getText
        appoinment.consult_time = "5"
        appoinment.appointment_type = "ONLINE"
          self.editAppoinemnt(data: appoinment)
    }
    
    func setDesign() {
        
        self.buttonPatientSms.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonPatientEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 8, state: .normal)
        self.buttonDoctorSms.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "SMS", titlePosition: .right, additionalSpacing: 16, state: .normal)
        self.buttonDoctorEmail.set(image: #imageLiteral(resourceName: "Rectangle 298"), title: "Email", titlePosition: .right, additionalSpacing: 16, state: .normal)

    }
}

extension EditAppointmentTableViewController : AlertDelegate{
    func selectedDate(selectionType: String, date: String, alertVC: UIViewController) {
        self.labelAppointmentDetails.text = date
    }
    
    func selectedDateTime(selectionType: DateselectionOption,date : Date, datestr: String, time: String, alertVC: UIViewController) {
        
    }
    
    func selectedTime(time: String, alertVC: UIViewController) {
        
    }
    
    
}
//Api calls
extension EditAppointmentTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.AppointmentModel:
                guard let data = dataDict as? AppointmentModel else { return }
                if data.status ?? false{
                    self.popOrDismiss(animation: true)
                }
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func editAppoinemnt(data : EditAppointmentReq){
        let url = "\(Base.editAppointment.rawValue)"
        self.presenter?.HITAPI(api: url, params: convertToDictionary(model: data), methodType: .POST, modelClass: AppointmentModel.self, token: true)
    }
    
}
