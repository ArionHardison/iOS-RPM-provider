//
//  AppointmentDetailsViewController.swift
//  Project
//
//  Created by Hari Haran on 03/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class AppointmentFeedBackViewController: UITableViewController {
    
    @IBOutlet weak var doctorImg: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var labelHospitalName: UILabel!
    @IBOutlet weak var labelBookefor: UILabel!
    @IBOutlet weak var labelPatientName: UILabel!
    @IBOutlet weak var labelSchedule: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusResponse: UILabel!
    @IBOutlet weak var labelShare: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var consultedText: HoshiTextField!
    @IBOutlet weak var commentsText: UITextView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
//    var visitedDetail : Previous = Previous()
    var appoitments = All_appointments()
    var isFromVisited : Bool = false
    var likedStatus : String = ""
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupData()
    }
    
}

//MARK: View Setups
extension AppointmentFeedBackViewController {
    
    private func initialLoads() {
        setupNavigationBar()
        setTextFonts()
        self.doctorImg.makeRoundedCorner()
        self.setupAction()
        self.ratingView.minRating = 1
        self.ratingView.maxRating = 5
        self.ratingView.rating = 3
        self.ratingView.tintColor = UIColor.systemYellow
    }
    
    private func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Appointment Details"
    }
    
    private func setTextFonts() {
        
        Common.setFontWithType(to: doctorName, size: 18, type: .meduim)
        
        Common.setFontWithType(to: labelDesignation, size: 14, type: .regular)
        Common.setFontWithType(to: labelHospitalName, size: 12, type: .light)
        Common.setFontWithType(to: labelBookefor, size: 16, type: .meduim)
        Common.setFontWithType(to: labelPatientName, size: 14, type: .meduim)
        Common.setFontWithType(to: labelSchedule, size: 16, type: .meduim)
        Common.setFontWithType(to: labelDate, size: 14, type: .meduim)
        Common.setFontWithType(to: labelCategory, size: 10, type: .light)
        Common.setFontWithType(to: labelStatus, size: 16, type: .meduim)
        Common.setFontWithType(to: labelStatusResponse, size: 14, type: .meduim)
        Common.setFontWithType(to: labelShare, size: 14, type: .regular)
        Common.setFontWithType(to: likeButton, size: 18, type: .regular)
        Common.setFontWithType(to: dislikeButton, size: 18, type: .regular)
        Common.setFontWithType(to: consultedText, size: 16, type: .regular)
        Common.setFontWithType(to: commentsText, size: 16, type: .regular)
        Common.setFontWithType(to: SubmitButton, size: 16, type: .meduim)
    }
    
    
    func setupData(){
        
//         let data : Visited_doctors = self.visitedDetail
          
        self.doctorImg.setURLImage(self.appoitments.patient?.profile?.profile_pic ?? "")
        self.doctorName.text = "\(self.appoitments.patient?.first_name ?? "") \(self.appoitments.patient?.last_name ?? "")".capitalized
        self.labelCategory.text = "\(self.appoitments.patient_id ?? 0)".uppercased()
        self.labelHospitalName.text = "\(self.appoitments.patient?.profile?.age ?? "") Years,\(self.appoitments.patient?.profile?.gender ?? "")".capitalized
        self.labelPatientName.text = "\(self.appoitments.patient?.appointments?.first?.booking_for ?? "")"
        self.labelDate.text = dateConvertor(self.appoitments.scheduled_at ?? "", _input: .date_time, _output: .DMY_Time)
        if self.appoitments.status == "CHECKEDOUT"{
            self.labelStatusResponse.text = "CONSULTED"
        }else{
        self.labelStatusResponse.text = self.appoitments.status ?? ""
        }
        
        
    }
    
    
    func setupAction(){
        
        let likeImg = UIImage(named: "Like-1")
        let disLikeImg = UIImage(named: "dislike-1")
        let normalLikeImg = UIImage(named: "like")
        let normalDisLikeImg = UIImage(named: "dislike")

        
        self.likeButton.addTap {
            self.likeButton.setImage(likeImg, for: .normal)
            self.dislikeButton.setImage(normalDisLikeImg, for: .normal)

            self.likedStatus = "LIKE"
        }
        
        self.dislikeButton.addTap {
            
            self.likeButton.setImage(normalLikeImg, for: .normal)
            self.dislikeButton.setImage(disLikeImg, for: .normal)
//            self.likeButton.backgroundColor = UIColor.clear
//            self.dislikeButton.backgroundColor = UIColor.AppBlueColor
            self.likedStatus = "DISLIKE"
        }
        
        self.SubmitButton.addTap {
            if validation(){
                var params = [String:Any]()
                params.updateValue(self.commentsText.text ?? "", forKey: "comments")
                params.updateValue(self.likedStatus, forKey: "experiences")
                params.updateValue(self.appoitments.hospital?.id ?? 0, forKey: "hospital_id")
                params.updateValue(self.consultedText.getText, forKey: "visited_for")
                params.updateValue("\(self.ratingView.rating)", forKey: "rating")
                params.updateValue("Rating Review", forKey: "title")
                params.updateValue(self.appoitments.patient_id ?? 0, forKey: "patient_id")
                params.updateValue(self.appoitments.id ?? 0, forKey: "appointment_id")
                self.presenter?.HITAPI(api: Base.updateFeedback.rawValue, params: params, methodType: .POST, modelClass: UpdateFeedBackModel.self, token: true)
                self.loader.isHidden = false
            }
        }
        
        func validation() -> Bool{
            if self.consultedText.getText.isEmpty{
                showToast(msg: "Enter consultant detail")
                return false
            }else if (self.commentsText.text ?? "").isEmpty{
                showToast(msg: "Please Enter Your Comments")
                return false
            }else if self.likedStatus.isEmpty{
                showToast(msg: "Please Select Like or DisLike option")
                return false
            }else{
                return true
            }
        }
        
    }
   
    
}

//Api calls
extension AppointmentFeedBackViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.UpdateFeedBackModel:
                self.loader.isHideInMainThread(true)
                let data = dataDict as? UpdateFeedBackModel
                showToast(msg: data?.message ?? "")
                self.navigationController?.popViewController(animated: true)
                break
            
            default:
                break
            
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHideInMainThread(true)
        showAlert(message: error.localizedDescription)
        
    }
    

    }
    
    

