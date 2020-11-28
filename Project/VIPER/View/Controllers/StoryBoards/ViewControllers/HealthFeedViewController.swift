//
//  HealthFeedViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class HealthFeedViewController: UIViewController {

    @IBOutlet weak var tableViewHealthFeed: UITableView!
     var article : [Article] =  [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.getArticleDetail()
    }


}


extension HealthFeedViewController {
    
    
    func initialLoads() {
        registerCells()
        setDesign()
        setValues()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addHealthFeed))

        self.navigationItem.title = Constants.string.healthFeed.localize()

    }
    
    func registerCells() {
        self.tableViewHealthFeed.register(UINib(nibName: "HealthFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "HealthFeedTableViewCell")
    }
    
    @objc func addHealthFeed(){
        
        self.push(id: Storyboard.Ids.CreateHealthFeedViewController, animation: true)
    }
    
    func setValues() {
        
    }
    
    func setDesign() {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
//        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.height, height: 40))
//        label.text = "Published Articles"
//        label.textColor = .black
//        headerView.addSubview(label)
//        self.tableViewHealthFeed.tableHeaderView = headerView
        self.tableViewHealthFeed.separatorStyle = .none
    }
}


//MARK:- TABLEVIEW DELEGATES AND DATASOURCES

extension HealthFeedViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthFeedTableViewCell") as! HealthFeedTableViewCell
        cell.selectionStyle = .none
        if indexPath.row % 2 == 0{
            
            cell.publishedValue = 0
            
        }
        self.setupData(cell: cell, data: self.article[indexPath.row])
        return cell
    }
    
    func setupData(cell : HealthFeedTableViewCell , data : Article){
        cell.ArticleImage.setURLImage(data.cover_photo ?? "")
        cell.ArticleTitle.text = data.name ?? ""
        cell.ArticleTitle.text = cell.ArticleTitle.text?.capitalized
        cell.Articlecontent.text = data.description?.capitalized
        
//        cell..text = dateConvertor(data.created_at ?? "", _input: .date_time, _output: .DM)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HealthFeedDetailsViewController.initVC(storyBoardName: .main, vc: HealthFeedDetailsViewController.self, viewConrollerID: Storyboard.Ids.HealthFeedDetailsViewController)
        vc.article =  self.article[indexPath.row]
        self.push(from: self, ToViewContorller: vc)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width, height: 50))
        label.text = "Published Articles"
        headerView.backgroundColor = .white
        label.textColor = .black
        headerView.addSubview(label)
        Common.setFontWithType(to: label, size: 18.0, type: .meduim)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    
    
    
}

//Api calls
extension HealthFeedViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.ArticlesEntity:
                guard let data = dataDict as? ArticlesEntity else { return }
                self.article = data.article ?? [Article]()
                self.tableViewHealthFeed.reloadData()
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func getArticleDetail(){
        let url = "\(Base.article.rawValue)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: ArticlesEntity.self, token: true)
    }
    
}
