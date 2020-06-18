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

let mainPresenter : PresenterInputProtocol & InterectorToPresenterProtocol = Presenter()
let mainInteractor : PresenterToInterectorProtocol & WebServiceToInteractor = Interactor()
let mainRouter : PresenterToRouterProtocol = Router()
let mainWebservice : WebServiceProtocol = Webservice()

var presenterObject :PresenterInputProtocol?

class Router: PresenterToRouterProtocol{
    
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    
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
        if retrieveUserData(){
            let navigationController = UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: Storyboard.Ids.DashBoardViewController))
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
