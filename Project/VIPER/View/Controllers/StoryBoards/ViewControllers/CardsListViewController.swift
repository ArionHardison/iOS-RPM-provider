//
//  CardsListViewController.swift
//  MiDokter User
//
//  Created by Sethuram Vijayakumar on 23/11/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class CardsListViewController: UIViewController {
    @IBOutlet weak var addMoneyTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var addNewCardButton: UIButton!
    @IBOutlet weak var cardListTableView: UITableView!
    @IBOutlet weak var addMoneyButton: UIButton!
    
    var amount =  ""
    var id = ""
    var message = ""
    var promoCode = ""
    var cardsList : [CardsModel]?
    var isFromWallet : Bool = false
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCards()
    }
}


extension CardsListViewController {
    
    private func initialLoads(){
        self.addMoneyTitleLabel.text = "Add Money"
        self.amountLabel.text = "$" + amount
        self.addNewCardButton.setTitle("+ Add New Card", for: .normal)
        self.addMoneyButton.setTitle("Add Money", for: .normal)
        self.cardListTableView.register(UINib(nibName: XIB.Names.CardsTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CardsTableViewCell)
        self.cardListTableView.delegate = self
        self.cardListTableView.dataSource = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            longPressGesture.minimumPressDuration = 0.5
        self.cardListTableView.addGestureRecognizer(longPressGesture)
        self.addNewCardButton.addTarget(self, action: #selector(addNewCardAction(sender:)), for: .touchUpInside)
    }
    
    private func getCards(){
        let url = "\(Base.addCard.rawValue)?user_type=doctor"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: CardsModel.self, token: true)
        self.loader.isHidden = false
    }
    
    @IBAction private func addNewCardAction(sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier:Storyboard.Ids.AddCardViewController) as! AddCardViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.cardListTableView)
        let indexPath = self.cardListTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            let alert = UIAlertController(title: "Delete Card", message: "Please Select an Option", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Delete Card", style: .default , handler:{ (UIAlertAction)in
                    print("User click Approve button")
                    var params = [String:Any]()
                    params.updateValue(self.cardsList?[indexPath!.row].card_id ?? "", forKey: "card_id")
                    self.presenter?.HITAPI(api: Base.deleteCard.rawValue, params: params, methodType: .POST, modelClass: CardSuccess.self, token: true)
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
}

extension CardsListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CardsTableViewCell, for: indexPath) as! CardsTableViewCell
        cell.labelCardNumber.text = "XXXX-XXXX-XXXX-" + (cardsList?[indexPath.section].last_four ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var params = [String:Any]()
        params.updateValue(amount, forKey: "amount")
        params.updateValue(cardsList?[indexPath.section].card_id ?? "", forKey: "card_id")
        self.presenter?.HITAPI(api: Base.addMoney.rawValue, params: params, methodType: .POST, modelClass: AddMoneyModel.self, token: true)
        self.loader.isHidden = false
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


extension CardsListViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        DispatchQueue.main.async {
            self.loader.isHideInMainThread(true)
            switch String(describing: modelClass) {
                case model.type.CardSuccess:
                    let data = dataDict as? CardSuccess
                    let alert  = showAlert(message: data?.message) { (_) in
//                        self.navigationController?.popViewController(animated: true)
//                        self.navigationController?.popToViewController(HomeViewController.self, animated: true)
                 
                            self.navigationController?.popViewController(animated: true)
                        
                        }
                    self.present(alert, animated: true, completion: nil)
                    
                    break
                    
            case model.type.CardsModel:
               
                let data = dataArray as? [CardsModel]
                self.cardsList = data ?? []
                self.cardListTableView.reloadInMainThread()
                self.loader.isHideInMainThread(true)
                break
//
            case model.type.AddMoneyModel:

                let data = dataDict as? AddMoneyModel
                let alert  = showAlert(message: data?.message) { (_) in
                    for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: WalletViewController.self) {
                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                self.present(alert, animated: true, completion: nil)
                break
                
                default: break
                
            }
            
        }
    }
    
    func showError(error: CustomError) {
        showToast(msg: error.localizedDescription)
        self.loader.isHideInMainThread(true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    
}
