
//
//  ChatHistoryEntity.swift
//  MiDokter Pro
//
//  Created by AppleMac on 25/09/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChatHistoryEntity : Mappable {
    var chats : [Chats]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        chats <- map["chats"]
    }
    
}

struct Chats : Mappable {
    var id : Int?
    var chat_requests_id : Int?
    var patient_id : Int?
    var hospital_id : Int?
    var chennel : String?
    var created_at : String?
    var updated_at : String?
    var chat_request : Chat_request?
    var patient : Patient?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        chat_requests_id <- map["chat_requests_id"]
        patient_id <- map["patient_id"]
        hospital_id <- map["hospital_id"]
        chennel <- map["chennel"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        chat_request <- map["chat_request"]
        patient <- map["patient"]
    }
    
}
