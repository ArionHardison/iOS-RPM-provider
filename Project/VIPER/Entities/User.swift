//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = User()
    
    //@objc dynamic var id = 0
    
    var id : Int?
    var name : String?
    var accessToken : String?
    var latitude : Double?
    var lontitude : Double?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    
    init(id : Int?, name : String?, accessToken: String?, latitude: Double?, lontitude: Double?, firstName: String?, lastName : String?, email : String?, phoneNumber: String?,picture: String?){
        
        self.id = id
        self.name = name
        self.accessToken = accessToken
        self.latitude = latitude
        self.lontitude = lontitude
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = phoneNumber
        self.email = email
        self.picture = picture
        
    }
    
    convenience
    override init(){
        
        self.init(id: nil, name: nil, accessToken: nil, latitude: nil, lontitude: nil, firstName: nil, lastName: nil, email: nil, phoneNumber:  nil, picture: nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.id) as? Int
        let name = aDecoder.decodeObject(forKey: Keys.list.name) as? String
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let latitude = aDecoder.decodeObject(forKey: Keys.list.latitude) as? Double
        let lontitude = aDecoder.decodeObject(forKey: Keys.list.lontitude) as? Double
        let firstNmae = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        let phoneNumber = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let picture = aDecoder.decodeObject(forKey: Keys.list.picture) as? String
        
        
        self.init(id: id, name: name, accessToken: accessToken, latitude: latitude, lontitude: lontitude, firstName: firstNmae, lastName: lastName, email: email, phoneNumber: phoneNumber, picture: picture)
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.id)
        aCoder.encode(self.name, forKey: Keys.list.name)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.lontitude, forKey: Keys.list.lontitude)
        aCoder.encode(self.latitude, forKey: Keys.list.latitude)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.email, forKey: Keys.list.email)
        aCoder.encodeConditionalObject(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.picture, forKey: Keys.list.picture)
    }
    
    
    
    
}









