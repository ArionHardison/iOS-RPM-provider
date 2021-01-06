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
        self.localizedDescription = String(description.filter({ !"\n\t\r0".contains($0) }))
        self.statusCode = code
    }
}
