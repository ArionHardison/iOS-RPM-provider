//
//  HealthFeedDetailsViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class HealthFeedDetailsViewController: UIViewController {

    
    @IBOutlet weak var articleImage : UIImageView!
    @IBOutlet weak var articleTitle : UILabel!
    @IBOutlet weak var articleContent : UILabel!
    @IBOutlet weak var articledate : UILabel!
    
    var article : Article =  Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.setupData(data: self.article)
    }
    

}

extension HealthFeedDetailsViewController {
    
    func initialLoads(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editClicked))
        self.navigationItem.title = Constants.string.healthFeed.localize()
        self.setFont()
    }
    
    func setFont(){
        Common.setFont(to: self.articledate)
        Common.setFont(to: self.articleTitle,isTitle: true,size: 18)
        Common.setFont(to: self.articledate)
    }
    
    @objc func editClicked(){
        
    }
    
    func setupData(data : Article){
        self.articleImage.setURLImage(data.cover_photo ?? "")
        self.articleTitle.text = data.name ?? ""
        self.articleContent.text = data.description
        self.articledate.text = dateConvertor(data.created_at ?? "", _input: .date_time, _output: .DM)
    }
    
}
