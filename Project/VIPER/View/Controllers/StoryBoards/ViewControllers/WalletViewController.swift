//
//  WalletViewController.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelWalletString : UILabel!
    @IBOutlet private weak var labelWalletAmount : UILabel!
    @IBOutlet private weak var tableViewWallet : UITableView!
    @IBOutlet private weak var viewHeader : UIView!
    
    private var barbuttonTransfer : UIBarButtonItem!
    private var datasource = [Payment_log]()
    private var profile = ProfileEntity()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    private var balance : Float = 0 {
        didSet {
            DispatchQueue.main.async {
//                self.labelWalletAmount.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(self.balance)", maximumDecimal: 2))"
                self.labelWalletAmount.text = "$\(self.profile.doctor?.wallet_balance ?? 0.0)"
                //self.barbuttonTransfer.isEnabled = self.balance > 0
               // self.barbuttonTransfer.tintColor = self.balance > 0 ? .secondary : .clear
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.localize()
        self.setDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearCustom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: true, clearQueue: true)
    }
    
}

// MARK:- Methods
extension WalletViewController {
    
    private func initialLoads() {
        
        self.tableViewWallet.tableHeaderView = viewHeader
        self.tableViewWallet.delegate = self
        self.tableViewWallet.dataSource = self
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletListTableViewCell, bundle: nil), forCellReuseIdentifier:  XIB.Names.WalletListTableViewCell)
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: XIB.Names.WalletHeader)
        self.labelWalletAmount.text = "$\(self.profile.doctor?.wallet_balance ?? 0.0)"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(UIColor.white), style: .plain, target: self, action: #selector(backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
        self.balance = self.profile.doctor?.wallet_balance ?? 0.0
        self.navigationController?.isNavigationBarHidden = false
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "AddWallet"), for: .normal)
        button.addTarget(self, action:#selector(addMoneyAction(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: ProfileEntity.self, token: true)
        self.loader.isHidden = false
    }
    
    private func localize() {
        self.labelWalletString.text = Constants.string.walletAmount.localize()
    }
    
    private func setDesign() {
       Common.setFont(to: labelWalletString, isTitle: true, size: 18)
       Common.setFont(to: labelWalletAmount, isTitle: true, size: 30)
    }
    
    private func viewWillAppearCustom() {
        self.initialLoads()
        self.presenter?.HITAPI(api: Base.paymentLog.rawValue, params: nil, methodType: .GET, modelClass: WalletTransactionModel.self, token: true)
        self.loader.isHidden = false
        
        
    }
    
    @IBAction private func addMoneyAction(sender:UIButton){
        let addVc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.AddMoneyViewController) as! AddMoneyViewController
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    

    
    // MARK:- Empty View
    
    private func checkEmptyView() {
        
        self.tableViewWallet.backgroundView = {
            
            if (self.datasource.count) == 0 {
                let label = UILabel(frame: UIScreen.main.bounds)
                label.numberOfLines = 0
                Common.setFont(to: label, isTitle: true)
                label.center = UIApplication.shared.keyWindow?.center ?? .zero
                label.backgroundColor = .clear
                label.textColor = .secondary
                label.textAlignment = .center
                label.text = Constants.string.noTransactionsYet.localize()
                return label
            } else {
                return nil
            }
        }()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.checkEmptyView()
            self.tableViewWallet.reloadData()
        }
    }
    
}


extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletListTableViewCell, for: indexPath) as? WalletListTableViewCell {
            if self.datasource.count > indexPath.row {
                tableCell.set(values : self.datasource[indexPath.row])
            }
            return tableCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let walletHeader = Bundle.main.loadNibNamed(XIB.Names.WalletHeader, owner: self, options: [:])?.first as? WalletHeader
        walletHeader?.backgroundColor = .secondary
        return walletHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}




extension WalletViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch String(describing: modelClass) {
         
            case model.type.ProfileEntity:
                self.loader.isHideInMainThread(true)
                guard let data = dataDict as? ProfileEntity else { return }
                self.balance = data.doctor?.wallet_balance ?? 0.0
                self.profile = data
                self.labelWalletAmount.text = "\(data.doctor?.wallet_balance ?? 0.0)"
                break
        case model.type.WalletTransactionModel:
            self.loader.isHideInMainThread(true)
            guard let data = dataDict as? WalletTransactionModel else { return }
            self.datasource = data.payment_log ?? []
            self.tableViewWallet.reloadInMainThread()
            break
                
        default: break
        }
    }
    
    func showError(error: CustomError) {
        showToast(msg: error.localizedDescription)
        self.loader.isHideInMainThread(true)
        
    }
    
    
}
