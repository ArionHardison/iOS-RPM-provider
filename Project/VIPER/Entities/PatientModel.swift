//
//  PatientModel.swift
//  MiDokter Pro
//
//  Created by AppleMac on 19/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper

struct PatientModelReq : Codable {
    var phone : String = ""
    var secondary_mobile : String = ""
    var email : String = ""
    var dob : String = ""
    var blood_group : String = ""
    var postal_code : String = ""
    var address : String = ""
    var city : String = ""
    var other_id : String = ""
}

struct PatientModel : Mappable {
    var status : Bool?
    var allPatients : [String]?
    var todayPatients : [TodayPatients]?
    var recentPatients : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        allPatients <- map["allPatients"]
        todayPatients <- map["todayPatients"]
        recentPatients <- map["recentPatients"]
    }
    
}


struct TodayPatients : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var phone : String?
    var secondary_mobile : String?
    var other_id : String?
    var payment_mode : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var wallet_balance : Int?
    var rating : String?
    var email : String?
    var otp : Int?
    var regn_id : String?
    var email_verified : Int?
    var email_token : String?
    var email_verified_at : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var profile : Profile?
    var appointments : [Appointments]?
    init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        phone <- map["phone"]
        secondary_mobile <- map["secondary_mobile"]
        other_id <- map["other_id"]
        payment_mode <- map["payment_mode"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        email <- map["email"]
        otp <- map["otp"]
        regn_id <- map["regn_id"]
        email_verified <- map["email_verified"]
        email_token <- map["email_token"]
        email_verified_at <- map["email_verified_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        profile <- map["profile"]
        appointments <- map["appointments"]
    }
    
}
