//
//  ChangePasswordViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPassTxt: HoshiTextField!
    @IBOutlet weak var newPassTxt: HoshiTextField!
    @IBOutlet weak var confirPassTxt: HoshiTextField!
    @IBOutlet weak var changepassBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
    }

    func setupAction(){
        self.changepassBtn.addTap {
            if self.validation(){
                var changepass = ChangePassReq()
                changepass.current_password = self.oldPassTxt.getText
                changepass.password = self.newPassTxt.getText
                changepass.password_confirmation = self.newPassTxt.getText
                self.changePassApi(data: changepass)
            }
        }
    }
    
    func validation() -> Bool{
        if self.oldPassTxt.getText.isEmpty{
            showToast(msg: "Please Enter your current password")
            return false
        }else  if self.newPassTxt.getText.isEmpty{
            showToast(msg: "Please Enter New password")
            return false
        }else  if self.confirPassTxt.getText.isEmpty{
            showToast(msg: "Please Enter Confirm password")
            return false
        }else if self.newPassTxt.getText != self.confirPassTxt.getText{
            showToast(msg: "New and Confirm Password not matching")
            return false
        }else {
            return true
        }
    }
    
}

extension ChangePasswordViewController {
    func intialLoads() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = ""
        self.setupAction()
    }

}


//Api calls
extension ChangePasswordViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.CommonModel:
                let data = dataDict as? CommonModel
                if (data?.status ?? false){
                    self.popOrDismiss(animation: true)
                }
                showToast(msg: data?.message ?? "")
                
                break
            
            default: break
        
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func changePassApi(data : ChangePassReq){
        self.presenter?.HITAPI(api: Base.changePassword.rawValue, params: convertToDictionary(model: data), methodType: .POST, modelClass: CommonModel.self, token: true)
    }
}
