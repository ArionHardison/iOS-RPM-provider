//
//  ChatViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 25/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class ChatViewController: UIViewController {

    @IBOutlet weak var chatListTable: UITableView!
    
    var chatData : ChatHistoryEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.getChatHistory()
    }

   
}

extension ChatViewController {
    func initialLoads(){
        registerCell()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.chat.localize()

    }
    func registerCell(){
        
        self.chatListTable.tableFooterView = UIView()
        self.chatListTable.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")

    }
    
}


extension ChatViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.chatData?.chats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.chatListTable.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        tableCell.selectionStyle = .none
        if let data = self.chatData?.chats?[indexPath.row]{
            tableCell.labelName.text = (data.patient?.first_name ?? "") + " " + (data.patient?.last_name ?? "")
            tableCell.labelText.text = (data.chat_request?.messages ?? "")
            tableCell.labelTime.text = dateConvertor((data.chat_request?.started_at ?? ""), _input: .date_time, _output: .N_hour)
            tableCell.profileImage.setURLImage(data.patient?.profile?.profile_pic ?? "")
        }
        return tableCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let data = self.chatData?.chats?[indexPath.row]{
            if data.chat_request?.status == "ACCEPTED"{
            ChatManager.shared.setChannelWithChannelID(channelID: "\(data.chennel ?? "0")")
                let vc = ChatMessageViewController.initVC(storyBoardName: .main, vc: ChatMessageViewController.self, viewConrollerID: Storyboard.Ids.ChatMessageViewController)
                vc.chats = self.chatData?.chats?[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }else if data.chat_request?.status == "COMPLETED"{
                showToast(msg: "activity!!, Chat time expired, Request again",bgcolor: .red)
            }else if data.chat_request?.status == "CANCELLED"{
                showToast(msg: "activity!!, Doctor not accepted your request",bgcolor: .red)
            }
        }
       
    }
}


//Api calls
extension ChatViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.ChatHistoryEntity:
                guard let data = dataDict as? ChatHistoryEntity else { return }
                self.chatData = data
                self.chatListTable.reloadData()
                break
         
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
   
    func getChatHistory(){
        self.presenter?.HITAPI(api: Base.chatHistory.rawValue, params: nil, methodType: .GET, modelClass: ChatHistoryEntity.self, token: true)
    }
   
    
}


//ChatHistoryEntity
