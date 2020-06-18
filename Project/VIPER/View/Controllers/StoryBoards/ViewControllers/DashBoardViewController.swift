//
//  HomeViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class DashBoardViewController: UIViewController {

    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var bookedLbl: UILabel!
    @IBOutlet weak var cancelledLbl: UILabel!
    @IBOutlet weak var newPatientLbl: UILabel!
    @IBOutlet weak var repeatLbl: UILabel!
    @IBOutlet weak var revenueLbl: UILabel!
    @IBOutlet weak var appointmentDateLbl: UILabel!
    @IBOutlet weak var appointmentCountLbl: UILabel!
    @IBOutlet weak var showDateLbl: UILabel!
    @IBOutlet weak var chageDateBtn: UIButton!
    
    
    @IBOutlet weak var bookedTitleLbl: UILabel!
    @IBOutlet weak var cancelledTitleLbl: UILabel!
    @IBOutlet weak var newPatientTitleLbl: UILabel!
    @IBOutlet weak var repeatTitleLbl: UILabel!
    @IBOutlet weak var paidBtn: UIButton!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var appointmentDateTitleLbl: UILabel!
    @IBOutlet weak var showDateTitleLbl: UILabel!
    
    @IBOutlet weak var buttonProfile: UIButton!
    let titles = ["Reach","Calender","Patients","Feedback","Chat","Health Feed"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let date = dateConvertor(Date().description, _input: .date_time, _output: .YMD)
        self.getDashboardDetail(fromdate: date, todate: date)
        showDateLbl.text = "\(dateConvertor(Date().description, _input: .date_time, _output: .DM)) - \(dateConvertor(Date().description, _input: .date_time, _output: .DM))"
        self.profileApi()
    }

    

}

extension DashBoardViewController {
    
    func initialLoads(){
        
        registerCell()
        self.buttonProfile.addTarget(self, action: #selector(ontapProfile), for: .touchUpInside)
        self.setupFont()
        self.setupLanguage()
        
        self.userImg.makeRoundedCorner()
    }
    
    func registerCell(){
        
        self.categoriesCollection.register(UINib(nibName: "HomeOptionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeOptionCollectionViewCell")
    }
    
    @objc func ontapProfile(){
        
        self.push(id: Storyboard.Ids.ProfieViewController, animation: true)
    }
    
    
    func populateData(data : DashBoardEntity){
        if let data : DashBoardEntity = data{
            self.bookedLbl.text = data.booked_count?.description ?? "0"
            self.cancelledLbl.text = data.cancelled_count?.description ?? "0"
            self.newPatientLbl.text = data.new_patient_count?.description ?? "0"
            self.repeatLbl.text = data.repeat_patients?.description ?? "0"
            self.revenueLbl.text = "\(Constants.string.revenu.localize()): \(curreny) \(data.revenue?.description ?? "0")"
            self.paidBtn.setTitle("\(Constants.string.paiddata.localize()): \(curreny) \(data.paid?.description ?? "0")", for: .normal)
            self.pendingBtn.setTitle("\(Constants.string.pending.localize()): \(curreny) \(data.pending?.description ?? "0")", for: .normal)
            self.appointmentCountLbl.text = data.total_appoinments?.description ?? "0"
        }
    }
    
    func setupFont(){
    [self.bookedTitleLbl,self.cancelledTitleLbl,self.newPatientTitleLbl,self.repeatTitleLbl,self.appointmentDateTitleLbl,self.appointmentDateLbl].forEach { (label) in
            Common.setFont(to: label)
        }
        
        [self.bookedLbl,self.cancelledLbl,self.newPatientLbl,self.repeatLbl].forEach { (label) in
            Common.setFont(to: label, isTitle: true, size: 17)
        }
        
        [self.pendingBtn , self.paidBtn].forEach { (button) in
            button?.setCorneredElevation(shadow: 1, corner: 5, color: .clear)
        }
        Common.setFont(to: self.appointmentCountLbl, isTitle: true, size: 20)
    }
    
    func setupLanguage() {
        self.bookedTitleLbl.text = Constants.string.booked.localize()
        self.cancelledTitleLbl.text = Constants.string.cancelled.localize()
        self.newPatientTitleLbl.text = Constants.string.newPatient.localize()
        self.repeatTitleLbl.text = Constants.string.repeatPatient.localize()
        self.appointmentDateTitleLbl.text = Constants.string.appointment.localize()
        self.repeatTitleLbl.text = Constants.string.revenu.localize()
        self.showDateTitleLbl.text = Constants.string.showDate.localize()
        self.chageDateBtn.setTitle(Constants.string.change.localize(), for: .normal)
    }
    
    
    
}
//MARK:- COLLECTION VIEW DELEGATES AND DATASOURCES :

extension DashBoardViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "HomeOptionCollectionViewCell", for: indexPath) as! HomeOptionCollectionViewCell
        cell.labelTitle.text = titles[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 5 {
            
            self.push(id: Storyboard.Ids.HealthFeedViewController, animation: true)
        }
        
        if indexPath.item == 3 {
            self.push(id: Storyboard.Ids.FeedBackViewController, animation: true)
        }
        
        if indexPath.item == 2 {
            self.push(id: Storyboard.Ids.PatientsViewController, animation: true)
        }
        
        if indexPath.item == 4 {
            
            self.push(id: Storyboard.Ids.ChatViewController, animation: true)
        }
        
        if indexPath.item == 1 {
            self.push(id: Storyboard.Ids.CalendarViewController, animation: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.categoriesCollection.frame.width/2.1, height: 80)
    }
   
}

//Api calls
extension DashBoardViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.DashBoardEntity:
                guard let data = dataDict as? DashBoardEntity else { return }
                self.populateData(data: data)
                break
            case model.type.ProfileEntity:
                guard let data = dataDict as? ProfileEntity else { return }
                profile = data
                self.userNameLbl.text = "\(data.doctor?.first_name ?? "") \(data.doctor?.last_name ?? "")"
                self.userImg.setURLImage("\(data.doctor?.doctor_profile?.profile_pic ?? "")")
              
                break
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getDashboardDetail(fromdate : String, todate : String){
        let url = "\(Base.home.rawValue)?from_date=\(fromdate)&to_date=\(todate)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: DashBoardEntity.self, token: true)
    }
    
    func profileApi(){
        let url = "\(Base.profile.rawValue)"
        
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: ProfileEntity.self, token: true)
    }
    
}


