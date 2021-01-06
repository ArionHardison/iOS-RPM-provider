//
//  RegisterPersonalTableViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 14/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import GooglePlaces
import ObjectMapper

class RegisterPersonalTableViewController: UITableViewController {
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var personalEmailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    
    @IBOutlet weak var clinicNameTextField: HoshiTextField!
    @IBOutlet weak var clinicEmailTextField: HoshiTextField!
    @IBOutlet weak var mobileNumberTextField: HoshiTextField!
    @IBOutlet weak var countryCodeTextField: HoshiTextField!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var addressTextField: HoshiTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var postalCode: HoshiTextField!
    
    var countryCode :String?
    var googlePlacesHelper : GooglePlacesHelper?
    var dlat : Double?
    var dlon : Double?
    var dAddress = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
   

}

extension RegisterPersonalTableViewController {
    
    private func initialLoads(){
        self.localize()
        self.setNavigationBar()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.personalEmailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.clinicNameTextField.delegate = self
        self.clinicEmailTextField.delegate = self
        self.mobileNumberTextField.delegate = self
        self.countryCodeTextField.delegate = self
        self.addressTextField.delegate = self
        self.tableView.allowsSelection = false
        self.googlePlacesHelper = GooglePlacesHelper()
        let country = Common.getCountries()
        for eachCountry in country {
            if "US" == eachCountry.code {
                self.countryCode = eachCountry.dial_code
                self.countryCodeTextField.text = eachCountry.dial_code
                let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                self.countryImage.image = myImage
            }
        }
        self.continueButton.addTarget(self, action: #selector(continueAction(_sender:)), for: .touchUpInside)
        
    }
    
    private func localize(){
        self.firstNameTextField.placeholder = "First Name"
        self.lastNameTextField.placeholder = "Last Name"
        self.personalEmailTextField.placeholder = "Email Id"
        self.passwordTextField.placeholder = "Password"
        self.confirmPasswordTextField.placeholder = "Confirm Password"
        self.clinicNameTextField.placeholder = "Clinic Name"
        self.clinicEmailTextField.placeholder = "Clinic Email Id"
        self.mobileNumberTextField.placeholder = "Mobile Number"
        self.countryCodeTextField.placeholder = "Country"
        self.addressTextField.placeholder = "Address"
        
        
//        self.firstNameTextField.text = "ada"
//        self.lastNameTextField.text = "asdasd"
//        self.personalEmailTextField.text = "bas@c.com"
//        self.passwordTextField.text = "123123"
//        self.confirmPasswordTextField.text = "123123"
//        self.clinicNameTextField.text = "qweqwe"
//        self.clinicEmailTextField.text = "ba@c.com"
//        self.mobileNumberTextField.text = "1231231231"
//        self.countryCodeTextField.text = "+91"
//        self.addressTextField.text = "nungabakkam"
        
        self.continueButton.setTitle("Continue", for: .normal)
        
    }
    
    private func setNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
       self.navigationItem.title = "Register Doctor"
        Common.setFontWithType(to: self.navigationItem.title!, size: 18, type: .meduim)
       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.02583951317, green: 0.1718649864, blue: 0.4112361372, alpha: 1)
    }
    
    
    @IBAction private func continueAction(_sender:UIButton){
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else {
            showToast(msg:"Enter First Name to Continue")
            return
        }
        guard  let lastName = self.lastNameTextField.text, !lastName.isEmpty else {
            showToast(msg:"Enter Last Name to Continue")
            return
        }
        guard  let personalEmail = self.personalEmailTextField.text, !personalEmail.isEmpty else {
            showToast(msg: "Enter Personal Email to Continue")
            return
        }
//        guard let password = self.passwordTextField.text ,!password.isEmpty else {
//            showToast(msg:"Enter Password to Continue")
//            return
//        }
//
//        guard let confirmPasswd = self.confirmPasswordTextField.text,!confirmPasswd.isEmpty , password == confirmPasswd else {
//            showToast(msg:"Enter Confirm Password to Continue")
//            return
//        }

        guard  let clinicName = self.clinicNameTextField.text, !clinicName.isEmpty else {
            showToast(msg:"Enter Clinic Name to Continue")
            return
        }

        guard  let clinicEmail = self.clinicEmailTextField.text , !clinicEmail.isEmpty else {
            showToast(msg:"Enter Clinic Email to Continue")
            return
        }
        guard  let mobile = self.mobileNumberTextField.text , !mobile.isEmpty else {
            showToast(msg: "Enter Mobile Number to Continue")
            return
        }

        guard let address = self.addressTextField.text, !address.isEmpty else {
            showToast(msg: "Enter Address to Continue")
            return
        }

        let mobileNumber = (countryCode ?? "+91") + mobile
        var params = [String:Any]()
        params.updateValue(personalEmail, forKey: "email")
        params.updateValue(mobileNumber, forKey: "phone")
        params.updateValue(clinicEmail, forKey: "clinic_email")
        self.presenter?.HITAPI(api: Base.verifyApi.rawValue, params: params, methodType: .POST, modelClass: CardSuccess.self, token: false)
        
    }
    private func callNextPage(){
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else {
            showToast(msg:"Enter First Name to Continue")
            return
        }
        guard  let lastName = self.lastNameTextField.text, !lastName.isEmpty else {
            showToast(msg:"Enter Last Name to Continue")
            return
        }
        guard  let personalEmail = self.personalEmailTextField.text, !personalEmail.isEmpty else {
            showToast(msg: "Enter Personal Email to Continue")
            return
        }
//        guard let password = self.passwordTextField.text ,!password.isEmpty else {
//            showToast(msg:"Enter Password to Continue")
//            return
//        }
//
//        guard let confirmPasswd = self.confirmPasswordTextField.text,!confirmPasswd.isEmpty , password == confirmPasswd else {
//            showToast(msg:"Enter Confirm Password to Continue")
//            return
//        }

        guard  let clinicName = self.clinicNameTextField.text, !clinicName.isEmpty else {
            showToast(msg:"Enter Clinic Name to Continue")
            return
        }

        guard  let clinicEmail = self.clinicEmailTextField.text , !clinicEmail.isEmpty else {
            showToast(msg:"Enter Clinic Email to Continue")
            return
        }
        guard  let mobile = self.mobileNumberTextField.text , !mobile.isEmpty else {
            showToast(msg: "Enter Mobile Number to Continue")
            return
        }

        guard let address = self.addressTextField.text, !address.isEmpty else {
            showToast(msg: "Enter Address to Continue")
            return
        }
        guard let postal = self.postalCode.text , !postal.isEmpty else {
            showToast(msg: "Enter Postal Code to Continue")
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.CompleteRegistrationTableViewController) as! CompleteRegistrationTableViewController
        vc.firstName = firstName
        vc.lastName = lastName
        vc.personalEmail = personalEmail
        vc.password = "password"
        vc.confirmPasswd = "confirmPasswd"
        vc.clinicName = clinicName
        vc.clinicEmail = clinicEmail
        vc.countryCode = self.countryCode ?? ""
        vc.phoneNumber = mobile
        vc.address = address
        vc.lat = self.dlat ?? 0.0
        vc.long = self.dlon ?? 0.0
        vc.pincode = postal
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}




extension RegisterPersonalTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }else{
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("FaqHeaderView", owner: self, options: nil)?.first as? FaqHeaderView
        if section == 1{
        headerView?.titleLbl.text = "Clinic Details"
        }else{
            headerView?.titleLbl.text = "Doctor Details"
        }
        headerView?.titleLbl.textColor = .AppBlueColor
        headerView?.plusLbl.isHidden = true
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        
        return headerView
    }
   override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor =  .clear
        return view
    }
}


extension RegisterPersonalTableViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.countryCodeTextField{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListController") as! CountryListController
            self.present(vc, animated: true, completion: nil)
            vc.searchCountryCode = { code in
                self.countryCode = code
                let country = Common.getCountries()
                for eachCountry in country {
                    if code == eachCountry.code {
                        self.countryCode = eachCountry.dial_code
                        let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                        self.countryImage.image = myImage
                        textField.text = eachCountry.dial_code
                       
                    }
                }
            }
            return false
        }else if textField == self.addressTextField{
            self.googlePlacesHelper?.getGoogleAutoComplete(completion: { (place) in
                  self.dAddress = place.formattedAddress ?? ""
                    textField.text   = place.formattedAddress ?? ""
                  self.dlat = place.coordinate.latitude
                  self.dlon = place.coordinate.longitude
              })
            return false
        }
        return true
    }
    
    
}

extension RegisterPersonalTableViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch String(describing: modelClass) {
        case model.type.CardSuccess:
            let data = dataDict as? CardSuccess
            showToast(msg: data?.message ?? "")
            self.callNextPage()
            break
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        showToast(msg: error.localizedDescription)
    }
    
    
}
