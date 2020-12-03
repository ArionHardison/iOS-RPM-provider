//
//  FeedBackViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit
import ObjectMapper

class FeedBackViewController: UIViewController {

    @IBOutlet weak var feebacksList: UITableView!
    @IBOutlet weak var labelExperienceCount: UILabel!
    @IBOutlet weak var labelPositiveCount: UILabel!
    @IBOutlet weak var labelNegativeCount: UILabel!
    
    var feedbackList : FeedBackEntity = FeedBackEntity()
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.getFeedBackDetail()
    }


}

extension FeedBackViewController {
    
    func initialLoads(){
        
        registerCells()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.feedBack.localize()

    }
    
    func registerCells() {
        self.feebacksList.register(UINib(nibName: "FeedBackTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedBackTableViewCell")
    }
    
    func setDesign(){
        self.feebacksList.tableFooterView = UIView()
    }

}

extension FeedBackViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.i("Feedbackount====>\(self.feedbackList.feedback?.count ?? 0)")
        return self.feedbackList.feedback?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedBackTableViewCell") as! FeedBackTableViewCell
        self.setupCellData(cell: cell, data: self.feedbackList.feedback?[indexPath.row] ?? Feedback())
        return cell
    }
    //#4C65ED
    
//    2891FB - reverse
    // #A4C9FF
    func setupCellData(cell : FeedBackTableViewCell , data : Feedback){
        cell.labelName.text = "\(data.patient?.first_name ?? "") \(data.patient?.last_name ?? "")"
        self.setLbl(label: cell.labelVisitedFor, visited: "Visited for ", visitedFor: "\(data.visited_for ?? "")")
        cell.labelComments.text = data.comments ?? ""
        cell.labelTime.text = dateConvertor(data.created_at ?? "", _input: .date_time, _output: .MDY)
        if (data.experiences ?? "") == "LIKE"{
            
            cell.satusImage.setImage("thumb-like")
//            cell.satusImage.setImage("Like", .yes, .green)
        }else{
            cell.satusImage.setImage("thumb-unlike")

//            cell.satusImage.setImage("dislike", .yes, .red)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func setLbl(label : UILabel , visited : String , visitedFor : String){
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: FontCustom.regular.rawValue, size: 12), NSAttributedString.Key.foregroundColor : UIColor(named: "TextForegroundColor")] //TextBlackColor
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: FontCustom.regular.rawValue, size: 12), NSAttributedString.Key.foregroundColor : UIColor(named: "TextBlackColor")]
        
        let attributedString1 = NSMutableAttributedString(string: "\(visited)", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:"\(visitedFor)", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        label.attributedText = attributedString1
    }
}


//Api calls
extension FeedBackViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.FeedBackEntity:
                self.loader.isHideInMainThread(true)
                guard let data = dataDict as? FeedBackEntity else { return }
                
                self.populateData(data: data)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getFeedBackDetail(){
        let url = "\(Base.feedback.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: FeedBackEntity.self, token: true)
        self.loader.isHidden = false
    }
    
    
    func populateData(data : FeedBackEntity){
        self.labelExperienceCount.text = data.experiences_count?.description ?? "0"
        self.labelNegativeCount.text = data.negative_count?.description ?? "0"
        self.labelPositiveCount.text = data.positive_count?.description ?? "0"
        self.feedbackList = data
        self.feebacksList.reloadData()
    }
    
    
    
}
