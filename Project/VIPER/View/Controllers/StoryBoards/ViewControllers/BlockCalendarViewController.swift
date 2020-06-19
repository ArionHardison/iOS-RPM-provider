//
//  BlockCalendarViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class BlockCalendarViewController: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonBlockCalendar: UIButton!
    @IBOutlet weak var textFieldToData: UITextField!
    @IBOutlet weak var textFieldToTime: UITextField!
    @IBOutlet weak var textFieldFromTime: UITextField!
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textViewReason: UITextView!
    @IBOutlet weak var fromDateBtn: UIButton!
    @IBOutlet weak var toDateBtn: UIButton!
    
    var fromDate : Date = Date()
    var toDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}

extension BlockCalendarViewController {
    func intialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.string.Cancel.localize(), style: .done, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.blockCalenar.localize()

        self.buttonCancel.addTarget(self, action: #selector(buttonCancelAction), for: .touchUpInside)

        self.setupAction()
    }
    
    func setupAction(){
        self.fromDateBtn.addTap {
            let view = DateTimePickerAlert.getView
            view.alertdelegate = self
            view.selectionOption = .from
            AlertBuilder().addView(fromVC: self , view).show()
        }
        self.toDateBtn.addTap {
            let view = DateTimePickerAlert.getView
            view.alertdelegate = self
            view.selectionOption = .to
            AlertBuilder().addView(fromVC: self , view).show()
        }
        
        self.buttonBlockCalendar.addTap {
            if self.validateion(){
                var blockreq = BlockReq()
                blockreq.from_date = self.textFieldFromDate.getText
                blockreq.to_date = self.textFieldToData.getText
                blockreq.reason = self.textViewReason.text
                self.blockAppointmentDetail(data: blockreq)
            }
        }
    }
    
    func validateion() -> Bool{
        if self.textFieldFromDate.getText.isEmpty{
            showToast(msg: "Please select From date for block")
            return false
        }else if self.textFieldToData.getText.isEmpty{
            showToast(msg: "Please select To date for block")
            return false
        }else if self.textViewReason.text.isEmpty{
            showToast(msg: "Write Reason from Block")
            return false
        }else{
            return true
        }
    }
    
    @IBAction func buttonCancelAction() {
        self.backButtonClick()
    }

}
extension BlockCalendarViewController : AlertDelegate{
    func selectedDate(selectionType: String, date: String, alertVC: UIViewController) {
            
    }
    
    func selectedDateTime(selectionType: DateselectionOption,date : Date, datestr: String, time: String, alertVC: UIViewController) {
        if selectionType == .from{
            self.textFieldFromDate.text = datestr
            self.textFieldFromTime.text = time
            self.fromDate = date
        }else if selectionType == .to{
            self.textFieldToData.text = datestr
            self.textFieldToTime.text = time
            self.toDate = date
        }
        
        if self.toDate.interval(ofComponent: .day, fromDate: self.fromDate) < 0{
            showToast(msg: "Please select valid from and to dates")
        }
    }
    
    func selectedTime(time: String, alertVC: UIViewController) {
        
    }
    
    
}


//Api calls
extension BlockCalendarViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                Log.rs("Response===> \(data)")
                showToast(msg: "Blocked successfully")
                self.popOrDismiss(animation: true)
                break
            
          
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
   
    
    func blockAppointmentDetail(data : BlockReq){
        
        let url = "\(Base.blockCalender.rawValue)"
        self.presenter?.HITAPI(api: url, params: convertToDictionary(model: data), methodType: .POST, modelClass: CommonModel.self, token: true)
    }
}
