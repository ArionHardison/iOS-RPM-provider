//
//  ChatResponse.swift
//  ChatPOC
//
//  Created by CSS on 09/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Foundation

class ChatResponse : JSONSerializable {
    
    var key : String?
    var response : ChatEntity?
    var progress : Float?
}


class Response : JSONSerializable {
    
    var response : [String : ChatEntity]?
    
    
    required init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: Key.self)
        
        print(container)
        
        //  self.key = try container.decode(String.self, forKey: Key.init(stringValue: "Key")!)
        //  self.response = try container.decode(ChatEntity.self, forKey: Key.init(stringValue: "response")!)
        
    }
    
}


class Key : CodingKey, JSONSerializable {
    
    var stringValue: String
    
    required init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    required init?(intValue: Int) {
        return nil
    }
    
}


struct MessageDetails:JSONSerializable {
    var message: String?
    var provider_id: String?
    var senderId: String?
    var type: String?
    var time: String?
    var user_id: String?
}

enum SenderType: String,Codable {
    case User = "user"
    case Provider = "provider"
}

struct ChatHistory: Codable {
    var Response: ResponseData
    enum CodingKeys: String, CodingKey {
        case Response = "Response"
       
    }
}
struct ResponseData: Codable {
    var processeddata: ProcessedData
    enum CodingKeys: String, CodingKey {
        case processeddata = "Processed data"
        
    }
}
struct ProcessedData: Codable {
    var messages: [messagesEntity]
    enum CodingKeys: String, CodingKey {
        case messages = "messages"
        
    }
}
struct messagesEntity: Codable {
    var messages: String
    var provider_id: Int
    var senderId: Int
    var time: String
    var type: String
    var user_id: Int
}
