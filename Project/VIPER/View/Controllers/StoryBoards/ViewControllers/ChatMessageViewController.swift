//
//  ChatMessageViewController.swift
//  MiDokter Pro
//
//  Created by AppleMac on 25/09/20.
//  Copyright © 2020 css. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageViewController: UIViewController {
    
    
    @IBOutlet weak var chatListTable : UITableView!
    @IBOutlet weak var msgTxt : UITextField!
    @IBOutlet weak var docuploadView : UIView!
    
    @IBOutlet weak var imageuploadView : UIView!
    @IBOutlet weak var infoLbl : UILabel!
    @IBOutlet weak var messageSendBtn : UIButton!
    
    var messageDataSource:[MessageDetails]?
    var chats : Chats?
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatManager.shared.getCurrentRoomChatHistory()
        ChatManager.shared.delegate = self
        self.initailSetup()
        self.messageSend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ChatManager.shared.leftFromChatRoom()
    }
    
    func initailSetup(){
        self.setupTableViewCell()
        self.setupNavigation()
        Common.setFont(to: self.infoLbl)
        Common.setFont(to: self.msgTxt)
    }
    
    func setupNavigation(){
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Search Doctors"
        
        self.docuploadView.makeRoundedCorner()
        self.imageuploadView.makeRoundedCorner()
    }
    
    func messageSend(){
        self.messageSendBtn.addTap {
            if (self.msgTxt.text ?? "").isEmpty{
                showToast(msg: "Messge should not be empty")
            }else{
            ChatManager.shared.sentMessage(message: self.msgTxt.text ?? "", senderId: Int(UserDefaultConfig.UserID ?? "0") ?? 0, timestamp: Date().description, provider_id: (self.chats?.patient?.id ?? 0).description)
            }
        }
    }
}

//MARK:- Message Manager Delegates
extension ChatMessageViewController:ChatProtocol {
    
    func getMessageList(message: [MessageDetails]) {
        print("ChatMsgList",message)
        self.messageDataSource = message
        chatListTable.reloadData()
         self.msgTxt.text = ""
    }
}


extension ChatMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDataSource?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data : MessageDetails = self.messageDataSource?[indexPath.row]{
            if data.senderId == UserDefaultConfig.UserID{
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ChatRightCell) as! ChatRightCell
                cell.msgLbl.text = self.messageDataSource?[indexPath.row].message ?? ""
                cell.timeLbl.text = dateConvertor(self.messageDataSource?[indexPath.row].time ?? "", _input: .date_time_Z, _output: .N_hour)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ChatLeftCell) as! ChatLeftCell
                cell.msgLbl.text = self.messageDataSource?[indexPath.row].message ?? ""
                cell.timeLbl.text = dateConvertor(self.messageDataSource?[indexPath.row].time ?? "", _input: .date_time_Z, _output: .N_hour)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ChatLeftCell) as! ChatLeftCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setupTableViewCell(){
        self.chatListTable.registerCell(withId: XIB.Names.ChatRightCell)
        self.chatListTable.registerCell(withId: XIB.Names.ChatLeftCell)
    }
}
