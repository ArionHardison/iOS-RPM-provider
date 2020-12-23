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

struct Currency : Mappable {
    var site_title : String?
    var site_logo : String?
    var site_favicon : String?
    var site_copyright : String?
    var delivery_charge : String?
    var resturant_response_time : String?
    var currency : String?
    var currency_code : String?
    var search_distance : String?
    var tax : String?
    var payment_mode : String?
    var manual_assign : String?
    var transporter_response_time : String?
    var gOOGLE_API_KEY : String?
    var android_api_key : String?
    var ios_api_key : String?
    var tWILIO_SID : String?
    var tWILIO_TOKEN : String?
    var tWILIO_FROM : String?
    var pUBNUB_PUB_KEY : String?
    var pUBNUB_SUB_KEY : String?
    var stripe_charge : String?
    var stripe_publishable_key : String?
    var stripe_secret_key : String?
    var fB_CLIENT_ID : String?
    var fB_CLIENT_SECRET : String?
    var fB_REDIRECT : String?
    var gOOGLE_CLIENT_ID : String?
    var gOOGLE_CLIENT_SECRET : String?
    var gOOGLE_REDIRECT : String?
    var aNDROID_ENV : String?
    var aNDROID_PUSH_KEY : String?
    var iOS_USER_ENV : String?
    var iOS_PROVIDER_ENV : String?
    var sUB_CATEGORY : String?
    var sCHEDULE_ORDER : String?
    var client_id : String?
    var client_secret : String?
    var pRODUCT_ADDONS : String?
    var bRAINTREE_ENV : String?
    var bRAINTREE_MERCHANT_ID : String?
    var bRAINTREE_PUBLIC_KEY : String?
    var bRAINTREE_PRIVATE_KEY : String?
    var rIPPLE_KEY : String?
    var rIPPLE_BARCODE : String?
    var eTHER_ADMIN_KEY : String?
    var eTHER_KEY : String?
    var eTHER_BARCODE : String?
    var cLIENT_AUTHORIZATION : String?
    var sOCIAL_FACEBOOK_LINK : String?
    var sOCIAL_TWITTER_LINK : String?
//    var sOCIAL_G-PLUS_LINK : String?
    var sOCIAL_INSTAGRAM_LINK : String?
    var sOCIAL_PINTEREST_LINK : String?
    var sOCIAL_VIMEO_LINK : String?
    var sOCIAL_YOUTUBE_LINK : String?
    var cOMMISION_OVER_FOOD : String?
    var cOMMISION_OVER_DELIVERY_FEE : String?
    var iOS_APP_LINK : String?
    var aNDROID_APP_LINK : String?
    var default_lang : String?
    var dEMO_MODE : String?
    var about : String?
    var help : String?
    var privacy : String?
    var chat_discount : String?
    var stripe_public_key : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        site_title <- map["site_title"]
        site_logo <- map["site_logo"]
        site_favicon <- map["site_favicon"]
        site_copyright <- map["site_copyright"]
        delivery_charge <- map["delivery_charge"]
        resturant_response_time <- map["resturant_response_time"]
        currency <- map["currency"]
        currency_code <- map["currency_code"]
        search_distance <- map["search_distance"]
        tax <- map["tax"]
        payment_mode <- map["payment_mode"]
        manual_assign <- map["manual_assign"]
        transporter_response_time <- map["transporter_response_time"]
        gOOGLE_API_KEY <- map["GOOGLE_API_KEY"]
        android_api_key <- map["android_api_key"]
        ios_api_key <- map["ios_api_key"]
        tWILIO_SID <- map["TWILIO_SID"]
        tWILIO_TOKEN <- map["TWILIO_TOKEN"]
        tWILIO_FROM <- map["TWILIO_FROM"]
        pUBNUB_PUB_KEY <- map["PUBNUB_PUB_KEY"]
        pUBNUB_SUB_KEY <- map["PUBNUB_SUB_KEY"]
        stripe_charge <- map["stripe_charge"]
        stripe_publishable_key <- map["stripe_publishable_key"]
        stripe_secret_key <- map["stripe_secret_key"]
        fB_CLIENT_ID <- map["FB_CLIENT_ID"]
        fB_CLIENT_SECRET <- map["FB_CLIENT_SECRET"]
        fB_REDIRECT <- map["FB_REDIRECT"]
        gOOGLE_CLIENT_ID <- map["GOOGLE_CLIENT_ID"]
        gOOGLE_CLIENT_SECRET <- map["GOOGLE_CLIENT_SECRET"]
        gOOGLE_REDIRECT <- map["GOOGLE_REDIRECT"]
        aNDROID_ENV <- map["ANDROID_ENV"]
        aNDROID_PUSH_KEY <- map["ANDROID_PUSH_KEY"]
        iOS_USER_ENV <- map["IOS_USER_ENV"]
        iOS_PROVIDER_ENV <- map["IOS_PROVIDER_ENV"]
        sUB_CATEGORY <- map["SUB_CATEGORY"]
        sCHEDULE_ORDER <- map["SCHEDULE_ORDER"]
        client_id <- map["client_id"]
        client_secret <- map["client_secret"]
        pRODUCT_ADDONS <- map["PRODUCT_ADDONS"]
        bRAINTREE_ENV <- map["BRAINTREE_ENV"]
        bRAINTREE_MERCHANT_ID <- map["BRAINTREE_MERCHANT_ID"]
        bRAINTREE_PUBLIC_KEY <- map["BRAINTREE_PUBLIC_KEY"]
        bRAINTREE_PRIVATE_KEY <- map["BRAINTREE_PRIVATE_KEY"]
        rIPPLE_KEY <- map["RIPPLE_KEY"]
        rIPPLE_BARCODE <- map["RIPPLE_BARCODE"]
        eTHER_ADMIN_KEY <- map["ETHER_ADMIN_KEY"]
        eTHER_KEY <- map["ETHER_KEY"]
        eTHER_BARCODE <- map["ETHER_BARCODE"]
        cLIENT_AUTHORIZATION <- map["CLIENT_AUTHORIZATION"]
        sOCIAL_FACEBOOK_LINK <- map["SOCIAL_FACEBOOK_LINK"]
        sOCIAL_TWITTER_LINK <- map["SOCIAL_TWITTER_LINK"]
//        sOCIAL_G-PLUS_LINK <- map["SOCIAL_G-PLUS_LINK"]
        sOCIAL_INSTAGRAM_LINK <- map["SOCIAL_INSTAGRAM_LINK"]
        sOCIAL_PINTEREST_LINK <- map["SOCIAL_PINTEREST_LINK"]
        sOCIAL_VIMEO_LINK <- map["SOCIAL_VIMEO_LINK"]
        sOCIAL_YOUTUBE_LINK <- map["SOCIAL_YOUTUBE_LINK"]
        cOMMISION_OVER_FOOD <- map["COMMISION_OVER_FOOD"]
        cOMMISION_OVER_DELIVERY_FEE <- map["COMMISION_OVER_DELIVERY_FEE"]
        iOS_APP_LINK <- map["IOS_APP_LINK"]
        aNDROID_APP_LINK <- map["ANDROID_APP_LINK"]
        default_lang <- map["default_lang"]
        dEMO_MODE <- map["DEMO_MODE"]
        about <- map["about"]
        help <- map["help"]
        privacy <- map["privacy"]
        chat_discount <- map["chat_discount"]
        stripe_public_key <- map["stripe_public_key"]
    }

}
