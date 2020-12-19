//
//  ProfileEntity.swift
//  MiDokter Pro
//
//  Created by AppleMac on 18/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProfileEntity : Mappable {
    
    var doctor : Doctor?
    var clinics : [Clinics]?
    init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        doctor <- map["doctor"]
        clinics <- map["clinics"]
    }
    
}

struct Doctor : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var mobile : String?
    var country_code : String?
    var email : String?
    var device_token : String?
    var push_device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var wallet_balance : Float?
    var otp : Int?
    var rating : String?
    var gender : String?
    var tax_id : String?
    var medical_id : String?
    var regn_id : String?
    var clinic_id : Int?
    var services_id : String?
    var specialities_name : String?
    var is_administrative : Int?
    var is_doctor : Int?
    var added_by : Int?
    var is_staff : Int?
    var is_receptionist : Int?
    var role : Int?
    var email_verified : Int?
    var email_token : String?
    var email_verified_at : String?
    var subscribe_from : String?
    var subscribe_to : String?
    var subscribe_limit : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var status : String?
    var stripe_cust_id : String?
    var subscribe_status : Int?
    var doctor_profile : Doctor_profile?
    var subscription : [ProfileSubscription]?
    var feedback : [Feedback]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        mobile <- map["mobile"]
        country_code <- map["country_code"]
        email <- map["email"]
        device_token <- map["device_token"]
        push_device_token <- map["push_device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        wallet_balance <- map["wallet_balance"]
        otp <- map["otp"]
        rating <- map["rating"]
        gender <- map["gender"]
        tax_id <- map["tax_id"]
        medical_id <- map["medical_id"]
        regn_id <- map["regn_id"]
        clinic_id <- map["clinic_id"]
        services_id <- map["services_id"]
        specialities_name <- map["specialities_name"]
        is_administrative <- map["is_administrative"]
        is_doctor <- map["is_doctor"]
        added_by <- map["added_by"]
        is_staff <- map["is_staff"]
        is_receptionist <- map["is_receptionist"]
        role <- map["role"]
        email_verified <- map["email_verified"]
        email_token <- map["email_token"]
        email_verified_at <- map["email_verified_at"]
        subscribe_from <- map["subscribe_from"]
        subscribe_to <- map["subscribe_to"]
        subscribe_limit <- map["subscribe_limit"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        status <- map["status"]
        stripe_cust_id <- map["stripe_cust_id"]
        subscribe_status <- map["subscribe_status"]
        doctor_profile <- map["doctor_profile"]
        subscription <- map["subscription"]
        feedback <- map["feedback"]
    }

}


struct Doctor_profile : Mappable {
    var id : Int?
    var doctor_id : Int?
    var gender : String?
    var profile_pic : String?
    var profile_video : String?
    var medical_assoc_name : String?
    var awards : String?
    var profile_description : String?
    var experience : String?
    var internship : String?
    var certification : String?
    var residency : String?
    var medical_school : String?
    var address : String?
    var city : String?
    var country : String?
    var postal_code : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var affiliations : String?
    var specialities : Int?
    var fees : Int?
    var speciality : Speciality?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        doctor_id <- map["doctor_id"]
        gender <- map["gender"]
        profile_pic <- map["profile_pic"]
        profile_video <- map["profile_video"]
        medical_assoc_name <- map["medical_assoc_name"]
        awards <- map["awards"]
        profile_description <- map["profile_description"]
        experience <- map["experience"]
        internship <- map["internship"]
        certification <- map["certification"]
        residency <- map["residency"]
        medical_school <- map["medical_school"]
        address <- map["address"]
        city <- map["city"]
        country <- map["country"]
        postal_code <- map["postal_code"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        affiliations <- map["affiliations"]
        specialities <- map["specialities"]
        fees <- map["fees"]
        speciality <- map["speciality"]
    }

}

struct Clinics : Mappable {
    var id : Int?
    var name : String?
    var email : String?
    var phone : String?
    var country_code : String?
    var mobile : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var postal_code : String?
    var doctor_id : Int?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
     init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        country_code <- map["country_code"]
        mobile <- map["mobile"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        postal_code <- map["postal_code"]
        doctor_id <- map["doctor_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }
    
}

struct profileUploadReq : Codable {
    var first_name : String = ""
    var last_name : String = ""
    var specialities : Int = 0
    var mobile : String = ""
    var email : String = ""
    var country_code : String = ""
    var fees : String = "0"
}


struct Speciality : Mappable {
    var id : Int?
    var name : String?
    var image : String?
    var status : Int?
    var discount : String?
    var fees : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        image <- map["image"]
        status <- map["status"]
        discount <- map["discount"]
        fees <- map["fees"]
    }

}


struct GetSpeciality : Mappable {
   var speciality : [Speciality]?
    
    init() {}

   init?(map: Map) {

   }

   mutating func mapping(map: Map) {

       speciality <- map["speciality"]
   }

}

struct AddMoneyModel  : Mappable {
    var message : String?
    var user : Doctor?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        user <- map["user"]
    }

}

