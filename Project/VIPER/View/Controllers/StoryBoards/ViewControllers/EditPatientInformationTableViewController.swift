//
//  EditPatientInformationTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 28/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class EditPatientInformationTableViewController: UITableViewController {

    
    @IBOutlet weak var nameTxt: HoshiTextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var IDTXT: HoshiTextField!
    @IBOutlet weak var secondryNum: HoshiTextField!
    @IBOutlet weak var primaryNum: HoshiTextField!
    @IBOutlet weak var emailTxt: HoshiTextField!
    @IBOutlet weak var sexTxt: HoshiTextField!
    @IBOutlet weak var bdyTXT: HoshiTextField!
    @IBOutlet weak var bloodGrpTXT: HoshiTextField!
    @IBOutlet weak var stateTXT: HoshiTextField!
    @IBOutlet weak var localityTXT: HoshiTextField!
    @IBOutlet weak var pincodeTXT: HoshiTextField!
    @IBOutlet weak var cityTXT: HoshiTextField!
    @IBOutlet weak var otherTXT: HoshiTextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editProfileImgBtn: UIButton!
    
    var Patients : Patient = Patient()
    
    var isImageAdded : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
        self.setupAction()
        self.populateData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupAction(){
        self.deleteBtn.addTap {
            self.deletePatient(id: self.Patients.id?.description ?? "")
        }
        
        self.editProfileImgBtn.addTarget(self, action: #selector(chooseCoverPhoto), for: .touchUpInside)
        
    }
    
    func validation() -> Bool{
        if !self.nameTxt.getText.isEmpty{
//            let pattern = "/^[A-Z][a-z]{0,19}[\\s,][A-Z][a-z]{0,19}$/"
//            let predicate = NSPredicate(format: "self MATCHES [c] %@", pattern)
            if self.nameTxt.getText.contains(" ") {
                print("Valid")
                return true
            }
            else {
                print("Invalid")
                showToast(msg: "Enter the First Name & Last Name")
                return false
            }
//
        }else if self.IDTXT.getText.isEmpty{
            showToast(msg: "Enter the PatientID")
            return false
        }else if self.bloodGrpTXT.getText.isEmpty{
            showToast(msg: "Enter the BloodGroup")
            return false
        }else if self.primaryNum.getText.isEmpty{
            showToast(msg: "Enter Primary mobile number")
            return false
        }else if self.secondryNum.getText.isEmpty{
            showToast(msg: "Enter secondry Mobile number")
            return false
        }else if self.emailTxt.getText.isEmpty{
            showToast(msg: "Enter the Email ID")
            return false
        }else if self.sexTxt.getText.isEmpty{
            showToast(msg: "Enter the Gender")
            return false
        }else if self.bdyTXT.getText.isEmpty{
            showToast(msg: "Enter the Date of Birth")
            return false
        }else if self.pincodeTXT.getText.isEmpty{
            showToast(msg: "Enter the Postal code")
            return false
        }else if self.stateTXT.getText.isEmpty{
            showToast(msg: "Enter the Address")
            return false
        }else if self.cityTXT.getText.isEmpty{
            showToast(msg: "Enter the City")
            return false
        }else if self.otherTXT.getText.isEmpty{
            showToast(msg: "Enter Other ID detail")
            return false
        }else{
            return true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.profileImg.makeRoundedCorner()

    }
    
    func populateData(){
         let data : Patient = self.Patients
            self.nameTxt.text = (data.first_name ?? "") + " " + (data.last_name ?? "")
            self.profileImg.setURLImage(data.profile?.profile_pic ?? "")
            self.IDTXT.text = data.id?.description ?? ""
            self.bloodGrpTXT.text = data.profile?.blood_group ?? ""
            self.primaryNum.text = data.phone ?? ""
            self.emailTxt.text = data.email ?? ""
            self.sexTxt.text = data.profile?.gender ?? ""
            self.bdyTXT.text = data.profile?.dob ?? ""
            self.stateTXT.text = data.profile?.address ?? ""
            self.cityTXT.text = data.profile?.city ?? ""
            self.localityTXT.text = data.profile?.locality ?? ""
            self.pincodeTXT.text = data.profile?.postal_code ?? ""
        }
    
}

extension EditPatientInformationTableViewController {
    func initialLoads(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.doneAction))

        self.navigationItem.title = Constants.string.patientInformation.localize()

    }
    
    @objc func doneAction(){
        if self.validation(){
            var imageData = [String:Data]()
            let imageValue = (self.profileImg.image?.pngData())!
            imageData.updateValue(imageValue, forKey: "profile_pic")
            var params = [String:Any]()
            params.updateValue(self.stateTXT.getText, forKey: "address")
            params.updateValue(self.bloodGrpTXT.getText, forKey: "blood_group")
            params.updateValue(self.cityTXT.getText, forKey: "city")
            params.updateValue(self.bdyTXT.getText, forKey: "dob")
            params.updateValue(self.emailTxt.getText, forKey: "email")
            params.updateValue(self.otherTXT.getText, forKey: "other_id")
            params.updateValue(self.primaryNum.getText, forKey: "phone")
            params.updateValue(self.pincodeTXT.getText, forKey: "postal_code")
            params.updateValue(self.secondryNum.getText, forKey: "secondary_mobile")
            let fullNameArr = self.nameTxt.getText.components(separatedBy: " ")
            let firstName = fullNameArr[0]
            let lastName = fullNameArr[1]
            params.updateValue(firstName, forKey: "first_name")
            params.updateValue(lastName, forKey: "last_name")
            
            
            let url = "\(Base.updatePatient.rawValue)/\(self.Patients.id ?? 0)"
            self.presenter?.IMAGEPOST(api: url, params: params, methodType: .POST, imgData: imageData, imgName: "profile_pic", modelClass: CommonModel.self, token: true)
            print(url,params)
           
//            self.editPatient(data: patient)
        }
    }
    
    @objc func chooseCoverPhoto(){
        self.showImage { (image) in
            if image != nil {
                self.isImageAdded = true
                self.profileImg.image = image
            }
        }
        
    }
}


//Api calls
extension EditPatientInformationTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.AppointmentModel:
                guard let data = dataDict as? AppointmentModel else { return }
                break
            
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                print("Datatata",data)
                self.navigationController?.popToRootViewController(animated: true)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        showToast(msg: "Something went wrong, Please try after some time")
    }
    
    
    func deletePatient(id : String){
        
        let url = "\(Base.patient.rawValue)/\(id)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .DELETE, modelClass: CommonModel.self, token: true)
    }
}


extension EditPatientInformationTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.bdyTXT{
            return false
        }
        return true
    }
}
