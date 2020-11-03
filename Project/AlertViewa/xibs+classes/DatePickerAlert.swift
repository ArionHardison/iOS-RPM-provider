//
//  DatePickerAlert.swift
//  MiDokter User
//
//  Created by AppleMac on 16/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    func selectedDate(selectionType : String , date : String,alertVC : UIViewController)
    func selectedDateTime(selectionType : DateselectionOption ,date : Date ,datestr : String,time : String,alertVC : UIViewController)
    func selectedTime(time : String,alertVC : UIViewController)
}

class DatePickerAlert : UIView {
    
    @IBOutlet weak var TitleLbl : UILabel!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var datepicker : UIDatePicker!
    
    
    var alertdelegate : AlertDelegate!
    var alertVC : UIViewController = UIViewController()
    var selectedDate : String = ""
    var selectedTime : String = ""
    
    
    override func initView(view : UIView , vc : UIViewController) -> UIView {
        self.alertVC = vc
        self.setupView(view: view)
        self.submitBtn.setCorneredElevation()
       
        self.datepicker.minimumDate = Date()
        
        self.setupAction()
        return self
    }
    
    
    
    
    override func deInitView(view : UIView , vc : UIViewController) -> UIView {
        return self
    }
    
    func setupAction(){
        
        self.cancelBtn.addTap {
             self.alertVC.dismiss(animated: false, completion: nil)
        }
        
        self.submitBtn.addTap{
            guard let delegate = self.alertdelegate else {
                self.alertVC.dismiss(animated: false, completion: nil)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            self.selectedDate = dateFormatter.string(from: self.datepicker.date)
            
           
            
            
            self.alertdelegate.selectedDate(selectionType: "", date: dateFormatter.string(from: self.datepicker.date), alertVC: self.alertVC)
             self.alertVC.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupView(view : UIView){
        view.addSubview(self)
        view.bringSubviewToFront(self)
        let height =  self.frame.height < 150.0 ? 150 : self.frame.height
        self.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        self.transform = CGAffineTransform(translationX: 0, y: 0)
        
        self.backgroundColor = .white
        
        self.setCorneredElevation()
    }
    
    
    
    //MARK: Register xib view
    class var getView : DatePickerAlert {
        return UINib(nibName: "DatePickerAlert", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! DatePickerAlert
    }
}


class TimePickerAlert : UIView {
    
    @IBOutlet weak var TitleLbl : UILabel!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var timepicker : UIDatePicker!
    
    
    var alertdelegate : AlertDelegate!
    var alertVC : UIViewController = UIViewController()
    var selectedtime : String = ""
    var schduleDate : Date = Date()
    
    override func initView(view : UIView , vc : UIViewController) -> UIView {
        self.alertVC = vc
        self.setupView(view: view)
        self.submitBtn.setCorneredElevation()
        if schduleDate.interval(ofComponent: .day, fromDate: Date()) == 0{
            self.timepicker.minimumDate = Date()
        }
        
        self.setupAction()
        return self
    }
    
    
    
    
    override func deInitView(view : UIView , vc : UIViewController) -> UIView {
        return self
    }
    
    func setupAction(){
        
        self.cancelBtn.addTap {
            self.alertVC.dismiss(animated: false, completion: nil)
        }
        
        self.submitBtn.addTap{
            guard let delegate = self.alertdelegate else {
                self.alertVC.dismiss(animated: false, completion: nil)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            self.selectedtime = dateFormatter.string(from: self.timepicker.date)
            
            
            
            self.alertdelegate.selectedTime(time: self.selectedtime, alertVC: self.alertVC)
            self.alertVC.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupView(view : UIView){
        view.addSubview(self)
        view.bringSubviewToFront(self)
        let height =  self.frame.height < 150.0 ? 150 : self.frame.height
        self.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        self.transform = CGAffineTransform(translationX: 0, y: 0)
        
        self.backgroundColor = .white
        
        self.setCorneredElevation()
    }
    
    
    
    //MARK: Register xib view
    class var getView : TimePickerAlert {
        return UINib(nibName: "DatePickerAlert", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! TimePickerAlert
    }
}


enum DateselectionOption{
    case from
    case to
    case none
}

class DateTimePickerAlert : UIView {
    
    @IBOutlet weak var TitleLbl : UILabel!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var datetimepicker : UIDatePicker!
    
    
    var alertdelegate : AlertDelegate!
    var alertVC : UIViewController = UIViewController()
    var selectedtime : String = ""
    var selectedDate : String = ""
    var selectionOption : DateselectionOption = .none
    var schduleDate : Date = Date()
    
    override func initView(view : UIView , vc : UIViewController) -> UIView {
        self.alertVC = vc
        self.setupView(view: view)
        self.submitBtn.setCorneredElevation()
        if schduleDate.interval(ofComponent: .day, fromDate: Date()) == 0{
            self.datetimepicker.minimumDate = Date()
        }
        
        self.setupAction()
        return self
    }
    
    
    
    
    override func deInitView(view : UIView , vc : UIViewController) -> UIView {
        return self
    }
    
    func setupAction(){
        
        self.cancelBtn.addTap {
            self.alertVC.dismiss(animated: false, completion: nil)
        }
        
        self.submitBtn.addTap{
            guard let delegate = self.alertdelegate else {
                self.alertVC.dismiss(animated: false, completion: nil)
                return
            }
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm a"
            self.selectedtime = timeFormatter.string(from: self.datetimepicker.date)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            self.selectedDate = dateFormatter.string(from: self.datetimepicker.date)
            
            
            self.alertdelegate.selectedDateTime(selectionType: self.selectionOption,date : self.datetimepicker.date, datestr: self.selectedDate, time: self.selectedtime, alertVC: self.alertVC)
            self.alertVC.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupView(view : UIView){
        view.addSubview(self)
        view.bringSubviewToFront(self)
        let height =  self.frame.height < 150.0 ? 150 : self.frame.height
        self.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        self.transform = CGAffineTransform(translationX: 0, y: 0)
        
        self.backgroundColor = .white
        
        self.setCorneredElevation()
    }
    
    
    
    //MARK: Register xib view
    class var getView : DateTimePickerAlert {
        return UINib(nibName: "DatePickerAlert", bundle: nil).instantiate(withOwner: self, options: nil)[2] as! DateTimePickerAlert
    }
}
