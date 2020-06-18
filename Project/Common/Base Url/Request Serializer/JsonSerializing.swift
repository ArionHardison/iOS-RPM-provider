
//
//  jsonSerializing.swift
//  Appoets
//
//  Created by Developer on 13/07/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation

public func convertToDictionary<T : Codable>(model : T) -> [String: Any]? {
    
    let jsonData = try! JSONEncoder().encode(model)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    
    if let data = jsonString.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? ["" : ""]
        } catch {
            print(error.localizedDescription)
        }
    }
    return ["" : ""]
}


protocol JSONSerializable : Codable {
    var JSONRepresentation : [String : Any] { get }
}

extension JSONSerializable {
    
    
    var JSONRepresentation : [String : Any] {
        
        var representation = [String:Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
            case let value as Dictionary<String,Any>:
                
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                
                if let val = value as? [JSONSerializable]{
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject}) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value as JSONSerializable:
                
                representation[label] = value.JSONRepresentation
                
            case let value as AnyObject :
                
                representation[label] = value
                
            default: break
            }
        }
        return representation
    }
    
    // Convert to data by Encoding
    
    func toData()->Data? {
        
        do {
            
           return try JSONEncoder().encode(self)
            
        } catch let err {
            print("Error in Encoding ", self.JSONRepresentation, err.localizedDescription)
            return nil
        }
        
    }
    
    
    
//    func toData()->Data?{  // Convert struct directly into json request
//
//        let representation = JSONRepresentation
//
//        return getData(representation)
//
//
//    }
    
}

// MARK:- For Data

extension Data {
    
     func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        
        do {
            
            return try JSONDecoder().decode(object, from: self)
            
        } catch let error {
            
            print("Manually parsed  ", (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) ?? "nil")
            
            print("Error in Decoding OBject ", error.localizedDescription)
            return nil
        }
        
    }
    
}


