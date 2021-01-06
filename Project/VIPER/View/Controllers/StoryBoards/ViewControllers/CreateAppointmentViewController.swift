//
//  CreateAppointmentViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 31/10/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateAppointmentViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createAppointmentLabel: UILabel!
    @IBOutlet weak var patientNameTextField: HoshiTextField!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var createAppointment: UIButton!
    var isFromCalendar : Bool  = false
    var patientDetails = AllPatients()
    var selectedDate : String = ""
    var serviceId : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

}


extension CreateAppointmentViewController {
    private func initalLoads(){
        self.setLocalization()
        self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.createAppointment.addTarget(self, action: #selector(appointmentAction(sender:)), for: .touchUpInside)
        self.patientNameTextField.text = (self.patientDetails.first_name ?? "") + " " +  (self.patientDetails.last_name ?? "")
        self.commentsTextView.autocorrectionType = .no
       
        
    }
    
    @IBAction private func cancelAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func appointmentAction(sender:UIButton){
        if commentsTextView.text == "Write Something"{
            self.view.makeToast("Enter Comments")
        }else{
            
        }
        var params = [String:Any]()
        params.updateValue(UserDefaultConfig.UserID , forKey: "doctor_id")
        params.updateValue(self.patientDetails.id ?? 0, forKey: "selectedPatient")
        params.updateValue("ONLINE", forKey: "appointment_type")
        params.updateValue("consultation", forKey: "booking_for")
        params.updateValue(15, forKey: "consult_time")
        params.updateValue(profile.doctor?.services_id ?? "0", forKey: "service_id")
        params.updateValue(self.selectedDate, forKey: "scheduled_at")
        params.updateValue(self.commentsTextView.text ?? "", forKey: "description")
        params.updateValue("wallet", forKey: "payment_mode")
        self.presenter?.HITAPI(api:Base.addAppoinemnt.rawValue, params: params, methodType: .POST, modelClass: CreateAppointment.self, token: true)
        
        
    }
    
    
    private func setLocalization(){
//        self.cancelButton.setTitle("Cancel", for: .normal)
        self.createAppointmentLabel.text = "Create Appointment View"
        self.patientNameTextField.placeholder = "Patient Name"
        self.commentsLabel.text = "Comments"
        self.createAppointment.setTitle("Create Appointment", for: .normal)
        self.commentsTextView.text = "Write Something"
        self.commentsTextView.delegate = self
        self.commentsTextView.textColor = .lightGray
        Common.setFont(to: self.patientNameTextField,size: 20)
        
    }
    
    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
}



extension CreateAppointmentViewController : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Write Something"{
            textView.text = ""
            textView.textColor = .black
        }else{
            
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write Something"
            textView.textColor = .lightGray
        }
    }
    
    
    
}


extension CreateAppointmentViewController : PresenterOutputProtocol{
    func showError(error: CustomError) {
        showToast(msg: error.localizedDescription)
        self.popBack(toControllerType: CalendarViewController.self)
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.CreateAppointment:
                guard let data = dataDict as? CreateAppointment else { return }
                if Bool(data.success ?? "0") ?? true{
                    if isFromCalendar{
                    self.popBack(toControllerType: CalendarViewController.self)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.view.makeToast(data.message ?? "")
                    if isFromCalendar{
                    self.popBack(toControllerType: CalendarViewController.self)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            
                break
            
            default: break
            
        }
    }
}
