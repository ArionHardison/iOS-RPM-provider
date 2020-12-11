//
//  AddMoneyViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 10/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class AddMoneyViewController: UIViewController {
    @IBOutlet weak var labelMoney: UILabel!
    @IBOutlet weak var moneyTextField: HoshiTextField!
    @IBOutlet weak var addMoneyButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    var isFromPlans : Bool = false
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getProfile()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 15.0)
    }

}


extension AddMoneyViewController {
    
    private func initalLoads(){
       
        self.addMoneyButton.addTarget(self, action: #selector(addMoneyAction(sender:)), for: .touchUpInside)
        self.setupNavigationBar()
    }
    
    private func getProfile(){
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: ProfileEntity.self, token: true)
        self.loader.isHidden = false
    }
    
    @IBAction private func addMoneyAction(sender:UIButton){
        guard  let amount = self.moneyTextField.text,!amount.isEmpty else {
            showToast(msg: "Enter Amount to Proceed")
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier:Storyboard.Ids.CardsListViewController) as! CardsListViewController
        vc.amount = amount
        vc.isFromWallet = !isFromPlans
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    private func setupNavigationBar() {
         self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Add Money"
         Common.setFont(to: self.navigationItem.title!, isTitle: true, size: 18)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
         self.navigationController?.navigationBar.isTranslucent = false
         self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.02583951317, green: 0.1718649864, blue: 0.4112361372, alpha: 1)

    }
    
}


extension AddMoneyViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        DispatchQueue.main.async {
             switch String(describing: modelClass) {
            case model.type.ProfileEntity:
                self.loader.isHideInMainThread(true)
                guard let data = dataDict as? ProfileEntity else { return }
                profile = data
                self.labelMoney.text = "\(data.doctor?.wallet_balance ?? 0.0)"
                break
             default: break
             }
                
        }
       
   
      
    }
    
    func showError(error: CustomError) {
        
    }
    
    
}
