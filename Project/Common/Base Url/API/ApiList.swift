//
//  ApiList.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//Http Method Types

enum HttpType : String{
    
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
}

// Status Code

enum StatusCode : Int {
    
    case notreachable = 0
    case success = 200
    case multipleResponse = 300
    case unAuthorized = 401
    case notFound = 404
    case ServerError = 500
    
}



enum Base : String{
  
    
    case loginWithEmail = "/api/hospital/login"
    case signUp = "/api/hospital/signUp"
    case logout = "/api/hospital/logout"
    case home = "/api/hospital/home"
    case feedback = "/api/hospital/feedback"
    case article = "/api/hospital/articles"
    case addArticle = "/api/hospital/add_article"
    case profile = "/api/hospital/profile"
    case changePassword = "/api/hospital/change_password"
    case updateProfile = "/api/hospital/update_profile"
    case appoinemnt = "/api/hospital/calender"
    case addAppoinemnt = "/api/hospital/add_appointment"
    case cancelAppoinemnt = "/api/hospital/cancel_appointment"
    case blockCalender = "/api/hospital/block_calender"
    case editAppointment = "/api/hospital/edit_appointment"
    case patient = "/api/hospital/patient"
    case chatIncoming = "api/hospital/chat/incoming"
    case updateStatus = "/api/hospital/chat/update"
    case chatHistory = "/api/hospital/chat/history"

    
    init(fromRawValue: String){
        self = Base(rawValue: fromRawValue) ?? .signUp
    }
    
    static func valueFor(Key : String?)->Base{
        
        guard let key = Key else {
            return Base.signUp
        }
        
        if let base = Base(rawValue: key) {
            return base
        }
        
        return Base.signUp
        
    }
    
}


struct model {
    
    static let type = model()
    
    let MobileVerifyModel = "MobileVerifyModel"
    let DashBoardEntity = "DashBoardEntity"
    let FeedBackEntity = "FeedBackEntity"
    let ArticlesEntity = "ArticlesEntity"
    let CommonModel = "CommonModel"
    let ProfileEntity = "ProfileEntity"
    let AppointmentModel = "AppointmentModel"
    let PatientModel = "PatientModel"
    let ChatRequest = "ChatRequest"
    let ChatAcceptRejectEntity = "ChatAcceptRejectEntity"
    let ChatHistoryEntity = "ChatHistoryEntity"
    let CreateAppointment = "CreateAppointment"
}



