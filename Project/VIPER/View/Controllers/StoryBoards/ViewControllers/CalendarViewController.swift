//
//  CalendarViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import CLWeeklyCalendarView

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: CLWeeklyCalendarView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var buttonBlockCalendar: UIButton!
    @IBOutlet weak var buttonAddAppointment: UIButton!
    
    var notifyView : NotifyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
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

    }
    
    @objc func showOptions(sender : UIButton){
        let alert = UIAlertController(title: "Appointment Options", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("User click Edit button")
            self.push(id: Storyboard.Ids.EditAppointmentTableViewController, animation: true)
        }))

        alert.addAction(UIAlertAction(title: "No Show", style: .default, handler: { (_) in
            print("User click Delete button")
            self.showNotify(sender: sender)
        }))

        alert.addAction(UIAlertAction(title: "Cancel Appointment", style: .default, handler: { (_) in
            print("User click Delete button")
        }))

        alert.addAction(UIAlertAction(title: "Call Patient", style: .default, handler: { (_) in
            print("User click Delete button")
            
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTable.dequeueReusableCell(withIdentifier: XIB.Names.CalendarTableViewCell, for: indexPath) as! CalendarTableViewCell
        cell.buttonOptions.addTarget(self, action: #selector(showOptions(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
