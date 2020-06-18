//
//  FeedBackEntity.swift
//  MiDokter Pro
//
//  Created by AppleMac on 18/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper
//



struct FeedBackEntity : Mappable {
    var feedback : [Feedback]?
    var experiences_count : Int?
    var positive_count : Int?
    var negative_count : Int?
    init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        feedback <- map["feedback"]
        experiences_count <- map["experiences_count"]
        positive_count <- map["positive_count"]
        negative_count <- map["negative_count"]
    }
    
}


struct Feedback : Mappable {
    var id : Int?
    var patient_id : Int?
    var hospital_id : Int?
    var experiences : String?
    var visited_for : String?
    var comments : String?
    var created_at : String?
    var updated_at : String?
    var patient : Patient?
    init() {
        
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        patient_id <- map["patient_id"]
        hospital_id <- map["hospital_id"]
        experiences <- map["experiences"]
        visited_for <- map["visited_for"]
        comments <- map["comments"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        patient <- map["patient"]
    }
    
}



struct Patient : Mappable {
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
    }
    
}
