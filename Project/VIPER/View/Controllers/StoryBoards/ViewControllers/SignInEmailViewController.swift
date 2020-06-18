//
//  SignInEmailViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class SignInEmailViewController: UIViewController {

    @IBOutlet weak var buttonUsingMobile: UIButton!
    @IBOutlet weak var emailTxt: HoshiTextField!
    @IBOutlet weak var passwordTxt: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

   
    @IBAction func usingMobileAction(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignInMobileViewController, animation: true)
    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        if self.validation(){
            var login = LoginReq()
            login.email = self.emailTxt.getText
            login.password = self.passwordTxt.getText
            self.loginApi(logindata: login)
        }
    }
    
    func validation() -> Bool{
        let email : String = self.emailTxt.getText
        let password : String = self.passwordTxt.getText
        
        if email.isEmpty || !email.isValidEmail(){
            showToast(msg: "Enter Valid EmailId")
            return false
        }else if password.isEmpty{
            showToast(msg: "Password should not be empty")
            return false
        }else {
            return true
        }
    }
}

//Api calls
extension SignInEmailViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.MobileVerifyModel:
                let data = dataDict as? MobileVerifyModel
                UserDefaultConfig.Token = data?.token ?? ""
                print("DataToken",UserDefaultConfig.Token)
                self.push(id: Storyboard.Ids.DashBoardViewController, animation: true)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func loginApi(logindata : LoginReq){
        self.presenter?.HITAPI(api: Base.loginWithEmail.rawValue, params: convertToDictionary(model: logindata), methodType: .POST, modelClass: MobileVerifyModel.self, token: false)
    }
}
