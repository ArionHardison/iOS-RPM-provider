//
//  CalendarViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import CLWeeklyCalendarView
import ObjectMapper

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: CLWeeklyCalendarView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var buttonBlockCalendar: UIButton!
    @IBOutlet weak var buttonAddAppointment: UIButton!
    var all_appointments : [All_appointments] = [All_appointments]()
    var notifyView : NotifyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.getAppointmentDetail(date: self.calendarView.selectedDate.description)
        }
    }
    
}

extension CalendarViewController {
    func initialLoads() {
        
        setCalendarView()
        registerCell()
        
        self.buttonCancel.addTarget(self, action: #selector(buttonCancelAction), for: .touchUpInside)
        self.buttonAddAppointment.addTarget(self, action: #selector(AddAppointment), for: .touchUpInside)
        self.buttonBlockCalendar.addTarget(self, action: #selector(blockCalendar), for: .touchUpInside)
        
    }
    
    
    @IBAction func buttonCancelAction() {
        self.backButtonClick()
    }
    
    @IBAction func blockCalendar() {
        
        self.push(id: Storyboard.Ids.BlockCalendarViewController, animation: true)
    }
    
    @IBAction func AddAppointment() {
        
        self.push(id: Storyboard.Ids.AddAppointmentTableViewController, animation: true)
    }
    
    func registerCell() {
        
        self.listTable.register(UINib(nibName: XIB.Names.CalendarTableViewCell, bundle: .main), forCellReuseIdentifier: XIB.Names.CalendarTableViewCell)
    }
    
    func setCalendarView() {
        self.calendarView.calendarAttributes = [CLCalendarBackgroundImageColor : UIColor.clear,

        //Unselected days in the past and future, colour of the text and background.
            CLCalendarPastDayNumberTextColor : UIColor.darkGray,
            CLCalendarFutureDayNumberTextColor : UIColor.darkGray,

            CLCalendarCurrentDayNumberTextColor : UIColor.darkGray,
            CLCalendarCurrentDayNumberBackgroundColor : UIColor.clear,

        //Selected day (either today or non-today)
            CLCalendarSelectedDayNumberTextColor : UIColor.white,
            CLCalendarSelectedDayNumberBackgroundColor : UIColor.primary,
            CLCalendarSelectedCurrentDayNumberTextColor : UIColor.white,
            CLCalendarSelectedCurrentDayNumberBackgroundColor : UIColor.primary,

        //Day: e.g. Saturday, 1 Dec 2016
            CLCalendarDayTitleTextColor : UIColor.darkGray,
            CLCalendarSelectedDatePrintColor : UIColor.darkGray]
        self.calendarView.delegate = self

    }
    
     func alertAction(appointment : All_appointments){
        let alert = UIAlertController(title: "Appointment Options", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("User click Edit button")
            let vc = EditAppointmentTableViewController.initVC(storyBoardName: .main, vc: EditAppointmentTableViewController.self, viewConrollerID: Storyboard.Ids.EditAppointmentTableViewController)
            vc.appoinment = appointment
            self.push(from: self, ToViewContorller: vc)
        }))

        alert.addAction(UIAlertAction(title: "No Show", style: .default, handler: { (_) in
            print("User click Delete button")
//            self.showNotify(sender: sender)
        }))

        alert.addAction(UIAlertAction(title: "Cancel Appointment", style: .default, handler: { (_) in
            self.cancelAppointmentDetail(id: appointment.id?.description ?? "0")
            
        }))

        alert.addAction(UIAlertAction(title: "Call Patient", style: .default, handler: { (_) in
            if let url = URL(string: "tel://\(appointment.patient?.phone ?? "")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    func showNotify(sender:UIButton) {
        
        if self.notifyView == nil, let couponViewObject = Bundle.main.loadNibNamed(XIB.Names.NotifyView, owner: self, options: [:])?.first as? NotifyView {
            
            couponViewObject.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.notifyView = couponViewObject
            self.notifyView?.show(with: .bottom, completion: nil)
            self.view.addSubview(notifyView!)
            
            self.notifyView.onTapDiscard = {
                self.notifyView = nil
            }
            self.notifyView.onTapNotify = {
                self.notifyView = nil
            }

        }

    }

}


extension CalendarViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.all_appointments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTable.dequeueReusableCell(withIdentifier: XIB.Names.CalendarTableViewCell, for: indexPath) as! CalendarTableViewCell
        cell.buttonOptions.addTap {
            self.alertAction(appointment: self.all_appointments[indexPath.row])
        }
        self.setupData(cell: cell, data: self.all_appointments[indexPath.row])
        return cell
    }
    
    func setupData(cell : CalendarTableViewCell,data : All_appointments){
        cell.labelName.text = "\(data.patient?.first_name ?? "") \(data.patient?.last_name ?? "")"
        cell.labelTreatment.text = "\(data.description ?? "")"
        cell.labelTime.text = "\(dateConvertor(data.scheduled_at ?? "", _input: .date_time, _output: .N_hour))"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppointmentDetailsViewController.initVC(storyBoardName: .main, vc: AppointmentDetailsViewController.self, viewConrollerID: Storyboard.Ids.AppointmentDetailsViewController)
        vc.appoinment = self.all_appointments[indexPath.row]
        self.push(from: self, ToViewContorller: vc)
    }
}

extension CalendarViewController : CLWeeklyCalendarViewDelegate{
    func dailyCalendarViewDidSelect(_ date: Date!) {
        print("SelectedDate" , date)
//        let datestr = dateConvertor(date.description, _input: .date_time, _output: .YMD)
        getAppointmentDetail(date: date.description)
    }
    
    
}

//Api calls
extension CalendarViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.AppointmentModel:
                guard let data = dataDict as? AppointmentModel else { return }
               
                self.all_appointments = data.all_appointments ?? [All_appointments]()
                self.listTable.reloadData()
                break
            
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                self.getAppointmentDetail(date: self.calendarView.selectedDate.description)
              print("Datatata",data)
            break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getAppointmentDetail(date : String){
        
        let url = "\(Base.appoinemnt.rawValue)?date=\(dateConvertor(date.description, _input: .date_time_Z, _output: .YMD))"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: AppointmentModel.self, token: true)
    }
    
    func cancelAppointmentDetail(id : String){
        
        let url = "\(Base.cancelAppoinemnt.rawValue)"
        self.presenter?.HITAPI(api: url, params: ["id": id], methodType: .POST, modelClass: CommonModel.self, token: true)
    }
}
