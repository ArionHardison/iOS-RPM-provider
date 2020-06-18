//
//  UXString.swift
//  MiDokter User
//
//  Created by AppleMac on 15/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation

extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let phoneRegex = "^(()|(00))[0-9]{6,14}$"
        let PhoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return PhoneTest.evaluate(with: self)   }
    
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
