//
//  IncomingRequestController.swift
//  GoJekProvider
//
//  Created by Rajes on 07/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

protocol IncomingRequestDelegate: class {
    
    func acceptButtonAction(_ sender: UIButton)
    func rejectButtonAction(_ sender: UIButton)
    func finishButtonAction()
}

class IncomingRequestController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var serviceDetailsLabel: UILabel!
    
    @IBOutlet weak var rejectButton:UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var deliveryView: UIView!
    
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelWeightValue: UILabel!
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: Progressview!
    
    //MARK: - LocalVariable
    weak var delegate: IncomingRequestDelegate?
    
    var requestData : ChatRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defalutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AudioManager.share.startPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioManager.share.stopSound()
    }
}

//MARK: - LocalMethod

extension IncomingRequestController {
    
    func defalutSetup() {
        
        containerView.setCornerRadiuswithValue(value: 5)
        progressView.delegate = self
        progressView.timeLeftValue = Double(60)
        view.isOpaque = false
        
//        let requestDetail = checkResponseDetail?.requests?.first?.request
        
        progressView.timeLeftValue = Double(60)
//        let status = ActiveStatus(rawValue: checkResponseDetail?.serviceStatus ?? String.Empty) ?? .none
     
             deliveryView.isHidden = true
//            let serviceDetail = requestDetail?.service
            serviceDetailsLabel.text = "(serviceDetail?.service_category?.service_category_name ?? String.Empty) + "
        
        DispatchQueue.main.async {
            self.rejectButton.setCornorRadius()
            self.acceptButton.setCornorRadius()
        }
        
        setCustomColor()
        setCustomFont()
        setCustomLocalization()
    }
    
    private func setCustomColor() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        serviceDetailsLabel.textColor = .lightGray
        labelWeightValue.textColor = .lightGray
        rejectButton.setTitleColor(.white, for: .normal)
        rejectButton.backgroundColor = UIColor(named: "CustomRedColor")
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = .AppBlueColor
    }
    
    private func setCustomFont() {
//   [self.serviceDetailsLabel,self.requestTitleLabel,self.serviceTypeLabel,self.labelWeightValue,self.labelWeight].forEach { (label) in
//            //Common.setFont(to: label)
//        }
    }
    
    private func setCustomLocalization() {
        
        serviceTypeLabel.text = (self.requestData?.request?.patient?.first_name ?? "") + " " + (self.requestData?.request?.patient?.last_name ?? "")
        self.serviceDetailsLabel.text = self.requestData?.request?.messages ?? ""
    }
}

//MARK: - IBAction

extension IncomingRequestController {
    
    @IBAction func rejectAction(_ sender: UIButton) {
         self.AcceptReject(request_id: (self.requestData?.request?.id ?? 0).description, status: "CANCELLED")
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
         self.AcceptReject(request_id: (self.requestData?.request?.id ?? 0).description, status: "ACCEPTED")
    }
}

//MARK: - ProgressViewDelegate

extension IncomingRequestController: ProgressViewDelegate {
    
    func finishedProgress() {
        delegate?.finishButtonAction()
        dismiss(animated: true, completion: nil)
    }
}

extension UIView{
    
    //Set view corner radius with given value
    func setCornerRadiuswithValue(value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height/8
        self.clipsToBounds = true
    }
}
extension UIButton {
    
    //Set cornor radius based on width or height
    func setCornorRadius() {
        self.layer.cornerRadius = self.frame.height/8
        self.layer.masksToBounds = true
}

}

//Api calls
extension IncomingRequestController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.ChatAcceptRejectEntity:
             guard let data = dataDict as? ChatAcceptRejectEntity else { return }
             if (data.message ?? "") == "Cancel Request Successfully"{
                self.delegate?.rejectButtonAction(self.rejectButton)
             }else{
                self.delegate?.acceptButtonAction(self.acceptButton)
             }
             self.dismiss(animated: true, completion: nil)
             break
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func AcceptReject(request_id : String, status : String){
        self.presenter?.HITAPI(api: Base.updateStatus.rawValue, params: ["request_id":request_id,"status":status], methodType: .POST, modelClass: ChatAcceptRejectEntity.self, token: true)
    }
}


