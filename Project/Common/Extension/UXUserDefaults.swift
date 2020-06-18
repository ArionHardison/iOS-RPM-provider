//
//  UXUserDefaults.swift
//  MiDokter User
//
//  Created by AppleMac on 15/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import UIKit

@propertyWrapper
struct UserDefault<T> {
    let key : String
    let defaultValue : T
    init(_ key : String , defaultValue : T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue : T{
        get{
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }set{
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


struct UserDefaultConfig {
   
    @UserDefault(UserDefaults.key.appState, defaultValue: "onboard")
    static var AppState : String
    
    @UserDefault(UserDefaults.key.fcmToken, defaultValue: "")
    static var FcmToken : String
    
    
    @UserDefault(UserDefaults.key.token, defaultValue: "")
    static var Token : String
    
    @UserDefault(UserDefaults.key.userID, defaultValue: "")
    static var UserID : String
    
    @UserDefault(UserDefaults.key.userName, defaultValue: "")
    static var UserName : String
    
    @UserDefault(UserDefaults.key.unverifyAlerDontShow, defaultValue: false)
    static var UnverifyAlerDontShow : Bool
}

extension UserDefaults {
    public enum key {
        static let appLang = "AppleLanguages"
        static let appState = "app_state"
        static let fcmToken = "fcm_token"
        static let token = "token"
        static let userID = "userID"
        static let userName = "userName"
        static let unverifyAlerDontShow = "unverifyAlerDontShow"
    }
}
