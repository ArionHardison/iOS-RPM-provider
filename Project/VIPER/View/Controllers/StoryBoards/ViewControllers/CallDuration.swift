//
//  CallDuration.swift
//  User
//
//  Created by CSS on 30/03/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

//class CallDuration : JSONSerializable {
//    
//    var user_id : Int?
//    var user_caller_id : Int?
//    var type : String?
//    var start_time : String?
//    var end_time : String?
//    var updated_at : String?
//    var call_type : CallType?
//    var duration : String?
//    var id : Int?
//    var count : Int?
//    var user : User?
//    var profile : Profile?
//    var block : BlockModal?
//}
//
//
//class BlockModal : JSONSerializable {
//    
//    var is_blocked : String?
//    var user_id : Int?
//    var contact_user_id : Int?
//    var receiver_id : Int?
//}


struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

struct TokenUtils {
    static func fetchToken(url : String) throws -> String {
        var token: String = "TWILIO_ACCESS_TOKEN"
        let requestURL: URL = URL(string: url)!
        do {
            let data = try Data(contentsOf: requestURL)
            if let tokenReponse = String.init(data: data, encoding: String.Encoding.utf8) {
                token = tokenReponse
            }
        } catch let error as NSError {
            print ("Invalid token url, error = \(error)")
            throw error
        }
        return token
    }
}


struct TwilioAccess  : Mappable {
    var accessToken : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accessToken <- map["accessToken"]
    }

}


struct NEWIncomingCallDetails:JSONSerializable{
    
    
    var video:Int?
    var accesstoken:String?
    var type:String?
    var room_id:String?
    var receiver_image : String?
    var receiver_id :String?
    var name :String?
    var sender_id : Int?
    var incomingcall : Int?
    
}
