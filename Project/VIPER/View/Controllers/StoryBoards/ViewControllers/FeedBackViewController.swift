//
//  FeedBackViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/04/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {

    @IBOutlet weak var feebacksList: UITableView!
    @IBOutlet weak var labelExperienceCount: UILabel!
    @IBOutlet weak var labelPositiveCount: UILabel!
    @IBOutlet weak var labelNegativeCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedBackTableViewCell") as! FeedBackTableViewCell
        cell.selectionStyle = .none
        cell.labelName.text = "Ram"
        cell.labelVisitedFor.text = "Visited for Viral Fever"
        cell.labelComments.text = "Very Patient and impressed with his care, Listen to patient intently and in detail."
        return cell
    }
}
