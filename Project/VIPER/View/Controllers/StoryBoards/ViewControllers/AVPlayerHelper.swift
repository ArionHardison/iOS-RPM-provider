//
//  AVPlayerHelper.swift
//  User
//
//  Created by CSS on 03/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerHelper {
    
    private var player : AVAudioPlayer?
    //MARK:- Play audio
    
    
    
    func playThrough(speaker with:AVAudioSession.PortOverride = .speaker){
            let audioSession = AVAudioSession.sharedInstance()
          do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         mode: AVAudioSession.Mode.default)
              try audioSession.overrideOutputAudioPort(with)
              try audioSession.setActive(true)
          }catch let err {
              print("err.......\(err.localizedDescription)")
          }
      }
      
      func changeAudioOutput()->Bool? {
          let currentRoute = AVAudioSession.sharedInstance().currentRoute
          for output in currentRoute.outputs {
              switch output.portType {
              case AVAudioSession.Port.builtInSpeaker:
                  playThrough(speaker: .none)
                  return false
              default:
                  playThrough(speaker: .speaker)
                  return true
              }
          }
           return true
      }
    
    func play(file name : String? = "outgoing.aiff", isLooped : Bool = true){
        
        if let path = Bundle.main.path(forResource: name, ofType: nil){
            
            let url = URL(fileURLWithPath: path)
            
            do {
                
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player?.numberOfLoops = isLooped ? Int.max : 0
                self.player?.play()
                
            } catch let err {
                
                
                print("Error in playing audio ",err.localizedDescription)
            }
            
        }
    }
    
    //MARK:- Stop Audio
    
    func stop(){
        
        self.player?.stop()
        
    }
    
}

