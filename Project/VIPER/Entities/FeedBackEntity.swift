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


