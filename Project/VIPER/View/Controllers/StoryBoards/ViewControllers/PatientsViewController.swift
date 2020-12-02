//
//  PatientsViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class PatientsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!  
    @IBOutlet weak var patientsTable: UITableView!
    var selectedDate : String = ""
    var isFromCalendar : Bool = false
    var todayPatients : [AllPatients] = [AllPatients]()
    var index : Int = 0
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }


}


extension PatientsViewController {
    func initialLoads(){
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.patients.localize()
        self.searchBar.delegate = self
        self.getPatientsList()

    }
    func registerCell(){
        
        self.patientsTable.tableFooterView = UIView()
        self.patientsTable.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientTableViewCell")

    }
    
    @objc func showOptions(sender : UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call Patient", style: .default, handler: { (_) in
            if let url = URL(string: "tel://\(self.todayPatients[sender.tag].phone ?? "")"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Add Appointment", style: .default, handler: { (_) in
            print("User click Edit button")
            if self.isFromCalendar{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.CreateAppointmentViewController) as! CreateAppointmentViewController
            vc.patientDetails = self.todayPatients[sender.tag]
            vc.selectedDate = self.selectedDate
                vc.isFromCalendar = self.isFromCalendar
            self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let view = DateTimePickerAlert.getView
                view.alertdelegate = self
                self.index = sender.tag
                AlertBuilder().addView(fromVC: self , view).show()
            }
            
        }))

        alert.addAction(UIAlertAction(title: "Add File", style: .default, handler: { (_) in
            print("User click Edit button")
        }))

        alert.addAction(UIAlertAction(title: "Delete Patient", style: .destructive, handler: { (_) in
            self.deletePatientDetail(id: self.todayPatients[sender.tag].id?.description ?? "")
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension PatientsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todayPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.patientsTable.dequeueReusableCell(withIdentifier: "PatientTableViewCell", for: indexPath) as! PatientTableViewCell
        
        self.populateData(cell: tableCell, data: self.todayPatients[indexPath.row])
        tableCell.buttonOptions.tag = indexPath.row
        tableCell.buttonOptions.addTarget(self, action: #selector(showOptions(sender:)), for: .touchUpInside)
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    func populateData(cell : PatientTableViewCell, data : AllPatients){
        cell.labelName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
        cell.labelPatientDetails.text = "\(data.profile?.age ?? "") years , \(data.profile?.gender ?? "")"
        cell.labelPatientID.text = "TELE\(data.id ?? 0)"
//        cell.imageView?.makeRoundedCorner()
        cell.patientImg?.setURLImage(data.profile?.profile_pic ?? "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromCalendar {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.CreateAppointmentViewController) as! CreateAppointmentViewController
        vc.patientDetails = self.todayPatients[indexPath.row]
        vc.selectedDate = self.selectedDate
        vc.isFromCalendar = self.isFromCalendar
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let view = DateTimePickerAlert.getView
            view.alertdelegate = self
            self.index = indexPath.row
            AlertBuilder().addView(fromVC: self , view).show()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

//Api calls
extension PatientsViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.PatientModel:
                guard let data = dataDict as? PatientModel else { return }
                self.loader.isHideInMainThread(true)
                self.todayPatients = data.allPatients ?? [AllPatients]()
                self.patientsTable.reloadInMainThread()
                break
            
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                self.loader.isHideInMainThread(true)
                showToast(msg: data.message ?? "")
                self.getPatientsList()
                break
          case model.type.SearchPatient:
                guard let data = dataDict as? SearchPatient else { return }
                self.todayPatients = data.patients ?? [AllPatients]()
                self.patientsTable.reloadInMainThread()
                break
                
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getPatientsList(){
        
        let url = "\(Base.patient.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: PatientModel.self, token: true)
        self.loader.isHidden = false
    }
    
    func deletePatientDetail(id : String){
        
        let url = "\(Base.patient.rawValue)/\(id)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .DELETE, modelClass: CommonModel.self, token: true)
        self.loader.isHidden = false
    }
}

extension PatientsViewController  : AlertDelegate{
    func selectedDate(selectionType: String, date: String, alertVC: UIViewController) {
  
    }
    
    func selectedDateTime(selectionType: DateselectionOption,date : Date, datestr: String, time: String, alertVC: UIViewController) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.CreateAppointmentViewController) as! CreateAppointmentViewController
            vc.patientDetails = self.todayPatients[self.index]
            vc.isFromCalendar = self.isFromCalendar
            let dateAsString =  datestr
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            let date = dateFormatter.date(from: dateAsString)

            dateFormatter.dateFormat = "HH:mm:ss"
            let date24 = dateFormatter.string(from: date ?? Date())
            
            vc.selectedDate = datestr + " " + date24
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectedTime(time: String, alertVC: UIViewController) {
        
    }
    
    
}


extension PatientsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            let url = "\(Base.searchPatient.rawValue)?search=\(searchText)"
            self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: SearchPatient.self, token: true)
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.getPatientsList()
    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//           print("end searching --> Close Keyboard")
//           self.searchBar.endEditing(true)
//       }
//    
    
}
