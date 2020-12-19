//
//  AddAppointmentTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class AddAppointmentTableViewController: UITableViewController {
    
    @IBOutlet weak var patientNameTxt : HoshiTextField!
    @IBOutlet weak var patientIDTxt : HoshiTextField!
    @IBOutlet weak var emailTxt : HoshiTextField!
    @IBOutlet weak var phoneNumTxt : HoshiTextField!
    @IBOutlet weak var sexTxt : HoshiTextField!
    @IBOutlet weak var ageTxt : HoshiTextField!
    @IBOutlet weak var commentTxt : UITextView!
    @IBOutlet weak var addPatientBtn : UIButton!
    @IBOutlet weak var schudleTxt : HoshiTextField!
    @IBOutlet weak var schuldeDate : UIButton!
    @IBOutlet weak var selectPatientTextField: HoshiTextField!
    @IBOutlet weak var orLabel: UILabel!
    
    var selectedDate : String = ""
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
    
    func setupAction(){
        self.addPatientBtn.addTap {
            if self.validation(){
                var appoinment = AppointmentReq()
                appoinment.age = self.ageTxt.getText
                appoinment.patient_id = self.patientIDTxt.getText
                appoinment.first_name = self.patientNameTxt.getText
                appoinment.last_name = "A"
                appoinment.doctor_id = profile.doctor?.id?.description ?? "0"
                appoinment.service_id = profile.doctor?.services_id ?? ""
                appoinment.scheduled_at = self.schudleTxt.getText
                appoinment.consult_time = "15"
                appoinment.appointment_type = "ONLINE"
                appoinment.description = self.commentTxt.text ?? ""
                appoinment.email = self.emailTxt.getText
                appoinment.phone = self.phoneNumTxt.getText
                appoinment.gender = self.sexTxt.getText
                appoinment.age = self.ageTxt.getText
                self.addAppoinemnt(data: appoinment)
               
            }
        }
        
        self.schuldeDate.addTap {
            let view = DatePickerAlert.getView
            view.alertdelegate = self
            AlertBuilder().addView(fromVC: self , view).show()
        }
    }
    
    func validation() -> Bool{
        if self.patientNameTxt.getText.isEmpty{
            showToast(msg: "Please Enter Patient Name")
            return false
        }else if self.patientIDTxt.getText.isEmpty{
            showToast(msg: "Please Enter Patient ID")
            return false
        }else if self.emailTxt.getText.isEmpty || !self.emailTxt.getText.isValidEmail(){
            showToast(msg: "Please Enter Valid EmailID")
            return false
        }else if self.phoneNumTxt.getText.isEmpty || !self.phoneNumTxt.getText.isPhoneNumber{
            showToast(msg: "Please Enter Valid Mobile Number")
            return false
        }else if self.sexTxt.getText.isEmpty{
            showToast(msg: "Please Enter your Gender detail")
            return false
        }else if self.ageTxt.getText.isEmpty{
            showToast(msg: "Please Enter your age")
            return false
        }else if self.schudleTxt.getText.isEmpty{
            showToast(msg: "Please select you schudle date")
            return false
        }else{
            return true
        }
    }
    
    func setupFont(){
//        Common.setFont(to: self.patientNameTxt)
//        Common.setFont(to: self.patientIDTxt)
//        Common.setFont(to: self.emailTxt)
//        Common.setFont(to: self.phoneNumTxt)
//        Common.setFont(to: self.sexTxt)
//        Common.setFont(to: self.ageTxt)
//        Common.setFont(to: self.commentTxt)
        self.orLabel.text = "or"
        self.schudleTxt.text = self.selectedDate
    }
    

}

extension AddAppointmentTableViewController {
    func intialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.string.Cancel.localize(), style: .done, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.addAppointment.localize()
        self.selectPatientTextField.delegate = self
        self.setupFont()
        self.setupAction()
        

    }
}

//Api calls
extension AddAppointmentTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.AppointmentModel:
                guard let data = dataDict as? AppointmentModel else { return }
                if data.all_appointments?.count ?? 0 > 0 {
                    self.popOrDismiss(animation: true)
                }
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func addAppoinemnt(data : AppointmentReq){
        let url = "\(Base.addAppoinemnt.rawValue)"
        self.presenter?.HITAPI(api: url, params: convertToDictionary(model: data), methodType: .POST, modelClass: AppointmentModel.self, token: true)
    }
    
}

extension AddAppointmentTableViewController : AlertDelegate{
    func selectedDate(selectionType: String, date: String, alertVC: UIViewController) {
        self.schudleTxt.text = date
    }
    
    func selectedDateTime(selectionType: DateselectionOption,date : Date, datestr: String, time: String, alertVC: UIViewController) {
       
    }
    
    func selectedTime(time: String, alertVC: UIViewController) {
        
    }
    
    
}


extension AddAppointmentTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectPatientTextField{
            let vc = self.storyboard?.instantiateViewController(identifier: Storyboard.Ids.PatientsViewController) as! PatientsViewController
            vc.selectedDate = self.selectedDate
            vc.isFromCalendar = true
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    
}
