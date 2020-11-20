//
//  PushHelper.swift
//  User
//
//  Created by CSS on 30/03/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
//import RealmSwift
import UIKit

class PushHelper {
    
//    private var viewController : RTCVideoChatViewController?
    
    private var lastAction : CallAction?
    private var twilioController : audioVideoCallCaontroller?
  
    
    // If the Push is Media Call Push

    
    
    //MARK:- Create Push Entity From Notification

    func handlePushNotification(notification: [AnyHashable : Any]){
        if #available(iOS 13.0, *) {
            let videoCallViewController = Router.main.instantiateViewController(identifier: "audioVideoCallCaontroller") as! audioVideoCallCaontroller
            
                 if let senderName = notification["name"] {
                        videoCallViewController.senderName = "\(senderName)"
                            }
                   
                    if let device  = notification["device"] {
                       let dev = device as? String
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if !appDelegate.isMakeCall {
                            
                        if dev  != "andoid" {
                        videoCallViewController.modalPresentationStyle = .fullScreen
                        UIApplication.topViewController()?.present(videoCallViewController, animated: true, completion:
                            {
                                //videoCallViewController.buttomView.isHidden = true
                                        videoCallViewController.RingingLbl.isHidden = false
                                if let senderId = notification["sender_id"]{
                                        videoCallViewController.senderId = "\(senderId)"
                                        }
                                                                                 
                                                                                  
                                if let receiverId = notification["receiver_id"] {
                                        videoCallViewController.receiverId = "\(receiverId)"
                                        GlobalreciveId = "\(receiverId)"
                                        }
                                if let senderId = notification["sender_id"] {
                                        GlobalsenderId = "\(senderId)"
                                        }
                                let stateCodeString = notification["video"] as? String
                                        let stateCode = Int(stateCodeString ?? "")
                               videoCallViewController.video = stateCode ?? 0
                                
                                
                                if let call =  notification["room_id"] {
                                                       
                        videoCallViewController.isCallType = call != nil ? callType.receiveCall : callType.none
                        videoCallViewController.newRoomID = call as? String ?? ""
                                    
                                    }
                                                   
                                           //      if let roomID = notification["room_id"], let senderId = notification["receiver_id"] {
                                           //
                                           //       videoCallViewController.makeTwilioCall(roomId: "\(roomID)", receiverId: "\(senderId)")
                                           //        }
                                                  
                        })
                        }
                        }else {
                            appDelegate.isMakeCall = false
                        }
                    }else {
                     videoCallViewController.modalPresentationStyle = .fullScreen
                      UIApplication.topViewController()?.present(videoCallViewController, animated: true, completion:
                        {
                           //videoCallViewController.buttomView.isHidden = true
                                              videoCallViewController.RingingLbl.isHidden = false
                                               
                                       //        if let roomID = notification["room_id"], let senderId = notification["receiver_id"] {
                                       //
                                       //            videoCallViewController.makeTwilioCall(roomId: "\(roomID)", receiverId: "\(senderId)")
                                       //        }
                                               if let senderId = notification["sender_id"]{
                                                   videoCallViewController.senderId = "\(senderId)"
                                               }
                                               if let senderName = notification["name"] {
                                                   videoCallViewController.senderName = "\(senderName)"
                                               }
                                               
                                               if let receiverId = notification["receiver_id"] {
                                                   videoCallViewController.receiverId = "\(receiverId)"
                                                   GlobalreciveId = "\(receiverId)"
                                               }
                                               if let senderId = notification["sender_id"] {
                                                   GlobalsenderId = "\(senderId)"
                                               }
                                            let stateCodeString = notification["video"] as? String
                                            let stateCode = Int(stateCodeString ?? "")
                                            videoCallViewController.video = stateCode ?? 0
                            
                            if let call =  notification["room_id"] {
                                                                              
    videoCallViewController.isCallType = call != nil ? callType.receiveCall : callType.none
    videoCallViewController.newRoomID = call as? String ?? ""
                                                                          }
                            
                      })
                       
                    }
            
        } else {
            // Fallback on earlier versions
        }
            
           // self.storyboard?.instantiateViewController(identifier: "audioVideoCallCaontroller") as! audioVideoCallCaontroller
        
     
    }
    
    
    func handleIncomingCall(pushData:NEWIncomingCallDetails,uuid:UUID){
        if #available(iOS 13.0, *) {
        let videoCallViewController = Router.main.instantiateViewController(identifier: "audioVideoCallCaontroller") as! audioVideoCallCaontroller
            self.twilioController = videoCallViewController
            videoCallViewController.modalPresentationStyle = .fullScreen
//            videoCallViewController.receiverName = pushData.name ?? ""
            videoCallViewController.video = pushData.video ?? 0
            videoCallViewController.uuid = uuid
            videoCallViewController.receiverId = pushData.receiver_id ?? ""
            videoCallViewController.senderId = "\(pushData.sender_id ?? 0)"
//            videoCallViewController.ImageUrl = pushData.receiver_image ?? ""
            videoCallViewController.newRoomID = pushData.room_id ?? ""
            print(#function, uuid)
            UIApplication.topViewController()?.present(videoCallViewController, animated: true, completion:
              {
                 videoCallViewController.isCallType = .receiveCall
//                videoCallViewController.handleCall()
                })
           }
        }
    }
    
  



