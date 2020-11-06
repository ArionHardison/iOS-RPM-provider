//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "TeleHealth Doctor"
var deviceTokenString = Constants.string.noDevice
var deviceId = Constants.string.noDevice
var deviceType : DeviceType = .ios
let googleMapKey = "AIzaSyAlpDGEYqZS44sI_ffynh5sjm5JsNPPFLg"
let appSecretKey = "ldw85X0F81Yn59IFcalIvEdNVlKjBZn5u0nqICRp"
let appClientId = 2
let defaultMapLocation = LocationCoordinate(latitude: 13.009245, longitude: 80.212929)
let baseUrl = "https://telehealthmanager.net/" //"http://blabla.deliveryventure.com/"
let imageURL = "https://telehealthmanager.net/storage/"
let curreny = " $ "
var profile : ProfileEntity = ProfileEntity()
var GlobalsenderId = String()
var GlobalreciveId = String()
