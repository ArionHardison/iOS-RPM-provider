//
//  AddCardViewController.swift
//  User
//
//  Created by CSS on 23/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe
import ObjectMapper

class AddCardViewController: UIViewController {

    @IBOutlet private weak var creditCardView : CreditCardFormView!
    let paymentTextField = STPPaymentCardTextField()
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddCardViewController {
    
    func initialLoads() {
        
        STPPaymentConfiguration.shared().publishableKey = stripeKey//need to add on drive code
        self.creditCardView.cardHolderString =  String.removeNil(UserDefaultConfig.UserName)
        self.creditCardView.defaultCardColor = .primary
//        self.creditCardView.
        self.createTextField()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Chevron").resizeImage(newWidth: 30), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.addCardPayments.localize()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.string.Done.localize(), style: .done, target: self, action: #selector(self.doneButtonClick))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.view.dismissKeyBoardonTap()
    }
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    // MARK:- Done Button Click
    
    @IBAction private func doneButtonClick() {
        self.view.endEditingForce() 
        self.loader.isHidden = false
       let cardParams: STPCardParams = STPCardParams()
                          cardParams.number = paymentTextField.cardNumber
                          cardParams.expMonth = paymentTextField.expirationMonth
                          cardParams.expYear = paymentTextField.expirationYear
                          cardParams.cvc = paymentTextField.cvc
        STPAPIClient.shared().createToken(withCard: cardParams) { (stpToken, error) in
            
            guard let token = stpToken?.tokenId else {
                self.loader.isHideInMainThread(true)

                self.view.makeToast(error.debugDescription)
                
                return
            }
//
//            var cardEntity = CardEntity()
//            cardEntity.stripe_token = token
//            self.presenter?.post(api: .postCards, data: cardEntity.toData())
                        var params = [String:Any]()
                        params.updateValue(token, forKey: "stripe_token")
                        params.updateValue("doctor", forKey: "user_type")
                        params.updateValue("active", forKey: "status")
                        self.presenter?.HITAPI(api: Base.addCard.rawValue, params: params, methodType: .POST, modelClass: CardSuccess.self, token: true)
            self.loader.isHidden = false
            
            
        }
    }
}

// MARK:- STPPaymentCardTextFieldDelegate

extension AddCardViewController : STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = textField.isValid
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

// MARK:- PostViewProtocol

extension AddCardViewController : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHideInMainThread(true)
        DispatchQueue.main.async {
            switch String(describing: modelClass) {
                case model.type.CardSuccess:
                    
                    let data = dataDict as? CardSuccess
                    let alert  = showAlert(message: data?.message) { (_) in
                        self.navigationController?.popViewController(animated: true)
                        }
                    self.present(alert, animated: true, completion: nil)
                    
                    break
                
                default: break
                
            }
            
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHideInMainThread(true)
        DispatchQueue.main.async {
                self.loader.isHidden = true
                showAlert(message: error.localizedDescription, okHandler: nil, fromView: self)
            }
    }
    
}
