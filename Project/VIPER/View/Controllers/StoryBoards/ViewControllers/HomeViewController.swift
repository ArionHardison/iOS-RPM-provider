    //
    //  HomeViewController.swift
    //  User
    //
    //  Created by CSS on 02/05/18.
    //  Copyright © 2018 Appoets. All rights reserved.
    //
    
    import UIKit
    import Foundation
    import ObjectMapper
    
    class HomeViewController: UIViewController {
        
        @IBOutlet private var viewSideMenu : UIView!
        private var userDataResponse: Json4Swift_Base?
        var dictionary =  [String:String]()
        
        
        lazy var loader : UIView = {
            return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initialLoads()
       
           
        }
     
    }
    
    // MARK:- Methods
    
    extension HomeViewController {
        
        private func initialLoads() {
            self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
            
            let email = "demo@demo.com"
            var login = LoginParameters()
            login.username = email
            login.password = "123456"
            login.client_id = appClientId
            login.client_secret = appSecretKey
            login.device_id = deviceId
            login.device_type = "ios"
            login.device_token = deviceTokenString
            self.loader.isHidden = false
            
            self.presenter?.HITAPI(api: "api/v1/create", params: ["name":"test","salary":"123","age":"23"], methodType: .POST, modelClass: Json4Swift_Base.self, token: false)
            self.loader.isHidden = false
            
        }
        
        // MARK:- SideMenu Button Action
        
        @IBAction private func sideMenuAction(){
            
                self.drawerController?.openSide(.left)
                self.viewSideMenu.addPressAnimation()
         }
        
    }
    
    // MARK:- PostViewProtocol
    
    extension HomeViewController: PresenterOutputProtocol {
        
        func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
            print("Called")
            self.loader.isHideInMainThread(true)
           
        }
        
        func showError(error: CustomError) {
            print(error)
            self.loader.isHideInMainThread(true)
        }
        
    }

  


