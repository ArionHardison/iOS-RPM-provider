//
//  SignInMobileViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class SignInMobileViewController: UIViewController {

    @IBOutlet weak var textFieldCountryCode: HoshiTextField!
    @IBOutlet weak var textFieldMobile: HoshiTextField!
    @IBOutlet weak var buttonUsingEmail: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var signUp: UIButton!
    
    var countryCode :String?
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldCountryCode.delegate = self
        let country = Common.getCountries()
        for eachCountry in country {
            if "US" == eachCountry.code {
                self.countryCode = eachCountry.dial_code
                self.textFieldCountryCode.text = eachCountry.dial_code
                let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                self.countryImage.image = myImage
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func usingEmailAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignInEmailViewController, animation: true)
//        self.push(id: Storyboard.Ids.RegisterPersonalTableViewController, animation: true)

    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        guard  let mobile = self.textFieldMobile.text, !mobile.isEmpty else {
            showToast(msg: "Please Enter Mobile Number")
            return
        }
        guard  let countryCode = self.textFieldCountryCode.text, !countryCode.isEmpty else {
            showToast(msg: "Please Enter Mobile Number")
            return
        }
//        let cc = countryCode.replacingOccurrences(of: "+", with: "", options: NSString.CompareOptions.literal, range:nil)
        let phoneNumber = (self.countryCode ?? "+1") + mobile
        var parms = [String:Any]()
        parms.updateValue(phoneNumber, forKey: "mobile")
        self.presenter?.HITAPI(api: Base.generateOTP.rawValue, params: parms, methodType: .POST, modelClass: OTPMobile.self, token: false)
        self.loader.isHidden = false

    }
    

}


extension SignInMobileViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHideInMainThread(true)
        switch String(describing: modelClass) {
                    case model.type.OTPMobile:
                        guard let data = dataDict as? OTPMobile else { return }
                        if data.otp != nil || data.otp != 0{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyNumVC") as! VerifyNumVC
                            vc.mobileNumber = (self.textFieldCountryCode.text ?? "") + (self.textFieldMobile.text ?? "")
                            vc.otp = data.otp ?? 0
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            showToast(msg: data.message ?? "")
                        }
                        break
                        
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        showToast(msg: error.localizedDescription)
        self.loader.isHideInMainThread(true)
    }
    
    
}


extension SignInMobileViewController : UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textFieldCountryCode{
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
        }
        return true
    }
    
}
