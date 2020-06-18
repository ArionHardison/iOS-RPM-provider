//
//  EditProfileTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var buttonChangePassword : UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelFirstName: HoshiTextField!
    @IBOutlet weak var labelLastName: HoshiTextField!
    @IBOutlet weak var labelQualification: HoshiTextField!
    @IBOutlet weak var labelMobileNum: HoshiTextField!
    @IBOutlet weak var labelEmail: HoshiTextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var editProfileImgBtn: UIButton!
    
    
    var isImageAdded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.setupData()
        self.setupAction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
    }
    
    func setupData(){
        if let data : ProfileEntity = profile{
            self.profileImage.setURLImage(data.doctor?.doctor_profile?.profile_pic ?? "")
            self.labelFirstName.text = "\(data.doctor?.last_name ?? "")"
            self.labelLastName.text = "\(data.doctor?.last_name ?? "")"
            self.labelEmail.text = "\(data.doctor?.email ?? "")"
            self.labelMobileNum.text = "\(data.doctor?.mobile ?? "")"
        }
    }
    
    func setupAction(){
        
        self.profileImage.makeRoundedCorner()
        
        self.editProfileImgBtn.addTarget(self, action: #selector(chooseCoverPhoto), for: .touchUpInside)
        
        
        self.buttonSave.addTap {
            if self.validation(){
                var profile = profileUploadReq()
                profile.first_name = self.labelFirstName.getText
                profile.last_name = self.labelLastName.getText
                profile.specialities = self.labelQualification.getText
                profile.email = self.labelEmail.getText
                profile.mobile = self.labelMobileNum.getText
                self.updateProfile(data: profile)
            }
        }
    }
    
    
    @objc func chooseCoverPhoto(){
        self.showImage { (image) in
            if image != nil {
                self.isImageAdded = true
                self.profileImage.image = image
            }
        }
        
    }
    
    func validation() -> Bool{
        if self.labelFirstName.getText.isEmpty{
            showToast(msg: "Enter your firstname")
            return false
        }else  if self.labelLastName.getText.isEmpty{
            showToast(msg: "Enter your Lastname")
            return false
        }else  if self.labelEmail.getText.isEmpty || !(self.labelEmail.getText.isValidEmail()){
            showToast(msg: "Enter your Valid EmailId")
            return false
        }else if self.labelQualification.getText.isEmpty{
            showToast(msg: "select you speciality")
            return false
        }else if self.labelMobileNum.getText.isEmpty || !(self.labelMobileNum.getText.isPhoneNumber){
            showToast(msg: "Enter Valid mobile number ")
            return false
        }else {
            return true
        }
    }
    
}
extension EditProfileTableViewController {
    func intialLoads() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.editProfile.localize()
        self.buttonChangePassword.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
    }
    
    @IBAction func changePassword() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangePasswordViewController) as! ChangePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//Api calls
extension EditProfileTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                self.popOrDismiss(animation: true)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func updateProfile(data : profileUploadReq){
        let url = "\(Base.updateProfile.rawValue)"
        
        var uploadimgeData:Data = Data()
        
        if  let dataImg = self.profileImage.image?.jpegData(compressionQuality: 0.5) {
            uploadimgeData = dataImg
        }
        
        self.presenter?.IMAGEPOST(api: url, params: convertToDictionary(model: data) ?? ["":""], methodType: .POST, imgData: ["profile_pic":uploadimgeData], imgName: "profile_pic", modelClass: CommonModel.self, token: true)
    }
    
}
