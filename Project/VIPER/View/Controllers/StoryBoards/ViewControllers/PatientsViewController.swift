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

    
    @IBOutlet weak var patientsTable: UITableView!
    
    
    var todayPatients : [TodayPatients] = [TodayPatients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.getPatientsList()
    }


}


extension PatientsViewController {
    func initialLoads(){
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.patients.localize()

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
    
    func populateData(cell : PatientTableViewCell, data : TodayPatients){
        cell.labelName.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
        cell.labelPatientDetails.text = "\(data.profile?.age ?? "") years , \(data.profile?.gender ?? "")"
        cell.labelPatientID.text = "\(data.id ?? 0)"
        cell.imageView?.makeRoundedCorner()
        cell.imageView?.setURLImage(data.profile?.profile_pic ?? "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PatientsInformationViewController.initVC(storyBoardName: .main, vc: PatientsInformationViewController.self, viewConrollerID: Storyboard.Ids.PatientsInformationViewController)
        vc.Patients = self.todayPatients[indexPath.row]
        self.push(from: self, ToViewContorller: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
}

//Api calls
extension PatientsViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.PatientModel:
                guard let data = dataDict as? PatientModel else { return }
                self.todayPatients = data.todayPatients ?? [TodayPatients]()
                self.patientsTable.reloadData()
                break
            
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                self.getPatientsList()
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getPatientsList(){
        
        let url = "\(Base.patient.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: PatientModel.self, token: true)
    }
    
    func deletePatientDetail(id : String){
        
        let url = "\(Base.patient.rawValue)/\(id)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .DELETE, modelClass: CommonModel.self, token: true)
    }
}
