//
//  LoginEntity.swift
//  MiDokter Pro
//
//  Created by AppleMac on 18/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper


struct LoginReq :Codable {
    var email : String = ""
    var device_type : String = "ios"
    var device_token : String = deviceTokenString
    var device_id : String = deviceId
    var client_id : String = appClientId.description
    var client_secret : String = appSecretKey
    var password : String = ""
    var grant_type : String = "password"
    
}

struct MobileVerifyModel : Mappable {
   
    var token : String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
    }
}

struct ChangePassReq :Codable {
    var current_password : String = ""
    var password : String = ""
    var password_confirmation : String = ""
    
}
