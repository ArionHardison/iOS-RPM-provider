//
//  Error.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

// Custom Error Protocol
protocol CustomErrorProtocol : Error {
    var localizedDescription : String {get set}
}


// Custom Error Struct for User Defined Error Messages

struct CustomError : CustomErrorProtocol {
   
    var localizedDescription: String
    var statusCode : Int
    
    init(description : String, code : Int){
        var value = String(description.filter({ !"\n\t\r0".contains($0) }))
        if value.contains("false"){
            value = value.replacingOccurrences(of: "false", with: "", options: .literal, range: nil)
        }
        self.localizedDescription = value
        self.statusCode = code
    }
}
