//
//  HealthFeedViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class HealthFeedViewController: UIViewController {

    @IBOutlet weak var tableViewHealthFeed: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }


}


extension HealthFeedViewController {
    
    
    func initialLoads() {
        registerCells()
        setDesign()
        setValues()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Add").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.addHealthFeed))

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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.height, height: 40))
        label.text = "Published Articles"
        label.textColor = .black
        headerView.addSubview(label)
        self.tableViewHealthFeed.tableHeaderView = headerView
        self.tableViewHealthFeed.separatorStyle = .none
    }
}


//MARK:- TABLEVIEW DELEGATES AND DATASOURCES

extension HealthFeedViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthFeedTableViewCell") as! HealthFeedTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.push(id: Storyboard.Ids.HealthFeedDetailsViewController, animation: true)
    }
    
    
}
