//
//  TwilioViewController+CallKit.swift
//  User
//
//  Created by JeyaVignesh on 12/08/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import CallKit
import TwilioVideo

extension audioVideoCallCaontroller:CXProviderDelegate{
    
    func providerDidReset(_ provider: CXProvider) {
        logMessage(messageText: "providerDidReset:")
        
        // AudioDevice is enabled by default
        // self.audioDevice.isEnabled = true
        
        room?.disconnect()
    }
    
    func providerDidBegin(_ provider: CXProvider) {
        logMessage(messageText: "providerDidBegin")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        logMessage(messageText: "provider:didActivateAudioSession:")
        
        //  self.audioDevice.isEnabled = true
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        logMessage(messageText: "provider:didDeactivateAudioSession:")
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        logMessage(messageText: "provider:timedOutPerformingAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
         print(#function, action.callUUID)
        logMessage(messageText: "provider:performStartCallAction:")
        performRoomConnect(roomName: action.handle.value) { (success) in
            if (success) {
                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
                action.fulfill()
            } else {
                action.fail()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
         print(#function, action.callUUID)
        logMessage(messageText: "provider:performAnswerCallAction:")
        performRoomConnect(roomName:self.newRoomID) { (success) in
            if (success) {
                action.fulfill(withDateConnected: Date())
            } else {
                action.fail()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        logMessage(messageText: "provider:performEndCallAction:")
        room?.disconnect()
        print(#function, action.callUUID)
        provider.reportCall(with: action.uuid, endedAt: Date(), reason: .remoteEnded)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provier:performSetMutedCallAction:")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        
    }
}


extension audioVideoCallCaontroller {
    func performStartCallAction(uuid: UUID, roomName: String?) {
        let callHandle = CXHandle(type: .generic, value: roomName ?? "")
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        print(#function, uuid)
        let transaction = CXTransaction(action: startCallAction)
        if self.video == 1 {
            startCallAction.isVideo = true
        }
        callKitCallController.request(transaction)  { error in
            if let error = error {
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            NSLog("StartCallAction transaction request successful")
            print(error as Any)
        }
    }
    
    func performEndCallAction(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
       
            callKitCallController.request(transaction) { error in
                if let error = error {
                    NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
                    return
                }
                NSLog("EndCallAction transaction request successful")
            }
    }
    
    func performRoomConnect(roomName: String? , completionHandler: @escaping (Bool) -> Swift.Void) {
        
       // self.incomingavPlayerHelper = AVPlayerHelper()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isMakeCall = true
        prepareLocalMedia()
        let connectOptions = TVIConnectOptions.init(token:  (self.accessToken ?? "")) { (builder) in
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [TVILocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [TVILocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            builder.roomName = roomName
        }
        
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
        
        self.callKitCompletionHandler = completionHandler
    }

}
