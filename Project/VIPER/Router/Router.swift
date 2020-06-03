//
//  Router.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation
import UIKit
import KWDrawerController

//
//
//let mainPresenter : PresenterInputProtocol & InterectorToPresenterProtocol = Presenter()
//let mainInteractor : PresenterToInterectorProtocol & WebServiceToInteractor = Interactor()
//let mainRouter : PresenterToRouterProtocol = Router()
//let mainWebservice : WebServiceProtocol = Webservice()
//
//var presenterObject :PresenterInputProtocol?
//
//
//class Router:  PresenterToRouterProtocol {
//    
//    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
//    // static let user = UIStoryboard(name: "User", bundle: Bundle.main)
//    
//    
//    
//    let mainPresenter : PresenterInputProtocol & InterectorToPresenterProtocol = Presenter()
//    let mainInteractor : PresenterToInterectorProtocol & WebServiceToInteractor = Interactor()
//    let mainRouter : PresenterToRouterProtocol = Router()
//    let mainWebservice : WebServiceProtocol = Webservice()
//    
//    static func createModule() -> UIViewController {
//        let view = main.instantiateViewController(withIdentifier: Storyboard.Ids.HomeViewController) as? UIViewController
//        view?.presenter = mainPresenter
//        mainPresenter.view = view
//        mainPresenter.interactor = mainInteractor
//        mainPresenter.router = mainRouter
//        mainInteractor.presenter = mainPresenter
//        mainInteractor.webService = mainWebservice
//        mainWebservice.interactor = mainInteractor
//        presenterObject = view?.presenter
//        
//        
//        
//        return retrieveUserData() ? main.instantiateViewController(withIdentifier:  Storyboard.Ids.DrawerController) : main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//    }
//    
//    
//}
//


let mainPresenter : PresenterInputProtocol & InterectorToPresenterProtocol = Presenter()
let mainInteractor : PresenterToInterectorProtocol & WebServiceToInteractor = Interactor()
let mainRouter : PresenterToRouterProtocol = Router()
let mainWebservice : WebServiceProtocol = Webservice()

var presenterObject :PresenterInputProtocol?

class Router: PresenterToRouterProtocol{
    
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let user = UIStoryboard(name: "User", bundle: Bundle.main)
    static let offerride = UIStoryboard(name: "OfferRide", bundle: Bundle.main)
    static let findride = UIStoryboard(name: "FindRide", bundle: Bundle.main)
    
    static func createModule() -> UIViewController {
        
        let view = main.instantiateViewController(withIdentifier: Storyboard.Ids.HomeViewController) as? HomeViewController
        view?.presenter = mainPresenter
        mainPresenter.view = view
        mainPresenter.interactor = mainInteractor
        mainPresenter.router = mainRouter
        mainInteractor.presenter = mainPresenter
        mainInteractor.webService = mainWebservice
        mainWebservice.interactor = mainInteractor
        presenterObject = view?.presenter
        if retrieveUserData() {
            
            let navigationController = UINavigationController(rootViewController: user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController))
            navigationController.isNavigationBarHidden = true
            return navigationController
        }else{
            let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController)
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
      
    }
    
}
