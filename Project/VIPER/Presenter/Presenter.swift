//
//  Presenter.swift
//  Swift_Base
//

import Foundation
import ObjectMapper
import Alamofire

class Presenter {
    var view: PresenterOutputProtocol?
    var interactor: PresenterToInterectorProtocol?
    var router: PresenterToRouterProtocol?
}

extension Presenter: PresenterInputProtocol {
  
    func HITAPI<T: Mappable>(api: String, params: Parameters?, methodType: HttpType, modelClass: T.Type, token: Bool){
        interactor?.FetchingData(api: api, params: params, methodType: methodType, modelClass: modelClass, token: token)
    }
    func IMAGEPOST<T: Mappable>(api: String, params: [String : Any], methodType: HttpType, imgData: [String : Data]?, imgName: String, modelClass: T.Type, token: Bool) {
        interactor?.IMAGEPOSTfetchData(api: api, params: params, methodType: methodType, imgData: imgData, imgName: imgName, modelClass: modelClass, token: token)
    }
}

extension Presenter: InterectorToPresenterProtocol{
    func dataError(error: CustomError) {
        view?.showError(error: error)
    }
    func dataSuccess(api : String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        view?.showSuccess(api: api, dataArray: dataArray, dataDict: dataDict, modelClass: modelClass)
    }
    
    /* func DataFetchedArray(data: [Mappable], modelClass: Any) {
     view?.showArrayData(data: data, modelClass: modelClass)
     }
     func DataFetched(data: Mappable, modelClass: Any) {
     view?.showData(data: data, modelClass: modelClass)
     }*/
}



