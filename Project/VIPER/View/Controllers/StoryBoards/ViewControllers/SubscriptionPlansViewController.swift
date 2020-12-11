//
//  SubscriptionPlansViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 10/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class SubscriptionPlansViewController: UIViewController {
    @IBOutlet weak var subscriptionTableView: UITableView!
    @IBOutlet weak var proceedButton : UIButton!
    
    var subscriptionList = [Subscription]()
    var selectedindex : Int  = 0
    var walletBalance : Float = 0
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
}

extension SubscriptionPlansViewController {
    
    private func initialLoads(){
        
        self.subscriptionTableView.register(UINib(nibName: XIB.Names.SuggestedCell, bundle: nil), forCellReuseIdentifier:XIB.Names.SuggestedCell)
        self.getSubscriptionList()
        self.subscriptionTableView.delegate = self
        self.subscriptionTableView.dataSource = self
        self.subscriptionTableView.separatorStyle = .none
        self.proceedButton.setTitle("Proceed", for: .normal)
        self.proceedButton.addTarget(self, action: #selector(proceedAction(_sender:)), for: .touchUpInside)
    }
    
    private func setNavigationBar(){
        
             self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.title = "Subscription List"
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
    
    private func getSubscriptionList(){
        self.presenter?.HITAPI(api: Base.subscriptionList.rawValue, params: nil, methodType: .GET, modelClass: SubscriptionList.self, token: true)
        
    }

    @IBAction private func proceedAction(_sender:UIButton){
        if self.walletBalance < Float(self.subscriptionList[selectedindex].price ?? 0){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AddMoneyViewController) as! AddMoneyViewController
            vc.isFromPlans = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
        
        var params = [String:Any]()
        params.updateValue(self.subscriptionList[selectedindex].id ?? 0, forKey: "subscription_id")
        self.presenter?.HITAPI(api: Base.addSubscription.rawValue, params: params, methodType: .POST, modelClass: CardSuccess.self, token: true)
        }
    }
    
    
}

extension SubscriptionPlansViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subscriptionList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SuggestedCell, for: indexPath) as! SuggestedCell
        
        if selectedindex == indexPath.row{
            cell.suggetionView.borderColor = UIColor.AppBlueColor
            cell.titleLbl.textColor = UIColor.AppBlueColor
            cell.priceLbl.textColor = UIColor.AppBlueColor
            cell.planDescription.textColor = UIColor.AppBlueColor
            cell.suggetionView.setCorneredElevation(shadow: 1, corner: 10, color: UIColor.AppBlueColor)

        }else{
            
            cell.suggetionView.setCorneredElevation(shadow: 1, corner: 10, color: UIColor(named: "GreyTextcolor")!)

            cell.suggetionView.borderColor = UIColor(named: "GreyTextcolor")! //UIColor.black
            cell.titleLbl.textColor = UIColor(named: "GreyTextcolor")!
            cell.planDescription.textColor = UIColor(named: "GreyTextcolor")!
            cell.priceLbl.textColor = UIColor(named: "GreyTextcolor")! //UIColor.black//UIColor.black
        }
        cell.titleLbl.text = self.subscriptionList[indexPath.row].name ?? ""
        cell.planDescription.text = "For \(self.subscriptionList[indexPath.row].period ?? 0) \(self.subscriptionList[indexPath.row].duration ?? "")"
        cell.priceLbl.text = "\(curreny) \(self.subscriptionList[indexPath.row].price ?? 0)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedindex = indexPath.row
        self.subscriptionTableView.reloadData()
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
        headerView?.titleLbl.text = "Subscription Plans"
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


extension SubscriptionPlansViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.SubscriptionList:
                
                let data = dataDict as? SubscriptionList
                self.subscriptionList = data?.subscription ?? []
                self.subscriptionTableView.reloadInMainThread()
                
                break
        case model.type.ProfileEntity:
            
            let data = dataDict as? ProfileEntity
            self.walletBalance = data?.doctor?.wallet_balance ?? 0.0
            
            break
        case model.type.CardSuccess:
            
            let data = dataDict as? CardSuccess
            let alert  = showAlert(message: data?.message) { (_) in
                self.dismiss(animated: true, completion: nil)
                }
            self.present(alert, animated: true, completion: nil)
            
            break
        
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    
}
