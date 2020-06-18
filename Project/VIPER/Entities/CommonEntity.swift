//
//  CommonEntity.swift
//  MiDokter Pro
//
//  Created by AppleMac on 18/06/20.
//  Copyright © 2020 css. All rights reserved.
//
import Foundation
import ObjectMapper

struct CommonModel : Mappable {
    var status : Bool?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
    }
}


