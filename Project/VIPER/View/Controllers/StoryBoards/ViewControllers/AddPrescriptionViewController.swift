//
//  AddPrescriptionViewController.swift
//  MiDokter Pro
//
//  Created by Basha's MacBook Pro on 20/11/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class AddPrescriptionViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var labelUploadImage: UILabel!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var prescriptionImage = UIImage()
    var appoitmentID = Int()
    var prescriptionId = Int()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initatlLoads()

        // Do any additional setup after loading the view.
    }
    


}


extension AddPrescriptionViewController {
    
    private func initatlLoads(){
        self.backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        self.descriptionTextView.autocorrectionType = .no
        self.titleLabel.text = "Add Prescription"
        self.labelDescription.text = "Add Instruction for Prescription"
        self.labelUploadImage.text = "Upload Prescription Image"
        self.uploadImageView.isUserInteractionEnabled = true
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.addTarget(self, action: #selector(uploadAction(sender:)), for: .touchUpInside)
        self.uploadImageView.addTap {
            self.uploadPrescriptionImage()
        }
    }
    
     private func uploadPrescriptionImage(){
        self.showImage { (image) in
            self.prescriptionImage = image!
            self.uploadImageView.image = image
        }
    }
    
    
    @IBAction private func backAction(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func uploadAction(sender:UIButton){
        
        var params  = [String:Any]()
        params.updateValue(prescriptionId, forKey: "prescription")
        params.updateValue(self.descriptionTextView.text ?? "", forKey: "instruction")
        params.updateValue(appoitmentID, forKey: "id")
        let prescriptionData = self.prescriptionImage.pngData()!
   
        var imageData = [String:Data]()
        imageData.updateValue(prescriptionData, forKey: "prescription_image")
        self.presenter?.IMAGEPOST(api: Base.uploadPrescription.rawValue, params: params, methodType: .POST, imgData: imageData, imgName: "prescription_image", modelClass: UploadSuccess.self, token: true)
        self.loader.isHidden = false
        
    }
    
}

extension AddPrescriptionViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
        case model.type.UploadSuccess:
            let data = dataDict as? UploadSuccess
            showToast(msg: data?.message ?? "")
            self.loader.isHideInMainThread(true)
            self.dismiss(animated: true, completion: nil)
            break
        
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    
}



