//
//  PresenterProcessor.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class PresenterProcessor {
    
    
    static let shared = PresenterProcessor()

    
    func success(api : Base, response : Data)->String{
        
        return .Empty
        
    }
    
//    func signUpAuth(data: Data)-> SignUpMdel?{
//        
//        
//        return data.getDecodedObject(from: SignUpMdel.self)
//    }
//
//    func login(data: Data)-> loginModel? {
//        
//        return data.getDecodedObject(from: loginModel.self)!
//    }
//    
//    
//    func resetPassword(data: Data)-> resetPasswordModel? {
//        
//        return data.getDecodedObject(from: resetPasswordModel.self)!
//    }
//    
//    
//    func updateLocation(data: Data)-> updateLocationModel{
//        
//        return data.getDecodedObject(from: updateLocationModel.self)!
//    }
//    
//    func  OnlineStatus(data: Data)-> OnlinestatusModelResponse {
//        
//        return data.getDecodedObject(from: OnlinestatusModelResponse.self)!
//    }
    
}






