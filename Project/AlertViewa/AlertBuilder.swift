

import UIKit

enum AlerActionTitle : String{
    case No
    case Yes
    
}

class AlertBuilder {
    let alert = AlertVC.shared()
    var vc : UIViewController!
    
    
    @discardableResult
    func addView(fromVC : UIViewController , _ view: UIView) -> AlertBuilder {
        self.vc = fromVC
        alert.subView = view
        return self
    }
       
    func show() {
        self.vc.present(vc: alert,.no)
    }
    
     func showLoader() {
        self.alert.isLoader = .yes
        self.vc.present(vc: alert,.no)
     }
    
    func showlodingView() {
       self.alert.lodingView = .yes
       self.vc.present(vc: alert,.no)
    }
    
    func dismiss(){
        self.vc.dismiss(animated: false, completion: nil)
    }
    
    
}


class AlertViewBuilder {
    
    private var alert = UIAlertController()
    var vc : UIViewController!
    
    init(vc : UIViewController) {
        self.vc = vc
    }
    
    @discardableResult
    func withTitle(title: String, message: String) -> AlertViewBuilder {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return self
    }
    
    @discardableResult
    func withAction(buttonTitle: AlerActionTitle, actionStyle: UIAlertAction.Style = .default, callback: ((UIAlertAction) -> Void)? = nil) -> AlertViewBuilder {
        let action = UIAlertAction(title: buttonTitle.rawValue, style: actionStyle, handler: callback)
        alert.addAction(action)
        return self
    }
    
    func build() {
        vc.present(alert, animated: true, completion: nil)
    }
    
}
