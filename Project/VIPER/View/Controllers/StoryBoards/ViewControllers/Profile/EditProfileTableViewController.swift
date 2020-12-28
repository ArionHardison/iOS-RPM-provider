//
//  EditProfileTableViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 22/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper
import AVKit

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
    @IBOutlet weak var textfieldSpecialization: HoshiTextField!
    @IBOutlet weak var addVideoButton: UIButton!
    
    @IBOutlet weak var countryCodeTextField: HoshiTextField!
    @IBOutlet weak var viewSubscribedPlans: UIButton!
    @IBOutlet weak var consultationFeesTextField: HoshiTextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var playVideoButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var videoURL : NSURL?
    var videoData : NSData?
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    var speciality = [Speciality]()
    var isImageAdded : Bool = false
    var countryCode :String?
    var selectedCategory : String = ""
    var selectedCategoryID : Int = 0
    var isFromUpdate : Bool = false
//    var countryCode :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialLoads()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.setupData()
        self.setupAction()
        self.loader.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.setupData() .
        self.loader.isHidden = false
        let data : ProfileEntity = profile
        if data.doctor?.doctor_profile?.profile_video ?? "" != ""{
        let url = URL(string: "\(imageURL)\(data.doctor?.doctor_profile?.profile_video ?? "")")
        if url != nil{
            self.loader.isHidden = false
            self.videoURL = url as NSURL?
            self.addVideoButton.setTitle("", for: .normal)
            print(self.videoURL!)
            if let fileURL = self.videoURL {
                if let videoData = NSData(contentsOf: fileURL as URL) {
                       print(videoData.length)
//                    self.videoData = videoData
                  self.encodeVideo(videoURL: self.videoURL! as URL)
                   
                   }
               }
            do {
                let asset = AVURLAsset(url: self.videoURL! as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 2), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                self.profileImgView.image = thumbnail
                self.addVideoButton.setTitle("", for: .normal)
                self.playVideoButton.isHidden = false
                self.loader.isHideInMainThread(true)
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                self.loader.isHideInMainThread(true)
            }
        }else{
            self.loader.isHidden = true
        }
        }
    }
    
    func setupData(){
        let data : ProfileEntity = profile
            self.profileImage.setURLImage(data.doctor?.doctor_profile?.profile_pic ?? "")
            self.labelFirstName.text = "\(data.doctor?.first_name ?? "")"
            self.labelLastName.text = "\(data.doctor?.last_name ?? "")"
            self.labelEmail.text = "\(data.doctor?.email ?? "")"
            self.labelMobileNum.text = "\(data.doctor?.mobile ?? "")"
            self.countryCodeTextField.text = data.doctor?.country_code ?? ""
            self.textfieldSpecialization.text = "\(data.doctor?.doctor_profile?.speciality?.name ?? "")"
            self.selectedCategoryID = data.doctor?.doctor_profile?.speciality?.id ?? 0
            self.consultationFeesTextField.text = "\(data.doctor?.doctor_profile?.fees ?? 0)"

        
    }
    
    func setupAction(){
        
        self.profileImage.makeRoundedCorner()
        
        
        self.editProfileImgBtn.addTarget(self, action: #selector(chooseCoverPhoto), for: .touchUpInside)
        
//        self.textfieldSpecialization.isUserInteractionEnabled = false
        self.buttonSave.addTap {
            if self.validation(){
                var profile = profileUploadReq()
                profile.first_name = self.labelFirstName.getText
                profile.last_name = self.labelLastName.getText
                profile.specialities = self.selectedCategoryID
                profile.email = self.labelEmail.getText
                
                
                if self.labelMobileNum.getText.contains("+"){
                profile.mobile = self.labelMobileNum.getText
                }else{
                    showToast(msg: "Select Country Code")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListController") as! CountryListController
                    self.present(vc, animated: true, completion: nil)
                    vc.searchCountryCode = { code in
                        self.countryCode = code
                        let country = Common.getCountries()
                        for eachCountry in country {
                            if code == eachCountry.code {
                                self.countryCode = eachCountry.dial_code
                                self.labelMobileNum.text = (self.countryCode ?? "") + self.labelMobileNum.getText
                                profile.mobile =  self.labelMobileNum.getText
                            }
                        }
                    }
                }
                
                
                profile.country_code = self.countryCodeTextField.getText
                
                profile.fees = self.consultationFeesTextField.getText
                self.updateProfile(data: profile)
                self.isFromUpdate = true
                
            }
        }
    }
    
    @IBAction private func subscribedPlansAction(_sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SubscribedPlansViewController) as! SubscribedPlansViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        }else if self.labelMobileNum.getText.isEmpty {
            showToast(msg: "Enter Valid mobile number ")
            return false
        }else {
            return true
        }
    }
    
}
extension EditProfileTableViewController {
    func intialLoads() {
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: CommonModel.self, token: true)
        self.presenter?.HITAPI(api: Base.getSpeciality.rawValue, params: nil, methodType: .GET, modelClass: GetSpeciality.self, token: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.editProfile.localize()
        self.buttonChangePassword.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        self.countryCodeTextField.delegate = self
        self.textfieldSpecialization.delegate = self
        let country = Common.getCountries()
        for eachCountry in country {
            if "IN" == eachCountry.code {
                self.countryCode = eachCountry.dial_code
                self.countryCodeTextField.text = eachCountry.dial_code
            }
        }
        self.viewSubscribedPlans.addTarget(self, action: #selector(subscribedPlansAction(_sender:)), for: .touchUpInside)
        self.addVideoButton.addTarget(self, action: #selector(addVideo), for: .touchUpInside)
        if self.videoURL != nil {
            self.playVideoButton.isHidden = false
        }else{
            self.playVideoButton.isHidden = true
        }
        self.playVideoButton.addTarget(self, action: #selector(playVideoAction(_sender:)), for: .touchUpInside)
    }
    
    @IBAction private func playVideoAction(_sender:UIButton){
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: self.videoURL! as URL)
        playerVC.player = player
        self.present(playerVC, animated: true, completion: nil)
    }
    
    @IBAction func changePassword() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChangePasswordViewController) as! ChangePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func addVideo(){
        
        showVideo { (url) in
            self.videoURL = url
            print(self.videoURL!)
            if let fileURL = self.videoURL {
                if let videoData = NSData(contentsOf: fileURL as URL) {
                       print(videoData.length)
                    self.videoData = videoData
                   }
               }
            do {
                let asset = AVURLAsset(url: self.videoURL! as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                self.profileImgView.image = thumbnail
                self.addVideoButton.setTitle("", for: .normal)
                self.playVideoButton.isHidden = false
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
//        imagePickerController.sourceType = .savedPhotosAlbum
//            imagePickerController.delegate = self
//            imagePickerController.mediaTypes = ["public.movie"]
//            present(imagePickerController, animated: true, completion: nil)
    }


}

//Api calls
extension EditProfileTableViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHideInMainThread(true)
        switch String(describing: modelClass) {
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                if isFromUpdate{
                showToast(msg: data.message ?? "")
                }
                self.setupData()
                self.setupAction()
//                self.popOrDismiss(animation: true)
                break
        case model.type.GetSpeciality:
            guard  let data = dataDict as? GetSpeciality else {return}
            self.speciality = data.speciality ?? []
            break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHideInMainThread(true)
        showToast(msg: error.localizedDescription)
        
    }
    
    func updateProfile(data : profileUploadReq){
        let url = "\(Base.updateProfile.rawValue)"
        
        var uploadimgeData:Data = Data()
        var imageData = [String:Data]()
        
        if  let dataImg = self.profileImage.image?.pngData() {
            uploadimgeData = dataImg
        }
        var imageDataValue = [String:Data]()
        imageDataValue.updateValue(uploadimgeData, forKey: "profile_pic")
        if self.videoData != nil{
        imageDataValue.updateValue(self.videoData! as Data, forKey: "video")
        }
        
        self.presenter?.IMAGEPOST(api: url, params: convertToDictionary(model: data) ?? ["":""], methodType: .POST, imgData:imageDataValue , imgName: "profile_pic", modelClass: CommonModel.self, token: true)
        self.loader.isHidden = false
    }
    
}


extension EditProfileTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryCodeTextField{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListController") as! CountryListController
            self.present(vc, animated: true, completion: nil)
            vc.searchCountryCode = { code in
                self.countryCode = code
                let country = Common.getCountries()
                for eachCountry in country {
                    if code == eachCountry.code {
                        self.countryCode = eachCountry.dial_code
                        self.countryCodeTextField.text = eachCountry.dial_code
                       
                    }
                }
            }
            return false
        }else if textField == textfieldSpecialization{
            var category : [String] = []
            for categorie in self.speciality{
                category.append(categorie.name ?? "")
            }
            PickerManager.shared.showPicker(pickerData: category, selectedData: nil) { [weak self] (selectedType) in
                guard let self = self else {
                    return
                }
                self.textfieldSpecialization.text = selectedType
                for (index,category) in self.speciality.enumerated() {
                    if category.name == selectedType{
                        self.selectedCategoryID = self.speciality[index].id ?? 0
                        print(self.selectedCategory)
                    }
                }
                
                
            }
            return false
        }
        return true
    }
}


extension EditProfileTableViewController  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue]as? NSURL
        print(videoURL!)
        if let fileURL = videoURL {
            if let videoData = NSData(contentsOf: fileURL as URL) {
                   print(videoData.length)
                self.videoData = videoData
               }
           }
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            profileImgView.image = thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func encodeVideo(videoURL: URL){
        let avAsset = AVURLAsset(url: videoURL)
        let startDate = Date()
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)

        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("temp.mp4")?.absoluteString

        let docDir2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL

        let filePath = docDir2.appendingPathComponent("rendered-Video.mp4")
        deleteFile(filePath!)

        if FileManager.default.fileExists(atPath: myDocPath!){
            do{
                try FileManager.default.removeItem(atPath: myDocPath!)
            }catch let error{
                print(error)
            }
        }

        exportSession?.outputURL = filePath
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true

        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRange(start: start, duration: avAsset.duration)
        exportSession?.timeRange = range

        exportSession!.exportAsynchronously{() -> Void in
            switch exportSession!.status{
            case .failed:
                print("\(exportSession!.error!)")
            case .cancelled:
                print("Export cancelled")
            case .completed:
                let endDate = Date()
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful")
                print(exportSession?.outputURL ?? "")
               
            default:
                break
            }
        }
//        return ""
    }

    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else{
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }

}
