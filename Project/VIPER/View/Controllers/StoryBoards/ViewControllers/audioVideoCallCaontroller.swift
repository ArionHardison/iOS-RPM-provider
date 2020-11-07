//
//  audioVideoCallCaontroller.swift
//  User
//
//  Created by Suren on 25/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import TwilioVideo
import CallKit
import ObjectMapper



enum callType {
    case makeCall
    case receiveCall
    case none
}



class audioVideoCallCaontroller: UIViewController {
    
    @IBOutlet weak var topLabelView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var RingingLbl: UILabel!
    @IBOutlet weak var centerEndCallBtn: UIButton!
    @IBOutlet weak var EndCallBtn: UIButton!
    @IBOutlet weak var acceptCallBtn: UIButton!
    
    @IBOutlet weak var speakerClick: UIImageView!
    @IBOutlet weak var audioClick: UIImageView!
    @IBOutlet weak var videoClick: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var buttomView: UIView!
    
      var accessToken : String?
    
      // CallKit components
      let callKitProvider: CXProvider
      let callKitCallController: CXCallController
      var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
      //var userInitiatedDisconnect: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
           let configuration = CXProviderConfiguration(localizedName: AppName)
           configuration.maximumCallGroups = 1
           configuration.maximumCallsPerCallGroup = 1
           configuration.supportsVideo = true
           configuration.supportedHandleTypes = [.generic]
           

           callKitProvider = CXProvider(configuration: configuration)
           callKitCallController = CXCallController()

           super.init(coder: aDecoder)

           callKitProvider.setDelegate(self, queue: nil)
       }
       
       deinit {
           // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
           callKitProvider.invalidate()
           
           // We are done with camera
           if let camera = self.camera {
               camera.stopCapture()
               self.camera = nil
           }
       }
    
       var ourLocalPreview : TVIVideoView?
       var audioDevice: TVIDefaultAudioDevice?
       var room: TVIRoom?
       var camera: TVICameraSource?
       var localVideoTrack: TVILocalVideoTrack?
       var localAudioTrack: TVILocalAudioTrack?
       var remoteParticipant: TVIRemoteParticipant?
       var remoteView: TVIVideoView?
       private var avPlayerHelper :  AVPlayerHelper?
       private var incomingavPlayerHelper :  AVPlayerHelper?
       
       var heightConstraint : NSLayoutConstraint!
       var widthConstraint : NSLayoutConstraint!
    
    
   
    var senderName  = String()
    var receiverName = String()
    var receiverId = String()
    var senderId = String()
    var ImageUrl = String()
    private var startTime : Date?
    private var endTime : Date?
    private var startnetworkTime : Date?
    private var endnetworkTime : Date?
    var newRoomID = String()
    var ProImage = UIImage()
    
    var audioPlayer = AVAudioPlayer()
    
    var isRecevingVideoCall : callType?
    var isServerCallType : callType = .none
    var video = 0
    var Iscamera = true
    var IsHide = false
    var isAudio = false
    var isPush = 0
    var uuid:UUID?
    
    var isCallType : callType = .none {
        didSet {
            if isCallType == callType.none {
                self.centerEndCallBtn.isHidden = false
                self.EndCallBtn.isHidden = true
                self.acceptCallBtn.isHidden = true
            }else if isCallType == callType.makeCall {
                self.nameLbl.text = self.isCallType == callType.makeCall ? "Calling \(self.receiverName)" : "\(self.senderName)"
                 self.nameLbl.font = UIFont.boldSystemFont(ofSize: 28)
                 self.centerEndCallBtn.isHidden = false
                 self.EndCallBtn.isHidden = true
                 self.acceptCallBtn.isHidden = true
                if video != 1{
                    self.topLabelView.isHidden = false
                    timerLabel.isHidden = false
                    Cache.image(forUrl: ImageUrl) { (image) in
                                    if image != nil {
                                       DispatchQueue.main.async {
                                         self.profileImage.image = image
                                 }
                            }
                    }
                }else{
                    self.topLabelView.isHidden = true
                }
                
                
            }else if isCallType == callType.receiveCall {
                self.startTimer()
                handleCall()
                self.centerEndCallBtn.isHidden = false
                self.EndCallBtn.isHidden = true
                self.acceptCallBtn.isHidden = true
                      if video == 1 {
                               self.topLabelView.isHidden = true
                               self.nameLbl.text = self.isCallType == callType.makeCall ? "Calling \(self.receiverName)" : "\(self.senderName)"
                               self.nameLbl.font = UIFont.boldSystemFont(ofSize: 28)
                               timerLabel.isHidden = true
                               self.videoClick.image = #imageLiteral(resourceName: "switchCam")
                               self.nameLbl.textColor = .white
                               self.RingingLbl.textColor = .white
                               self.profileImage.isHidden = true
                               self.SetOurLocalVideo()
                      }else{
                        self.topLabelView.isHidden = false
                        self.RingingLbl.textColor = .white
                        self.videoClick.image = #imageLiteral(resourceName: "videoOff")
                        self.videoClick.tintColor = .white
                        self.videoClick.isUserInteractionEnabled = false
                        timerLabel.isHidden = false
                        Cache.image(forUrl: ImageUrl) { (image) in
                            if image != nil {
                                DispatchQueue.main.async {
                                    self.profileImage.image = image
                                }
                            }
                        }
                     }
                self.nameLbl.text = self.receiverName
                self.nameLbl.font = UIFont.boldSystemFont(ofSize: 28)
            }
        }
    }
    private var seconds : Int = 0
    private var minutes : Int = 0
    private var Networkseconds : Int = 0
    private var Networkminutes : Int = 0
    
    
    private var timer : Timer?
    private var networktimer : Timer?
    
    private lazy var loader : UIView = {
        
        return createActivityIndicator(self.view)
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(CallEnd), name: Notification.Name("CALLEND"), object: nil)
       setnav()
       setCornerRadius()
        if video == 1 {
             self.profileImage.isHidden = true
             SetOurLocalVideo()
         }
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.makeTwilioCall(roomId: <#T##String#>, receiverId: <#T##String#>)
        initialLoad()
    }
    
    @objc func CallEnd(){
        self.cleanupRemoteParticipant()
        self.avPlayerHelper?.stop()
        networkstopTimer()
        self.room = nil
        self.initmateServer()
        if self.isCallType != .none {
            rejectTwilioCall(roomId: self.newRoomID, receiverId: receiverId)
        }
        self.callKitCompletionHandler = nil
    }
    
    
      private func setnav(){
           self.title = "Voice call"
           self.navigationController?.isNavigationBarHidden = false
           self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,action: #selector(backAction))
       }
    
    @IBAction func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
     private func SetOurLocalVideo(){
        self.ourLocalPreview = TVIVideoView()
        
         //self.view.addSubview(ourLocalPreview!)
       // self.view.insertSubview(self.ourLocalPreview!, at: 0)
        
        [self.ourLocalPreview].forEach { (view) in
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        self.ourLocalPreview?.contentMode = .scaleToFill
        
        self.ourLocalPreview?.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!)
        
        //self.ourLocalPreview?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.videoView.addSubview(ourLocalPreview!)
        self.ourLocalPreview?.delegate = self
        startPreview()
    }
    
    func startPreview() {
           if PlatformUtils.isSimulator {
               return
           }
           
           var frontCamera = TVICameraSource.captureDevice(for: .front)
           var backCamera = TVICameraSource.captureDevice(for: .back)
           
           if (frontCamera != nil || backCamera != nil) {
               // Preview our local camera track in the local video preview view.
               camera = TVICameraSource(delegate: self)
               localVideoTrack = TVILocalVideoTrack.init(source: camera!, enabled: true, name: "Camera")
               
               
               //Add renderer to video track for local preview
               localVideoTrack?.addRenderer(self.ourLocalPreview ?? TVIVideoView())
            
               
               if (frontCamera != nil && backCamera != nil) {
                    //We will flip camera on tap.
                   let tap = UITapGestureRecognizer(target: self, action: #selector(viewhideAni))
                   self.ourLocalPreview?.addGestureRecognizer(tap)
               }
                                if self.Iscamera == true{
                                    self.Iscamera = false
                                    backCamera = nil
                                }else{
                                    self.Iscamera = true
                                    frontCamera = nil
                                }
          
               camera!.startCapture(with: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                  if error != nil {
                      
                   } else {

                   }
              
               }
           }
           else {
              self.logMessage(messageText:"No front or back capture device found!")
           }
       }
    
    
    

}

extension audioVideoCallCaontroller {
    func logMessage(messageText: String) {
        NSLog(messageText)
        print(messageText)
    }
    
    @objc func viewhideAni(){
        if IsHide == false{
            IsHide = true
            self.buttomView.isHidden = true
            self.centerEndCallBtn.isHidden = true
        }else
        {
            IsHide = false
            self.buttomView.isHidden = false
            self.centerEndCallBtn.isHidden = false
        }
           
        
    }
    
    
    
    private func setCornerRadius(){
        [self.EndCallBtn,self.centerEndCallBtn,self.acceptCallBtn,self.speakerClick,self.videoClick,self.audioClick].forEach { (view) in
               view?.layer.cornerRadius = (view?.frame.height)! / 2
               view?.layer.masksToBounds = true
           }
       }
    
    private func initialLoad(){
           [self.EndCallBtn,self.centerEndCallBtn,self.acceptCallBtn,self.speakerClick,self.videoClick,self.audioClick].forEach { (view) in
               view.isUserInteractionEnabled = true
           }
           self.EndCallBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endCallAction)))
           self.centerEndCallBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endCallAction)))
           self.acceptCallBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Accept)))
        
           self.videoClick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCameraAction)))
           self.speakerClick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loudspeaker)))
           self.audioClick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(muteVoiceAction)))
           
           if isCallType == .receiveCall {
               self.incomingavPlayerHelper = AVPlayerHelper()
               self.incomingavPlayerHelper?.play(file: "incoming.aiff")
               self.isCallType = .receiveCall
               self.centerEndCallBtn.isHidden = true
               self.EndCallBtn.isHidden = false
               self.acceptCallBtn.isHidden = false
               timerLabel.isHidden = false
        
            if video == 1 {
                timerLabel.isHidden = true
                self.videoClick.image = #imageLiteral(resourceName: "switchCam")
                self.nameLbl.textColor = .white
                self.RingingLbl.textColor = .white
                self.profileImage.isHidden = true
                self.SetOurLocalVideo()
            }
           }else if isCallType == .makeCall{
                timerLabel.isHidden = false
                self.isCallType = .makeCall
                self.centerEndCallBtn.isHidden = false
                self.EndCallBtn.isHidden = true
                self.acceptCallBtn.isHidden = true
                self.videoClick.image = #imageLiteral(resourceName: "videoOff")
                self.videoClick.tintColor = .white
                self.videoClick.isUserInteractionEnabled = false
           }
        
       }
    
    @IBAction func endCallAction(){
        performEndCallAction(uuid: self.uuid ?? UUID())
        networkstopTimer()
        room?.disconnect()
        self.rejectTwilioCall(roomId: self.newRoomID, receiverId: self.receiverId)
        if isCallType == callType.none || isCallType == callType.makeCall {
            performEndCallAction(uuid: self.uuid ?? UUID())
        }else{
            //let appdelagate = UIApplication.shared.delegate as? AppDelegate
           // appdelagate?.performEndCallAction(uuid: self.uuid!)
             performEndCallAction(uuid: self.uuid ?? UUID())
        }
        self.dismiss(animated: true, completion:nil)
 
       }
    
    @IBAction func Accept(){
            networkstopTimer()
            handleCall()
        }
          
    
    
    func handleCall(roomId : String = "", receiverId : String = "",isVideo: Int = 0){
       
          if video == 1 {
             self.videoClick.image = #imageLiteral(resourceName: "switch-1")
             self.nameLbl.textColor = .white
             self.RingingLbl.textColor = .white
             self.profileImage.isHidden = true
             self.SetOurLocalVideo()
             
          }else{
             self.videoClick.image = #imageLiteral(resourceName: "video-camera")
             self.videoClick.tintColor = .white
             self.videoClick.isUserInteractionEnabled = false
        }
        self.nameLbl.text = self.isCallType == callType.makeCall ? "Calling \(self.receiverName)" : "\(self.senderName)"
        self.nameLbl.font = UIFont.boldSystemFont(ofSize: 28)

        
          DispatchQueue.main.async {
                
            if self.isCallType == callType.none {
                self.popOrDismiss(animation: true)
                self.isPush = 1
            }
            else if self.isCallType == callType.makeCall{
               self.newRoomID = roomId
               self.RingingLbl.text = "Ringing..."
               self.timerLabel.text = ""
               self.incomingavPlayerHelper = AVPlayerHelper()
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               appDelegate.isMakeCall = true
               self.isPush = 1
               self.makeTwilioCall(roomId: self.newRoomID, receiverId: receiverId)
               
                
            }else if self.isCallType == callType.receiveCall {
                self.isServerCallType = callType.receiveCall
                self.isPush = 0
                self.makeTwilioCall(roomId: self.newRoomID, receiverId: self.receiverId)
                
           }
         }

       }
    
       
       @IBAction func muteVoiceAction(){
           if (self.localAudioTrack != nil) {
               self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
               
               // Update the button title
               if (self.localAudioTrack?.isEnabled == true) {
                    self.audioClick.image = #imageLiteral(resourceName: "audioOff")
                   
               } else {
                    self.audioClick.image = #imageLiteral(resourceName: "audioOff")
              }
           }
       }
       
    @IBAction func flipCameraAction(){
        var newDevice: AVCaptureDevice?

        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = TVICameraSource.captureDevice(for: .back)
            } else {
                newDevice = TVICameraSource.captureDevice(for: .front)
            }

            if let newDevice = newDevice {
                camera.select(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.ourLocalPreview?.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
       // startPreview()
        
    }
    
    @IBAction func loudspeaker(){
        
        let isSpeakerON =  avPlayerHelper?.changeAudioOutput() ?? true
        print(isSpeakerON)
        self.speakerClick.image = isSpeakerON ? #imageLiteral(resourceName: "muteSpeakernew") : #imageLiteral(resourceName: "newspeaker")
               
    }
    
}

extension audioVideoCallCaontroller {
    //  *********************  makecall *******************
    
    
        func makeTwilioCall(roomId : String,receiverId :String) {
            
            let baseUrl = isCallType == callType.receiveCall ? Base.twilioMakeCall.rawValue : Base.twilioMakeCall.rawValue
            var url = String()
            
            if self.isCallType == .makeCall {
                url = "\(baseUrl)?room_id=\(UserDefaultConfig.UserID)_video_\(receiverId)&hospital_id=\(UserDefaultConfig.UserID)&patient_id=\(receiverId)"
                self.newRoomID = "\(UserDefaultConfig.UserID)_video_\(receiverId)"
            
            }else {
                url =  "\(baseUrl)?room_id=\(receiverId)_video_\(UserDefaultConfig.UserID)&hospital_id=\(UserDefaultConfig.UserID)&patient_id=\(receiverId)"
                self.newRoomID = "\(UserDefaultConfig.UserID)_video_\(receiverId)"

            }
//            self.accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2VhNTY2NzU2YmZmNDFkZDBhNDkxZDQ1MWVlMWY3NjA1LTE2MDQ0MzUyODciLCJpc3MiOiJTS2VhNTY2NzU2YmZmNDFkZDBhNDkxZDQ1MWVlMWY3NjA1Iiwic3ViIjoiQUMwYWYyMTc2NzU3YjNjN2I3YzFiOWJiOWZlMTFkZWUwNCIsImV4cCI6MTYwNDQzODg4NywiZ3JhbnRzIjp7ImlkZW50aXR5IjoidXNlcl8yMV8xIiwidmlkZW8iOnsicm9vbSI6IjZfdmlkZW9fXzIxIn19fQ.hvquS1UR5eIU0-SjI-meK-0tVFfAHkaqA2-6NnzTOU8"
            self.uuid = UUID()

//            self.performStartCallAction(uuid: uuid!, roomName: self.newRoomID)
            
            self.presenter?.HITAPI(api: url, params:nil, methodType: .GET, modelClass: TwilioAccess.self, token: true)
//            self.presenter?.get(api: .Callprocess, url: url ?? "")

        }
    
    
    
    
    private func callVideoMethod(accessToken: String){
       self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = TVIConnectOptions.init(token:  accessToken) { (builder) in
            
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
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            if self.isServerCallType == .makeCall {
            builder.roomName = "\(User.main.id ?? 0)_chats_\(self.receiverId)"
            }else if self.isServerCallType == .receiveCall {
            builder.roomName = self.newRoomID
            }

        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
       // logMessage(messageText: "Attempting to connect to room \(String(describing: roomName))")
        
       // self.showRoomUI(inRoom: true)
        
        self.callKitCompletionHandler!(true)
        
        
    }
    
    
      func prepareLocalMedia() {
            
            // We will share local audio and video when we connect to the Room.
            // Create an audio track.
            if (localAudioTrack == nil) {
                localAudioTrack = TVILocalAudioTrack()//TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
                
                if (localAudioTrack == nil) {
                   // logMessage(messageText: "Failed to create audio track")
                }
            }
            
            // Create a video track which captures from the camera.
            if (localVideoTrack == nil) {
                self.startPreview()
            }
        }
    
    func holdCall(onHold: Bool) {
           localAudioTrack?.isEnabled = !onHold
           localVideoTrack?.isEnabled = !onHold
       }
}



// MARK: TVICameraSourceDelegate
extension audioVideoCallCaontroller : TVICameraSourceDelegate {
    func cameraSource(_ source: TVICameraSource, didFailWithError error: Error) {
       // logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}


// MARK: TVIRoomDelegate
extension audioVideoCallCaontroller : TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
        print("Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity ?? ""))")
        networkTimer()
        self.avPlayerHelper = AVPlayerHelper()
        if self.isCallType == .makeCall {
         avPlayerHelper?.playThrough(speaker: .speaker)
         self.loudspeaker()
         self.avPlayerHelper?.play(file: "RingOutgoing.aiff")
         avPlayerHelper?.playThrough(speaker: .speaker)
        }else{
         self.loudspeaker()
        }
       self.callConnected(room: room)

      //  self.startTimer()
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
       // logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        self.cleanupRemoteParticipant()
        self.avPlayerHelper?.stop()
        //self.incomingavPlayerHelper?.stop()
        networkstopTimer()
        self.room = nil
        self.initmateServer()
        if self.isCallType != .none {
            rejectTwilioCall(roomId: self.newRoomID, receiverId: receiverId)
        }
        self.callKitCompletionHandler = nil
       
      
        
    }
    func rejectTwilioCall(roomId : String,receiverId :String) {
        cleanupRemoteParticipant()
        networkstopTimer()
        self.initmateServer()
//        let baseUrl = twilioEndCallUrl
//        var url :String?
//        //  let url = URL(string: "\(baseUrl)room_id=\(roomId)&id=\(receiverId)")
//        url =  "\(baseUrl)id=\(receiverId)&room_id=\("\(User.main.id ?? 0)_chats\(receiverId)")&current_user_id=\(User.main.id ?? 0)&video=\(self.video)"
//        self.presenter?.get(api: .Callprocess, url: url ?? "")
        
    }
   
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
      
        print("Failed to connect to room with error")
        self.room = nil
    
    }
    
    func room(_ room: TVIRoom, isReconnectingWithError error: Error) {
        
        print("Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func didReconnect(to room: TVIRoom) {
       
        print("Reconnected to room \(room.name)")
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
        }
        if video == 0{
            nameLbl.isHidden = false
            timerLabel.isHidden = false
            RingingLbl.isHidden = true
            self.nameLbl.textColor = .white
            self.timerLabel.textColor = .white
            
        }
  
        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == participant) {
            cleanupRemoteParticipant()
        }
        //logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
      // ??????????" call disconnect"
        print("Room \(room.name), Participant \(participant.identity) disconnected")
        self.endCallAction()
    }
}

// MARK: TVIRemoteParticipantDelegate
extension audioVideoCallCaontroller : TVIRemoteParticipantDelegate {
  
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
        
        // Remote Participant has offered to share the video Track.
        
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
        
        // Remote Participant has stopped sharing the video Track.
        
        
        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
        
        // Remote Participant has offered to share the audio Track.
        
       
        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
        
        // Remote Participant has stopped sharing the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
 func subscribed(to videoTrack: TVIRemoteVideoTrack, publication: TVIRemoteVideoTrackPublication, for participant: TVIRemoteParticipant) {
        
        // We are subscribed to the remote Participant's video Track. We will start receiving the
        // remote Participant's video frames now.
        self.avPlayerHelper?.stop()
       // self.incomingavPlayerHelper?.stop()
        self.Networkseconds = 0
        self.Networkminutes = 0
        networkstopTimer()
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        
    if (self.remoteParticipant == participant) {
        if (video == 1){
            setupRemoteVideoView()
            localVideoTrack?.removeRenderer(self.remoteView!)
            videoTrack.addRenderer(self.remoteView!)
            remoteView?.contentMode = .scaleAspectFit
        }
            self.strintLocalView()
            self.isCallType = .none
            //labelReceiverName.isHidden = true
        }

    }
    
    private func strintLocalView(){
        if (video == 1){
            self.profileImage.isHidden = true
            self.ourLocalPreview?.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.ourLocalPreview?.frame = CGRect(x: 16, y: 100, width: 130 ,height: 180)
            self.ourLocalPreview?.layer.cornerRadius = 15
            
        }
    }
    
    func setupRemoteVideoView() {
        // Creating `TVIVideoView` programmatically
        self.remoteView = TVIVideoView.init(frame: CGRect.zero, delegate:self)
        
        self.videoView.insertSubview(self.remoteView!, at: 0)
        
        self.remoteView!.contentMode = .scaleAspectFill;
        
        let centerX = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.videoView,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.videoView.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.videoView,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.videoView.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView!,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.videoView,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.videoView.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView!,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.videoView,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.videoView.addConstraint(height)
        self.nameLbl.isHidden = true
        self.RingingLbl.isHidden = true
        self.timerLabel.isHidden = true
    }
    
    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
                      publication: TVIRemoteVideoTrackPublication,
                      for participant: TVIRemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        self.avPlayerHelper?.stop()
        networkstopTimer()
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
       
        self.isCallType = callType.none
        if (self.remoteParticipant == participant) {
            if video == 1{
                videoTrack.removeRenderer(self.remoteView!)
                self.remoteView?.removeFromSuperview()
                self.remoteView = nil
            }
           
        }
    }
    
    func subscribed(to audioTrack: TVIRemoteAudioTrack,
                    publication: TVIRemoteAudioTrackPublication,
                    for participant: TVIRemoteParticipant) {
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        self.isCallType = .none
        self.startTimer()
        self.Networkseconds = 0
        self.Networkminutes = 0
        self.avPlayerHelper?.stop()
        self.incomingavPlayerHelper?.stop()
        networkstopTimer()
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
                      publication: TVIRemoteAudioTrackPublication,
                      for participant: TVIRemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        self.initmateServer()
        self.stopTimer()
        self.Networkseconds = 0
        self.Networkminutes = 0
        self.avPlayerHelper?.stop()
        networkstopTimer()
        self.incomingavPlayerHelper?.stop()
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
       logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// ********************** CALL *****************
extension audioVideoCallCaontroller {
    
    private func callConnected(room : TVIRoom){
    if (room.remoteParticipants.count > 0) {
        self.remoteParticipant = room.remoteParticipants[0]
        self.remoteParticipant?.delegate = self
       }
        self.buttomView.isHidden = false
        //self.RingingLbl.isHidden = true
        
    }
    
    func cleanupRemoteParticipant() {
        if ((self.remoteParticipant) != nil) {
            if ((self.remoteParticipant?.videoTracks.count)! > 0) {
                if video == 1{
                let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
                remoteVideoTrack?.removeRenderer(self.remoteView!)
                self.remoteView?.removeFromSuperview()
                self.remoteView = nil
                }
            }
        }
        self.remoteParticipant = nil
        self.popOrDismiss(animation: true)
    }
    
}




// ********** Timer *****************
extension audioVideoCallCaontroller {
    
    func startTimer(){
        
        self.seconds = 0
        self.minutes = 0
        self.startTime = Date()
        
        DispatchQueue.main.async {
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                
                if self.seconds == 60 {
                    
                    self.minutes += 1
                    self.seconds = 0
                    
                } else {
                    
                    self.seconds += 1
                }
                
                DispatchQueue.main.async {
                    self.timerLabel.text = "\(Formatter.shared.makeMinimum(number: NSNumber(value: self.minutes), digits: 2)) : \(Formatter.shared.makeMinimum(number: NSNumber(value: self.seconds), digits: 2))"
                }
                
            })
            
        }
        
        
        
        timer?.fire()
    }
    
    
    func networkTimer(){
        
        self.Networkseconds = 0
        self.Networkminutes = 0
        self.startnetworkTime = Date()
        
        DispatchQueue.main.async {
            
            self.networktimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if self.Networkseconds == 60 {
                    
                    DispatchQueue.main.async {
                        self.endCallAction()
                    }
                    
                } else {
                    self.Networkminutes += 1
                }
                
            
            })
            
        }
        
        networktimer?.fire()
    }
    
    func networkstopTimer(){
        
        self.networktimer?.invalidate()
        self.endnetworkTime = Date()
    }
    
    //MARK:- Stop Timer
    
    func stopTimer(){
        
        self.timer?.invalidate()
        self.endTime = Date()
    }
    
    private func initmateServer(){

    }
}

// MARK: TVIVideoViewDelegate
extension audioVideoCallCaontroller : TVIVideoViewDelegate {
    
    func videoViewDidReceiveData(_ view: TVIVideoView) {
        
    }
    
    func videoView(_ view: TVIVideoView, videoOrientationDidChange orientation: TVIVideoOrientation) {
        self.view.setNeedsLayout()
    }
    
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        
    
    }
    
}


extension audioVideoCallCaontroller : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any){
        switch String(describing: modelClass) {
         
            
                    case model.type.TwilioAccess:
                    guard let data = dataDict as? TwilioAccess else { return }
                    self.accessToken = data.accessToken
                    if self.isCallType == .receiveCall {
                       self.isServerCallType = .receiveCall
                               
//                        self.performRoomConnect(roomName: self.newRoomID) { (success) in
//                       print("sucsess")
//                       }
                   }else {
                       self.uuid = UUID()
                       self.isServerCallType = .makeCall
                    self.performStartCallAction(uuid: self.uuid!, roomName: self.newRoomID)
                   }
      
           
             break
            default: break
        }
}
            

    
    func showError(error: CustomError) {
        
    }
    
    
}


 
