//
//  AppDelegate.swift
//  Goheavy
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import IQKeyboardManagerSwift
import UserNotifications
import PushKit
import CallKit
import AVFoundation
import Intents
import AVKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isMakeCall : Bool = false
    var roomName:String?
    var pushData:NEWIncomingCallDetails?
    var uuid:UUID?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        appearence()
        setGoogleMapKey()
       IQKeyboardManager.shared.enable = true
        setLocalization(language: Language.english)
        let navigationController = Router.createModule()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        self.registerPush(forApp: application)
        self.pushRegister()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
              guard let viewController = window?.rootViewController as? audioVideoCallCaontroller, let interaction = userActivity.interaction else {
                  return false
              }

              var personHandle: INPersonHandle?

              if let startVideoCallIntent = interaction.intent as? INStartVideoCallIntent {
                  personHandle = startVideoCallIntent.contacts?[0].personHandle
              } else if let startAudioCallIntent = interaction.intent as? INStartAudioCallIntent {
                  personHandle = startAudioCallIntent.contacts?[0].personHandle
              }

//              if let personHandle = personHandle {
//
//                PushHelper().handlePushNotification(notification: notifyDict!)
//                audioVideoCallCaontroller.performStartCallAction(uuid: UUID(), roomName: personHandle.value)
//              }
        
        if let personHandle = personHandle {
            viewController.performStartCallAction(uuid: UUID(), roomName: personHandle.value)
        }

              return true
          }
    
    
    private func setGoogleMapKey(){
        
        GMSServices.provideAPIKey(googleMapKey)
        
    }
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    // MARK:- Appearence
       private func appearence() {
           
//           if let languageStr = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: languageStr) {
//               setLocalization(language: language)
//           }else {
//               setLocalization(language: .spanish)
//           }
        UINavigationBar.appearance().barTintColor = .primary
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        var attributes = [NSAttributedString.Key : Any]()
        attributes.updateValue(UIColor.white, forKey: .foregroundColor)
        UINavigationBar.appearance().titleTextAttributes = attributes
           if #available(iOS 11.0, *) {
               UINavigationBar.appearance().largeTitleTextAttributes = attributes
           }
           
           UIPageControl.appearance().pageIndicatorTintColor = .lightGray
           UIPageControl.appearance().currentPageIndicatorTintColor = .primary
           UIPageControl.appearance().backgroundColor = .clear
           
       }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        // Messaging.messaging().apnsToken = deviceToken
       
        print("Apn Token ", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
//        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        push_device_token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification  :  ", notification)
        
        completionHandler(.newData)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Error in Notification  \(error.localizedDescription)")
    }
    

    
    
    // Register push
    
    private func pushRegister(){
        
        let pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        
    }

    
}

extension AppDelegate:CXProviderDelegate{
   func providerDidReset(_ provider: CXProvider) {
       print("resetttt")
   }
   
   func performEndCallAction(uuid: UUID) {
       self.uuid = uuid
       print(uuid)
       let endCallAction = CXEndCallAction(call: uuid)
       let transaction = CXTransaction(action: endCallAction)
       let callKitCallController = CXCallController()
           callKitCallController.request(transaction) { error in
               if let error = error {
                   NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
                   return
               }
               
               NSLog("EndCallAction transaction request successful")
           }
   }
   
   
   func rejectTwilioCall(roomId : String,receiverId :String ,video : Int,isPush:Int) {
       
       
//   let url =  "\("/api/user/video/decline/token?")id=\(receiverId)&room_id=\(roomId)&current_user_id=\(User.main.id ?? 0)&video=\(video)"
       
       
       
   }
   
   func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
       print("answer")
       print("RoomName.....\(pushData?.room_id ?? "")")
       print("UUID.....\((#function, self.uuid))")
       if let pushData = pushData {
           PushHelper().handleIncomingCall(pushData: pushData,uuid:self.uuid!)
       }
       action.fulfill()
   }
   
   func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
       print("end call")
       provider.reportCall(with: self.uuid!, endedAt: Date(), reason: .remoteEnded)
       action.fulfill()
   }
   

   
   
}


extension AppDelegate : PKPushRegistryDelegate {
   
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        
        print("PK Token ", pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
        let deviceTokenRegister = pushCredentials.token.hexString
        print(deviceTokenRegister)
        deviceTokenString = deviceTokenRegister
        UserDefaults.standard.set(deviceTokenRegister, forKey: WebConstants.string.device_token)
        print("pushRegistry -> deviceToken :\(deviceTokenString)")
        
    }
    
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        
             var  GetData = NEWIncomingCallDetails()
             let dict = payload.dictionaryPayload
             let extraPayload = dict["extraPayLoad"] as! [String:Any]
             print(extraPayload)
           //  GetData.key  = extraPayload["key"] as? String
             GetData.video  = Int("\(extraPayload["video"] as? String ?? "0")")
             GetData.accesstoken  = extraPayload["accesstoken"] as? String
             GetData.type  = extraPayload["type"] as? String
             GetData.room_id  = extraPayload["room_id"] as? String
             GetData.receiver_image  = extraPayload["receiver_image"] as? String
             GetData.receiver_id  = extraPayload["receiver_id"] as? String
             GetData.name  = extraPayload["name"] as? String
             GetData.sender_id  = extraPayload["sender_id"] as? Int
             GetData.incomingcall  = extraPayload["incomingcall"] as? Int
             uuid = UUID()
             pushData = GetData
        
            let hasVideo = true
            let handleName = pushData?.name ?? ""
        initiateCallKit(value: handleName, hasVideo: hasVideo, uuid: uuid ?? UUID()) { }
        
        
//                  let isIncomingcall = pushData?.incomingcall == 1
//                  if isIncomingcall {
//                    initiateCallKit(value: handleName, hasVideo: hasVideo, uuid: uuid ?? UUID()) { }
//                  }else{
//                    NotificationCenter.default.post(name: Notification.Name("CALLEND"), object: "yes")
//                }
    

            
        print("Incoming  \(#function)", payload.dictionaryPayload)
     
    }
    

    
}

extension AppDelegate {
   
   func initiateCallKit(value:String, hasVideo:Bool, uuid:UUID, completion: @escaping ()->Void){
        let configuration = CXProviderConfiguration(localizedName: AppName)
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.generic]
        
        let callKitProvider = CXProvider(configuration: configuration)
        callKitProvider.setDelegate(self, queue: nil)
        
        let callHandle = CXHandle(type: .generic, value: value)
        
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = callHandle
        callUpdate.supportsDTMF = false
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = hasVideo
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.videoChat, options: .mixWithOthers)
            if hasVideo{
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            }else {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Speaker error : \(error)")
        }
        
        callKitProvider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if error == nil {
                NSLog("Incoming call successfully reported.")
            } else {
                NSLog("Failed to report incoming call successfully: \(String(describing: error?.localizedDescription)).")
                if let err = error{
                   print(err)
                }
            }
             completion()
           
        }
    }
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
