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
        if self.nameTxt.getText.isEmpty{
            showToast(msg: "Enter the Name")
            return false
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
    
    func populateData(){
         let data : Patient = self.Patients
            self.nameTxt.text = data.first_name ?? ""
            self.profileImg.setURLImage(data.profile?.profile_pic ?? "")
            self.profileImg.makeRoundedCorner()
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
            var patient = PatientModelReq()
            patient.address = self.stateTXT.getText
            patient.blood_group = self.bloodGrpTXT.getText
            patient.city = self.cityTXT.getText
            patient.dob = self.bdyTXT.getText
            patient.email = self.emailTxt.getText
            patient.other_id = self.otherTXT.getText
            patient.phone = self.primaryNum.getText
            patient.postal_code = self.pincodeTXT.getText
            patient.secondary_mobile = self.secondryNum.getText
           
            self.editPatient(data: patient)
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
    
    func editPatient(data : PatientModelReq){
        
        let url = "\(Base.patient.rawValue)/\(self.Patients.id?.description ?? "")"
        
        var uploadimgeData:Data = Data()
        
        if  let dataImg = self.profileImg.image?.jpegData(compressionQuality: 0.5) {
            uploadimgeData = dataImg
        }
        
        self.presenter?.IMAGEPOST(api: url, params: convertToDictionary(model: data) ?? ["":""], methodType: .PUT, imgData: ["profile_pic":uploadimgeData], imgName: "profile_pic", modelClass: CommonModel.self, token: true)
    }
    
    func deletePatient(id : String){
        
        let url = "\(Base.patient.rawValue)/\(id)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .DELETE, modelClass: CommonModel.self, token: true)
    }
}
