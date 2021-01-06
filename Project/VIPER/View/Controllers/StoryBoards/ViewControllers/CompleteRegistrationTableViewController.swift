//
//  CompleteRegistrationTableViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 16/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class CompleteRegistrationTableViewController: UITableViewController {
    @IBOutlet weak var specialityTextField: HoshiTextField!
    @IBOutlet weak var serviceTextField: HoshiTextField!
    @IBOutlet weak var genderTextField: HoshiTextField!
    @IBOutlet weak var consulationFees: HoshiTextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    var firstName : String = ""
    var lastName : String = ""
    var personalEmail : String = ""
    var password : String = ""
    var confirmPasswd : String = ""
    var clinicName : String = ""
    var clinicEmail : String = ""
    var countryCode : String = ""
    var phoneNumber : String = ""
    var address : String = ""
    var lat : Double = 0
    var long : Double = 0
    var pincode : String = "1234567"
    var selectedCategoryID : Int = 0
    var speciality = [Speciality]()
    var services = [Services]()
    var servicesId = [Int]()
    var gender : [String] = ["Male","Female","Others"]
    var days : [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    var selectedDays = [String]()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

  

}


extension CompleteRegistrationTableViewController {
    
    private func initialLoads(){
        self.localize()
        self.serviceTextField.delegate = self
        self.specialityTextField.delegate = self
        self.genderTextField.delegate = self
        self.consulationFees.delegate = self
        self.fromTextField.delegate = self
        self.toTextField.delegate = self
        self.getServices()
        self.tableView.register(UINib(nibName: "FAQCell", bundle: nil), forCellReuseIdentifier: "FAQCell")
        self.tableView.allowsMultipleSelection = true
        self.registerButton.addTarget(self, action: #selector(registrationAction(_sender:)), for: .touchUpInside)
        
        
    }
    
    private func localize(){
        self.specialityTextField.placeholder = "Speciality"
        self.serviceTextField.placeholder = "Categories"
        self.genderTextField.placeholder = "Gender"
        self.consulationFees.placeholder = "Consulation Fees"
        self.fromLabel.text = "From :"
        self.toLabel.text = "To :"
        self.registerButton.setTitle("Register", for: .normal)
        self.getSpecialitites()
    }
    
    private func getSpecialitites(){
        self.presenter?.HITAPI(api: Base.getSpeciality.rawValue, params: nil, methodType: .GET, modelClass: GetSpeciality.self, token: false)
        self.loader.isHidden = false
    }
    
    private func getServices(){
        self.presenter?.HITAPI(api: Base.getService.rawValue, params: nil, methodType: .GET, modelClass: GetServices.self, token: false)
        self.loader.isHidden = false
    }
    
    @IBAction private func registrationAction(_sender:UIButton){
        
        guard  let gender = self.genderTextField.text, !gender.isEmpty else {
            showToast(msg: "Enter Gender to continue")
            return
        }
        guard  let speciality = self.specialityTextField.text , !speciality.isEmpty else {
            showToast(msg: "Enter Speciality to continue")
            return
        }
        guard  let start_time = self.fromTextField.text, !start_time.isEmpty else {
            showToast(msg: "Enter Availablity From Time to Continue")
            return
        }
        guard let end_time = self.toTextField.text, !end_time.isEmpty else {
            showToast(msg: "Enter Availablity Till Time to Continue")
            return
        }
        guard let services = self.serviceTextField.text, !services.isEmpty else{
            showToast(msg: "Enter Services to continue")
            return
        }
        
        guard  let consulationfees = self.consulationFees.text, !consulationfees.isEmpty else {
            showToast(msg: "Enter Consulation Fees")
            return
        }
        
        
        
        var params = [String:Any]()
        params.updateValue(firstName, forKey: "first_name")
        params.updateValue(lastName, forKey: "last_name")
        params.updateValue(personalEmail, forKey: "email")
        params.updateValue("123456", forKey: "password")
        let mobileNumber = countryCode + phoneNumber
        params.updateValue(mobileNumber, forKey: "phone")
        params.updateValue(gender, forKey: "gender")
        params.updateValue(selectedCategoryID, forKey: "specialities")
        params.updateValue("ios", forKey: "device_type")
        params.updateValue(consulationfees, forKey: "fees")
        params.updateValue(deviceTokenString, forKey: "device_token")
        params.updateValue(push_device_token, forKey: "push_device_token")
        params.updateValue(deviceId, forKey: "device_id")
        params.updateValue(self.address, forKey: "address")
        params.updateValue(self.pincode, forKey: "postal_code")
        params.updateValue(start_time, forKey: "start_time")
        params.updateValue(end_time, forKey: "end_time")
        params.updateValue(clinicName, forKey: "clinic_name")
        params.updateValue(clinicEmail, forKey: "clinic_email")
        params.updateValue(lat, forKey: "latitude")
        params.updateValue(long, forKey: "longitude")
        var workingDay = [String:String]()
        for (index,values) in self.selectedDays.enumerated(){
            
            workingDay.updateValue("\(values)", forKey: "\(index)")
//            params.updateValue(values, forKey: "working_day[\(index)]")
        }
        var servicesArray = [String:String]()
        for (index,values) in self.services.enumerated(){
//            params.updateValue(values.id ?? 0, forKey: "service[\(index)]")
            servicesArray.updateValue("\(values.id ?? 0)", forKey: "\(index)")
        }
        params.updateValue(workingDay, forKey: "working_day")
        params.updateValue(servicesArray, forKey: "service")
        print(params)
        self.presenter?.HITAPI(api: Base.registerDoctor.rawValue, params: params, methodType: .POST, modelClass: SignUpResponse.self, token: false)
        self.loader.isHidden = false
        
    }
    
    private func signinProcess(){
        var params:[String:Any] =  [PARAM_EMAIL:self.personalEmail,
                                    PARAM_PASSWRD : "123456",
                                    PARAM_CLIENTID:appClientId,
                                    PARAM_CLIENTSECRET: appSecretKey,
                                    PARAM_PUSH : push_device_token,
                                    PARAM_DEVICETYPE : "ios",
                                    PARAM_DEVICETOKEN : deviceTokenString,
                                    PARAM_DEVICEID: UUID().uuidString,
                                    PARAM_GRANTTYPE : "password"] as [String : Any]
        self.presenter?.HITAPI(api: Base.loginWithEmail.rawValue, params: params, methodType: .POST, modelClass: MobileVerifyModel.self, token: false)
        self.loader.isHidden = false
    }
    
    func JSONToString(json: [String : String]) -> String?{
        do {
            let mdata =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // json to the data
            let convertedString = String(data: mdata, encoding: String.Encoding.utf8) // the data will be converted to the string
            print("the converted json to string is : \(convertedString!)") // <-- here is ur string

            return convertedString!

        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
}


extension CompleteRegistrationTableViewController {
 


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("FaqHeaderView", owner: self, options: nil)?.first as? FaqHeaderView
        if section == 0{
            headerView?.titleLbl.text = "Speciality Details"
        }else if section == 1{
            headerView?.titleLbl.text = "Timing Available"
        }else if section == 2{
            headerView?.titleLbl.text = "Days Available"
        }
        
        headerView?.titleLbl.textColor = .AppBlueColor
        headerView?.plusLbl.isHidden = true
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        view.backgroundColor = .clear //UIColor(named: "TextForegroundColor")
        return view
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.selectionStyle = .none
        self.selectedDays.append(self.days[indexPath.row])
        }

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        cell?.selectionStyle = .none
        let names = self.days[indexPath.row]
            let ids = self.selectedDays.lastIndex{$0 == names}!
        self.selectedDays.remove(at: ids)
        }


    }
}


extension CompleteRegistrationTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.specialityTextField:
            var category : [String] = []
            for categorie in self.speciality{
                category.append(categorie.name ?? "")
            }
            PickerManager.shared.showPicker(pickerData: category, selectedData: textField.text, completionHandler: { selectedData in
                textField.text = selectedData
                for (index,category) in self.speciality.enumerated() {
                    if category.name == selectedData{
                        self.selectedCategoryID = self.speciality[index].id ?? 0
                    }
                }
                
            })
            return false
        case self.serviceTextField:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SpecialititesListViewController) as! SpecialititesListViewController
            vc.services = self.services
            vc.onClickDone = { (servicesName,ServicesID) in
                textField.text = servicesName.joined(separator: ",")
                self.servicesId = ServicesID
                vc.dismiss(animated: true, completion: nil)
            }
            vc.onClickCancel = { content in
                vc.dismiss(animated: true, completion: nil)
                showToast(msg: "Enter Specialitites to Continue")
            }
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            return false
        case self.genderTextField:
            PickerManager.shared.showPicker(pickerData: gender, selectedData: textField.text, completionHandler: { selectedData in
                textField.text = selectedData
                
            })
            return false
        case self.fromTextField:
            PickerManager.shared.showTimePicker(selectedDate: textField.text, completionHandler: { selectedTime in
                let timeFormatte = DateFormatter()
                let locale = NSLocale.current
                  let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
                  if formatter.contains("a") {
                    timeFormatte.dateFormat = "hh:mm:ss a"
                      //phone is set to 12 hours
                  } else {
                    timeFormatte.dateFormat = "HH:mm:ss"
                      //phone is set to 24 hours
                  }
                let updatedDate = timeFormatte.date(from: selectedTime)
                timeFormatte.dateFormat = "HH:mm:ss"
                let newTime = timeFormatte.string(from: updatedDate!)
                print(newTime)
                textField.text = newTime
                
            })
            return false
        case self.toTextField:
            PickerManager.shared.showTimePicker(selectedDate: textField.text, completionHandler: { selectedTime in
                let timeFormatte = DateFormatter()
                let locale = NSLocale.current
                  let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
                  if formatter.contains("a") {
                    timeFormatte.dateFormat = "hh:mm:ss a"
                      //phone is set to 12 hours
                  } else {
                    timeFormatte.dateFormat = "HH:MM:SS"
                      //phone is set to 24 hours
                  }
                
                let updatedDate = timeFormatte.date(from: selectedTime)
                timeFormatte.dateFormat = "HH:MM:SS"
                let newTime = timeFormatte.string(from: updatedDate ?? Date())
                print(newTime)
                textField.text = newTime
                
            })
            return false
        default:
            return true
        }
      
    }
}


extension CompleteRegistrationTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
        case model.type.GetSpeciality:
            self.loader.isHideInMainThread(true)
            let data = dataDict as? GetSpeciality
            self.speciality = data?.speciality ?? []
            break
        case model.type.GetServices:
            self.loader.isHideInMainThread(true)
            let data = dataDict as? GetServices
            self.services = data?.services ?? []
            break
        case model.type.SignUpResponse:
            self.loader.isHideInMainThread(true)
            let data = dataDict as? SignUpResponse
            print(data)
            self.signinProcess()
            break
        case model.type.MobileVerifyModel:
            self.loader.isHideInMainThread(true)
            let data = dataDict as? MobileVerifyModel
            UserDefaultConfig.Token = data?.token ?? ""
            print("DataToken",UserDefaultConfig.Token)
            self.push(id: Storyboard.Ids.DashBoardViewController, animation: true)
            break
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHideInMainThread(true)
        showToast(msg: error.localizedDescription)
    }
    
    
}
