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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func usingEmailAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignInEmailViewController, animation: true)

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
        let cc = countryCode.replacingOccurrences(of: "+", with: "", options: NSString.CompareOptions.literal, range:nil)
        let phoneNumber = cc + mobile
        var parms = [String:Any]()
        parms.updateValue(phoneNumber, forKey: "mobile")
        self.presenter?.HITAPI(api: Base.generateOTP.rawValue, params: parms, methodType: .POST, modelClass: OTPMobile.self, token: false)

    }
    

}


extension SignInMobileViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
                    case model.type.OTPMobile:
                        guard let data = dataDict as? OTPMobile else { return }
                        if data.otp != nil || data.otp != 0{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyNumVC") as! VerifyNumVC
                            vc.mobileNumber = Int(self.textFieldMobile.text ?? "") ?? 0
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
    }
    
    
}
