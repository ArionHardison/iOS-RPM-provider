//
//  AppointmentModel.swift
//  MiDokter Pro
//
//  Created by AppleMac on 19/06/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import ObjectMapper

struct AppointmentReq : Codable{
    var patient_id : String = ""
    var doctor_id : String = ""
    var service_id : String = ""
    var scheduled_at : String = ""
    var consult_time : String = ""
    var appointment_type : String = ""
    var description : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var email : String = ""
    var phone : String = ""
    var gender : String = ""
    var age : String = ""
}

struct EditAppointmentReq : Codable{
    var id : String = ""
    var patient_id : String = ""
    var doctor_id : String = ""
    var service_id : String = ""
    var scheduled_at : String = ""
    var consult_time : String = ""
    var appointment_type : String = ""
    var description : String = ""
}

struct BlockReq : Codable{
    var from_date : String = ""
    var to_date : String = ""
    var reason : String = ""
}

struct AppointmentModel: Mappable {
    var status : String?
    var all_appointments : [All_appointments]?
    var recentPatients : [String]?
    var doctor : Doctor?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        all_appointments <- map["all_appointments"]
        recentPatients <- map["recentPatients"]
        doctor <- map["doctor"]
    }
    
}


struct Patient : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var phone : String?
    var secondary_mobile : String?
    var other_id : String?
    var payment_mode : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var wallet_balance : Int?
    var rating : String?
    var email : String?
    var otp : Int?
    var regn_id : String?
    var email_verified : Int?
    var email_token : String?
    var email_verified_at : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var profile : Profile?
    var appointments : [Appointments]?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        phone <- map["phone"]
        secondary_mobile <- map["secondary_mobile"]
        other_id <- map["other_id"]
        payment_mode <- map["payment_mode"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        email <- map["email"]
        otp <- map["otp"]
        regn_id <- map["regn_id"]
        email_verified <- map["email_verified"]
        email_token <- map["email_token"]
        email_verified_at <- map["email_verified_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        profile <- map["profile"]
        appointments <- map["appointments"]
    }
    
}



struct Profile : Mappable {
    var id : Int?
    var patient_id : String?
    var age : String?
    var gender : String?
    var dob : String?
    var blood_group : String?
    var profile_pic : String?
    var description : String?
    var refered_by : String?
    var occupation : String?
    var groups : String?
    var address : String?
    var street : String?
    var locality : String?
    var city : String?
    var country : String?
    var postal_code : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var merital_status : String?
    var height : String?
    var weight : String?
    var emergency_contact : String?
    var allergies : String?
    var current_medications : String?
    var past_medications : String?
    var chronic_diseases : String?
    var injuries : String?
    var surgeries : String?
    var smoking : String?
    var alcohol : String?
    var activity : String?
    var food : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        patient_id <- map["patient_id"]
        age <- map["age"]
        gender <- map["gender"]
        dob <- map["dob"]
        blood_group <- map["blood_group"]
        profile_pic <- map["profile_pic"]
        description <- map["description"]
        refered_by <- map["refered_by"]
        occupation <- map["occupation"]
        groups <- map["groups"]
        address <- map["address"]
        street <- map["street"]
        locality <- map["locality"]
        city <- map["city"]
        country <- map["country"]
        postal_code <- map["postal_code"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        merital_status <- map["merital_status"]
        height <- map["height"]
        weight <- map["weight"]
        emergency_contact <- map["emergency_contact"]
        allergies <- map["allergies"]
        current_medications <- map["current_medications"]
        past_medications <- map["past_medications"]
        chronic_diseases <- map["chronic_diseases"]
        injuries <- map["injuries"]
        surgeries <- map["surgeries"]
        smoking <- map["smoking"]
        alcohol <- map["alcohol"]
        activity <- map["activity"]
        food <- map["food"]
    }
    
}


struct Service : Mappable {
    var id : Int?
    var name : String?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
    }
    
}

struct Hospital : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var mobile : String?
    var country_code : String?
    var email : String?
    var otp : Int?
    var gender : String?
    var tax_id : String?
    var medical_id : String?
    var regn_id : String?
    var clinic_id : Int?
    var services_id : String?
    var specialities_name : String?
    var is_administrative : Int?
    var is_doctor : Int?
    var added_by : String?
    var is_staff : Int?
    var is_receptionist : Int?
    var role : Int?
    var email_verified : Int?
    var email_token : String?
    var email_verified_at : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        mobile <- map["mobile"]
        country_code <- map["country_code"]
        email <- map["email"]
        otp <- map["otp"]
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
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }
    
}

struct Appointments : Mappable {
    var id : Int?
    var doctor_id : Int?
    var patient_id : Int?
    var service_id : String?
    var appointment_type : String?
    var booking_for : String?
    var scheduled_at : String?
    var engaged_at : String?
    var checkin_at : String?
    var consult_time : String?
    var checkedout_at : String?
    var description : String?
    var report : String?
    var patient_reminder : Int?
    var doctor_reminder : Int?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var status : String?
    var driver_rating : Int?
    var patient_rating : Int?
    var hospital : Hospital?
    var service : String?
    init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        doctor_id <- map["doctor_id"]
        patient_id <- map["patient_id"]
        service_id <- map["service_id"]
        appointment_type <- map["appointment_type"]
        booking_for <- map["booking_for"]
        scheduled_at <- map["scheduled_at"]
        engaged_at <- map["engaged_at"]
        checkin_at <- map["checkin_at"]
        consult_time <- map["consult_time"]
        checkedout_at <- map["checkedout_at"]
        description <- map["description"]
        report <- map["report"]
        patient_reminder <- map["patient_reminder"]
        doctor_reminder <- map["doctor_reminder"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        status <- map["status"]
        hospital <- map["hospital"]
        driver_rating <- map["driver_rating"]
        patient_rating <- map["patient_rating"]
        service <- map["service"]
    }
    
}

struct All_appointments : Mappable {
    var id : Int?
    var doctor_id : Int?
    var patient_id : Int?
    var service_id : Int?
    var appointment_type : String?
    var booking_for : String?
    var scheduled_at : String?
    var engaged_at : String?
    var checkin_at : String?
    var consult_time : String?
    var checkedout_at : String?
    var description : String?
    var report : String?
    var patient_reminder : Int?
    var doctor_reminder : Int?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var status : String?
    var driver_rating : Int?
    var patient_rating : Int?
    var patient : Patient?
    var hospital : Hospital?
    var service : Service?
    var invoice : Invoice?
    init(){}
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        doctor_id <- map["doctor_id"]
        patient_id <- map["patient_id"]
        service_id <- map["service_id"]
        appointment_type <- map["appointment_type"]
        booking_for <- map["booking_for"]
        scheduled_at <- map["scheduled_at"]
        engaged_at <- map["engaged_at"]
        checkin_at <- map["checkin_at"]
        consult_time <- map["consult_time"]
        checkedout_at <- map["checkedout_at"]
        description <- map["description"]
        report <- map["report"]
        patient_reminder <- map["patient_reminder"]
        doctor_reminder <- map["doctor_reminder"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        status <- map["status"]
        patient <- map["patient"]
        hospital <- map["hospital"]
        service <- map["service"]
        invoice <- map["invoice"]
        driver_rating <- map["driver_rating"]
        patient_rating <- map["patient_rating"]
    }
    
}



struct CreateAppointment : Mappable {
    var success : String?
    var appointment : Appointment?
    var message : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        appointment <- map["appointment"]
        message <- map["message"]
    }

}

struct Appointment : Mappable {
    var doctor_id : String?
    var patient_id : Int?
    var service_id : String?
    var scheduled_at : String?
    var scheduled_end : String?
    var consult_time : String?
    var description : String?
    var status : String?
    var appointment_type : String?
    var updated_at : String?
    var created_at : String?
    var id : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        doctor_id <- map["doctor_id"]
        patient_id <- map["patient_id"]
        service_id <- map["service_id"]
        scheduled_at <- map["scheduled_at"]
        scheduled_end <- map["scheduled_end"]
        consult_time <- map["consult_time"]
        description <- map["description"]
        status <- map["status"]
        appointment_type <- map["appointment_type"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]
        id <- map["id"]
    }

}



struct UpdateFeedBackModel : Mappable {
    var message : String?
    var feedback : Feedback?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        feedback <- map["feedback"]
    }

}


struct WalletTransactionModel : Mappable {
    var message : String?
    var payment_log : [Payment_log]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        payment_log <- map["payment_log"]
    }

}

struct Payment_log : Mappable {
    var id : Int?
    var is_wallet : Int?
    var user_type : String?
    var payment_mode : String?
    var status : String?
    var user_id : Int?
    var doctor_id : Int?
    var amount : Float?
    var transaction_code : String?
    var transaction_id : String?
    var response : String?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        is_wallet <- map["is_wallet"]
        user_type <- map["user_type"]
        payment_mode <- map["payment_mode"]
        status <- map["status"]
        user_id <- map["user_id"]
        doctor_id <- map["doctor_id"]
        amount <- map["amount"]
        transaction_code <- map["transaction_code"]
        transaction_id <- map["transaction_id"]
        response <- map["response"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}


struct Invoice : Mappable {
    var id : Int?
    var appointment_id : Int?
    var paid : Int?
    var promocode_id : Int?
    var promocode_amount : Int?
    var discount : Int?
    var gross : Int?
    var total_pay : Int?
    var consulting_fees : Int?
    var speciality_fees : Int?
    var payment_mode : String?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?

    init() {
        
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        appointment_id <- map["appointment_id"]
        paid <- map["paid"]
        promocode_id <- map["promocode_id"]
        promocode_amount <- map["promocode_amount"]
        discount <- map["discount"]
        gross <- map["gross"]
        total_pay <- map["total_pay"]
        consulting_fees <- map["consulting_fees"]
        speciality_fees <- map["speciality_fees"]
        payment_mode <- map["payment_mode"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }

}

struct CardSuccess  : Mappable {
    var message : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
    }

}

struct SubscriptionList  : Mappable {
    var subscription : [Subscription]?
    
    init() {
        
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        subscription <- map["subscription"]
    }

}

struct Subscription : Mappable {
    var id : Int?
    var name : String?
    var type : String?
    var period : Int?
    var duration : String?
    var price : Float?
    var is_enabled : Int?

    init() {
        
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        period <- map["period"]
        duration <- map["duration"]
        price <- map["price"]
        is_enabled <- map["is_enabled"]
    }

}


struct ProfileSubscription : Mappable {
   var id : Int?
   var subscription_id : Int?
   var doctor_id : Int?
   var subscriptrion_start_date : String?
   var subscriptrion_end_date : String?
   var status : Int?
   var created_at : String?
   var updated_at : String?
   var details : Details?

   init?(map: Map) {

   }

   mutating func mapping(map: Map) {

       id <- map["id"]
       subscription_id <- map["subscription_id"]
       doctor_id <- map["doctor_id"]
       subscriptrion_start_date <- map["subscriptrion_start_date"]
       subscriptrion_end_date <- map["subscriptrion_end_date"]
       status <- map["status"]
       created_at <- map["created_at"]
       updated_at <- map["updated_at"]
       details <- map["details"]
   }

}


struct Details : Mappable {
    var id : Int?
    var name : String?
    var type : String?
    var period : Int?
    var duration : String?
    var price : Int?
    var is_enabled : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        period <- map["period"]
        duration <- map["duration"]
        price <- map["price"]
        is_enabled <- map["is_enabled"]
    }

}

struct GetServices : Mappable {
    var services : [Services]?
    
    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        services <- map["services"]
    }

}

struct Services : Mappable {
    var id : Int?
    var speciality_id : String?
    var name : String?
    var status : Int?
    
    init() {
        
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        speciality_id <- map["speciality_id"]
        name <- map["name"]
        status <- map["status"]
    }

}


struct SignUpResponse : Mappable {
    var first_name : String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var clinic_id : Int?
    var is_administrative : Int?
    var is_doctor : Int?
    var added_by : Int?
    var role : Int?
    var email_token : String?
    var push_device_token : String?
    var subscribe_from : String?
    var updated_at : String?
    var created_at : String?
    var id : Int?
    var regn_id : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        mobile <- map["mobile"]
        clinic_id <- map["clinic_id"]
        is_administrative <- map["is_administrative"]
        is_doctor <- map["is_doctor"]
        added_by <- map["added_by"]
        role <- map["role"]
        email_token <- map["email_token"]
        push_device_token <- map["push_device_token"]
        subscribe_from <- map["subscribe_from"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]
        id <- map["id"]
        regn_id <- map["regn_id"]
    }

}
