//
//  Colors.swift
//  User
//
//  Created by imac on 12/22/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

enum Color : Int {
    
    case primary = 1
    case secondary = 2
    case lightBlue = 3
    case brightBlue = 4
    
    
    static func valueFor(id : Int)->UIColor?{
        
        switch id {
        case self.primary.rawValue:
            return .primary
        
        case self.secondary.rawValue:
            return .secondary
            
        case self.lightBlue.rawValue:
            return .lightBlue
        
        case self.brightBlue.rawValue:
            return .brightBlue
            
        default:
            return nil
        }
        
        
    }
    
    
}

extension UIColor {
    
    static var appColor : UIColor{
        return UIColor(named: "AppColor") ?? UIColor.primary
    }
    
    static var AppBlueColor : UIColor{
        return UIColor(named: "AppBlueColor") ?? UIColor.blue
    }
    
    static var LightGreen : UIColor{
        return UIColor(named: "LightGreen") ?? UIColor.clear
    }
    
    
    // Primary Color
    static var primary : UIColor {
        return UIColor(named: "AppColor") ?? UIColor.primary
    }
    
    // Secondary Color
    static var secondary : UIColor {
        return UIColor(named: "AppBlueColor") ?? UIColor.blue
    }
    
    // Secondary Color
    static var lightBlue : UIColor {
        return UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1)
    }
    
    //Gradient Start Color
    
    static var startGradient : UIColor {
        return UIColor(red: 83/255, green: 173/255, blue: 46/255, alpha: 1)
    }
    
    //Gradient End Color
    
    static var endGradient : UIColor {
        return UIColor(red: 158/255, green: 178/255, blue: 45/255, alpha: 1)
    }
    
    // Blue Color
    
    static var brightBlue : UIColor {
        return UIColor(red: 40/255, green: 25/255, blue: 255/255, alpha: 1)
    }
    
    
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    
}
