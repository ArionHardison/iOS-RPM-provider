//
//  Country.swift
//  User
//
//  Created by CSS on 20/02/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


import ObjectMapper

struct LoginModel : Mappable {
    var token_type : String?
    var access_token : String?
    var refresh_token : String?
    //   var data : Data?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        token_type <- map["token_type"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
        //   data <- map["data"]
    }
    
}

struct Country: Decodable {
    
    var name : String
    var dial_code : String
    var code : String
    
}


//MARK:- Login Screen

struct LoginParameters {
    
    var username: String?
    var password: String?
    var client_id: Int?
    var client_secret: String?
    var device_type: String?
    var device_token: String?
    var device_id: String?
    var grant_type: String?
    
    func toLoginParameters() -> [String : Any] {
        let parameters = [PARAM_USERNAME: self.username ?? "",
                          PARAM_PASSWRD : self.password!,
                          PARAM_CLIENTID:appClientId,
                          PARAM_CLIENTSECRET: appSecretKey,
                          PARAM_DEVICETYPE : "ios",
                          PARAM_DEVICETOKEN : deviceTokenString,
                          PARAM_DEVICEID: UUID().uuidString,
                          PARAM_GRANTTYPE : self.grant_type ?? ""] as [String : Any]
        
        return parameters as [String : Any]
    }
}


let PARAM_FIRSTNAME = "first_name"
let PARAM_LASTNAME = "last_name"
let PARAM_EMAIL = "email"
let PARAM_PASSWRD = "password"
let PARAM_CONFIRMPASSWRD = "password_confirmation"
let PARAM_COUNTRYCODE = "country_code"
let PARAM_MOBILE = "mobile"
let PARAM_GENDER = "gender"
let PARAM_DOB = "dob"
let PARAM_CLIENTID = "client_id"
let PARAM_CLIENTSECRET = "client_secret"
let PARAM_DEVICETYPE = "device_type"
let PARAM_DEVICETOKEN = "device_token"
let PARAM_DEVICEID = "device_id"
let PARAM_LOGINBY = "login_by"
let PARAM_PICTURE = "picture"
let PARAM_USERNAME = "username"
let PARAM_GRANTTYPE = "grant_type"


struct DeleteModel : Mappable {
    var token_type : String?
    var access_token : String?
    var refresh_token : String?
    //   var data : Data?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        token_type <- map["token_type"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
        //   data <- map["data"]
    }
    
}
