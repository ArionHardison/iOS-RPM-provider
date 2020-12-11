//
//  SubscribedPlansViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 11/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class SubscribedPlansViewController: UIViewController {
    @IBOutlet weak var subscribedPlansTableView: UITableView!
    
    var subscribedList = [ProfileSubscription]()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

}


extension SubscribedPlansViewController {
    private func initialLoads(){
        
        self.subscribedPlansTableView.register(UINib(nibName: XIB.Names.SuggestedCell, bundle: nil), forCellReuseIdentifier:XIB.Names.SuggestedCell)
        self.profileApi()
        self.subscribedPlansTableView.delegate = self
        self.subscribedPlansTableView.dataSource = self
        self.subscribedPlansTableView.separatorStyle = .none
    }
    
    private func setNavigationBar(){
        
             self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.title = "Subscribed List"
             Common.setFont(to: self.navigationItem.title!, isTitle: true, size: 18)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
             self.navigationController?.navigationBar.isTranslucent = false
             self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.02583951317, green: 0.1718649864, blue: 0.4112361372, alpha: 1)
        
    }
    func profileApi(){
        let url = "\(Base.profile.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: ProfileEntity.self, token: true)
        self.loader.isHidden = false
    }
}


extension SubscribedPlansViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subscribedList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SuggestedCell, for: indexPath) as! SuggestedCell
        
            cell.suggetionView.borderColor = UIColor.AppBlueColor
            cell.titleLbl.textColor = UIColor.AppBlueColor
            cell.priceLbl.textColor = UIColor.AppBlueColor
            cell.planDescription.textColor = UIColor.AppBlueColor
            cell.suggetionView.setCorneredElevation(shadow: 1, corner: 10, color: UIColor.AppBlueColor)

        cell.titleLbl.text = self.subscribedList[indexPath.row].details?.name ?? ""
        cell.planDescription.text = "From \(self.subscribedList[indexPath.row].details?.period ?? 0) \(self.subscribedList[indexPath.row].details?.duration ?? "")"
        cell.priceLbl.text = "From \(self.subscribedList[indexPath.row].subscriptrion_start_date ?? "0") to \(self.subscribedList[indexPath.row].subscriptrion_end_date ?? "")"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("FaqHeaderView", owner: self, options: nil)?.first as? FaqHeaderView
        headerView?.titleLbl.text = "Subscribed Plans"
        headerView?.plusLbl.isHidden = true
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        view.backgroundColor = .clear //UIColor(named: "TextForegroundColor")
        return view
    }
    
    
}

extension SubscribedPlansViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch String(describing: modelClass) {
         
            case model.type.ProfileEntity:
                self.loader.isHideInMainThread(true)
                guard let data = dataDict as? ProfileEntity else { return }
                self.subscribedList = data.doctor?.subscription ?? []
                self.subscribedPlansTableView.reloadInMainThread()
                break

                
        default: break
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    
}
