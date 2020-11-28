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
    @IBOutlet weak var dashView: UIView!

    @IBOutlet weak var bookedLbl: UILabel!
    @IBOutlet weak var cancelledLbl: UILabel!
    @IBOutlet weak var newPatientLbl: UILabel!
    @IBOutlet weak var repeatLbl: UILabel!
    @IBOutlet weak var revenueLbl: UILabel!
    @IBOutlet weak var appointmentDateLbl: UILabel!
    @IBOutlet weak var appointmentCountLbl: UILabel!
    @IBOutlet weak var showDateLbl: UILabel!
    @IBOutlet weak var chageDateBtn: UIButton!
    @IBOutlet weak var shadowLbl: UILabel!

    
    @IBOutlet weak var bookedTitleLbl: UILabel!
    @IBOutlet weak var cancelledTitleLbl: UILabel!
    @IBOutlet weak var newPatientTitleLbl: UILabel!
    @IBOutlet weak var repeatTitleLbl: UILabel!
    @IBOutlet weak var paidBtn: UIButton!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var appointmentDateTitleLbl: UILabel!
    @IBOutlet weak var showDateTitleLbl: UILabel!
    
    @IBOutlet weak var buttonProfile: UIButton!
    let titles = ["Wallet","Calender","Patients","Feedback","Chat","Health Feed"]
    let titlesImages = ["trendingx","calender","patient","feedback","chat","health"]

    
    var timerGetRequest: Timer?
    
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
         timerGetRequest = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.checkChatRequest), userInfo: nil, repeats: true)
         NotificationCenter.default.addObserver(self, selector: #selector(self.inValidateTimer(_:)), name: NSNotification.Name(rawValue: "InValidateTimer"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        //  self.navigationController?.isNavigationBarHidden = false
        timerGetRequest?.invalidate()
        timerGetRequest = nil
    }
    @objc func inValidateTimer(_ notification: NSNotification) {
        timerGetRequest?.invalidate()
        timerGetRequest = nil
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.dashView.addingCornerandShadow(color: .lightGray, opacity: 1, offset: CGSize(width: 0.0, height: 1.0), radius: 2, corner: 8.0)

        self.dashView.cornerRadius = 8.0
    }

    
    @objc private func checkChatRequest(){
        self.getChatRequest()
    }
    

}

extension DashBoardViewController {
    
    func initialLoads(){
        
        registerCell()
        
        self.userImg.addTap {
            
            self.ontapProfile()
        }
//        self.buttonProfile.addTarget(self, action: #selector(ontapProfile), for: .touchUpInside)
//        self.setupFont()
        self.setupLanguage()
        self.chageDateBtn.addTarget(self, action: #selector(changeAction(_sender:)), for: .touchUpInside)
        self.userImg.makeRoundedCorner()
    }
    
    func registerCell(){
        
        self.categoriesCollection.register(UINib(nibName: "HomeOptionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeOptionCollectionViewCell")
    }
    
    @objc func ontapProfile(){
        
        self.push(id: Storyboard.Ids.ProfieViewController, animation: true)
    }
    
    
    func populateData(data : DashBoardEntity){
        let data : DashBoardEntity = data
            self.bookedLbl.text = data.booked_count?.description ?? "0"
            self.cancelledLbl.text = data.cancelled_count?.description ?? "0"
            self.newPatientLbl.text = data.new_patient_count?.description ?? "0"
            self.repeatLbl.text = data.repeat_patients?.description ?? "0"
            self.revenueLbl.text = "\(Constants.string.revenu.localize()): \(curreny) \(data.revenue?.description ?? "0")"
            self.paidBtn.setTitle("\(Constants.string.paiddata.localize()): \(curreny) \(data.paid?.description ?? "0")", for: .normal)
            self.pendingBtn.setTitle("\(Constants.string.pending.localize()): \(curreny) \(data.pending?.description ?? "0")", for: .normal)
            self.appointmentCountLbl.text = data.total_appoinments?.description ?? "0"
        
    }
    
//    func setupFont(){
//    [self.bookedTitleLbl,self.cancelledTitleLbl,self.newPatientTitleLbl,self.repeatTitleLbl,self.appointmentDateTitleLbl,self.appointmentDateLbl].forEach { (label) in
//            Common.setFont(to: label)
//        }
//
//        [self.bookedLbl,self.cancelledLbl,self.newPatientLbl,self.repeatLbl].forEach { (label) in
//            Common.setFont(to: label, isTitle: true, size: 17)
//        }
//
//        [self.pendingBtn , self.paidBtn].forEach { (button) in
//            button?.setCorneredElevation(shadow: 1, corner: 5, color: .clear)
//        }
//        Common.setFont(to: self.appointmentCountLbl, isTitle: true, size: 20)
//    }
    
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
    
    @IBAction private func changeAction(_sender:UIButton){
        let alert = UIAlertController(title: "Appointments", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "This Week", style: .default , handler:{ (UIAlertAction)in
            print("This Week")
            let startDate = Date().startOfWeek
            let sDate = dateConvertor(startDate?.description ?? "", _input: .date_time_Z, _output: .YMD)
            let endWeek = Date().endOfWeek
            let eDate = dateConvertor(endWeek?.description ?? "", _input: .date_time_Z, _output: .YMD)
            self.getDashboardDetail(fromdate: sDate, todate: eDate)
            
        }))
        
        alert.addAction(UIAlertAction(title: "This Month", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            let startDate = Date().startOfMonth
            let sDate = dateConvertor(startDate.description , _input: .date_time_Z, _output: .YMD)
            let endWeek = Date().endOfMonth
            let eDate = dateConvertor(endWeek.description , _input: .date_time_Z, _output: .YMD)
            self.getDashboardDetail(fromdate: sDate, todate: eDate)
            
        }))

        alert.addAction(UIAlertAction(title: "Last Year", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
            let startDate = Date().previousYear(Date())
            let sDate = dateConvertor(startDate.description , _input: .date_time, _output: .YMD)
            let endWeek = Date().endOfMonth
            let eDate = dateConvertor(endWeek.description , _input: .date_time, _output: .YMD)
            self.getDashboardDetail(fromdate: sDate, todate: eDate)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
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
        cell.typeImage.image = UIImage(named: titlesImages[indexPath.row])
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PatientsViewController) as! PatientsViewController
            vc.isFromCalendar = false
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        
        if indexPath.item == 4 {
            
            self.push(id: Storyboard.Ids.ChatViewController, animation: true)
        }
        
        if indexPath.item == 1 {
            self.push(id: Storyboard.Ids.CalendarViewController, animation: true)
        }
        
        if indexPath.item == 0 {
            self.push(id: Storyboard.Ids.WalletViewController, animation: true)
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
                UserDefaultConfig.UserID = (data.doctor?.id ?? 0).description
                self.userNameLbl.text = "\(data.doctor?.first_name ?? "") \(data.doctor?.last_name ?? "")"
                self.userImg.setURLImage("\(data.doctor?.doctor_profile?.profile_pic ?? "")")
              
                break
            case model.type.ChatRequest :
                
                guard let data = dataDict as? ChatRequest else { return }
                guard let request = data.request as? Request else { return }
                let incomingVC = IncomingRequestController.initVC(storyBoardName: .main, vc: IncomingRequestController.self, viewConrollerID: "IncomingRequestController")
                incomingVC.modalPresentationStyle = .overCurrentContext
                incomingVC.delegate = self
                incomingVC.requestData = data
                present(incomingVC, animated: true, completion: nil)
            break
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getDashboardDetail(fromdate : String, todate : String){
        let url = "\(Base.home.rawValue)?from_date=\(fromdate)&to_date=\(todate)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: DashBoardEntity.self, token: true)
        showDateLbl.text = "\(dateConvertor(fromdate, _input: .YMD, _output: .DM)) - \(dateConvertor(todate, _input: .YMD, _output: .DM))"
    }
    
    func getChatRequest(){
        self.presenter?.HITAPI(api: Base.chatIncoming.rawValue, params: nil, methodType: .GET, modelClass: ChatRequest.self, token: true)
    }
    
    func profileApi(){
        let url = "\(Base.profile.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: ProfileEntity.self, token: true)
    }
    
}

extension DashBoardViewController : IncomingRequestDelegate{
    func acceptButtonAction(_ sender: UIButton) {
        self.push(id: Storyboard.Ids.ChatViewController, animation: true)
    }
    
    func rejectButtonAction(_ sender: UIButton) {
        
    }
    
    func finishButtonAction() {
        
    }
    
    
}



extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func previousYear(_ date: Date) -> Date {
        let calendar = NSCalendar.current
        return calendar.date(byAdding: .year, value: -1, to: date)!
    }
}



extension UIView{
    
    func addingCornerandShadow(color : UIColor = .gray, opacity : Float = 0.5, offset : CGSize = CGSize(width: 0.5, height: 0.5), radius : CGFloat = 0.5,corner:CGFloat = 0) {
            var shadowLayer: CAShapeLayer!

            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: corner).cgPath
                shadowLayer.fillColor = UIColor.white.cgColor

                shadowLayer.shadowColor = color.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = offset
                shadowLayer.shadowOpacity = opacity
                shadowLayer.shadowRadius = radius

                self.layer.insertSublayer(shadowLayer, at: 0)
                //layer.insertSublayer(shadowLayer, below: nil) // also works
            }
        }

}
