//
//  VerifyNumVC.swift
//  MiDokter User
//
//  Created by AppleMac on 15/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class VerifyNumVC: UIViewController {

    
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var thirdField: UITextField!
    @IBOutlet weak var fourthField: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var enteredOTP : String = ""
//    var mobileVerifyData: OTPMobile?
    var mobileNumber : Int = 0
    var otp : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    func initialLoads(){
        self.setupFont()
        self.setupAction()
        self.setupView()
        self.setupDelegate()
    }
    
    func setupAction(){
        self.backBtn.addTap {
            self.popOrDismiss(animation: true)
        }
        
        self.continueBtn.addTap {
            if (self.otp ?? 0000) == Int(self.enteredOTP){
//                if self.mobileVerifyData?.success ?? false{
                    var login : verifyLogin = verifyLogin()
                    login.mobile = self.mobileNumber
                    login.otp = self.otp
                    self.LoginApi(mobileNum: login)
                     
//                }
            }else{
                showToast(msg: "Enter Valid OTP")
                [self.firstField,self.secondField,self.thirdField,self.fourthField].forEach { (textfield) in
                    textfield?.text = ""
                }
            }
        }
    }
    
    func setupView(){
        self.contentLbl.text = "We just send 4 digit code to \(self.mobileNumber) , OTP is \(otp)"
    }
    
    func setupFont(){
        Common.setFont(to: self.firstField)
        Common.setFont(to: self.secondField)
        Common.setFont(to: self.thirdField)
        Common.setFont(to: self.fourthField)
        Common.setFont(to: self.contentLbl, isTitle: true, size: 20)
        Common.setFont(to: self.continueBtn)
        
    }
}

extension VerifyNumVC: UITextFieldDelegate {
    
    func setupDelegate(){
        self.fourthField.delegate = self
        self.secondField.delegate = self
        self.thirdField.delegate = self
        self.firstField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count >= 1 {
            switch textField {
                case firstField:
                    secondField.becomeFirstResponder()
                case secondField:
                    thirdField.becomeFirstResponder()
                case thirdField:
                    fourthField.becomeFirstResponder()
                case fourthField:
                    fourthField.resignFirstResponder()
                    self.view.endEditing(true)
                    enteredOTP = firstField.text! + secondField.text! + thirdField.text! + fourthField.text!
                
                default:
                    break
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}



//Api calls
extension VerifyNumVC : PresenterOutputProtocol{
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
    
    func LoginApi(mobileNum : verifyLogin){
     
        var params = [String:Any]()
        params.updateValue(self.mobileNumber.description, forKey: "mobile")
        params.updateValue(otp.description , forKey: "otp")
        params.updateValue("ios", forKey: "device_type")
        params.updateValue(deviceTokenString, forKey: "device_token")
        params.updateValue(UUID().uuidString, forKey: "device_id")
        params.updateValue(appClientId, forKey: "client_id")
        params.updateValue(appSecretKey, forKey: "client_secret")
        params.updateValue("otp", forKey: "grant_type")
        
        
        
        self.presenter?.HITAPI(api: Base.verify_otp.rawValue, params: params, methodType: .POST, modelClass: MobileVerifyModel.self, token: false)
    }
}
