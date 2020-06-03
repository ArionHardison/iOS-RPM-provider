//
//  ProfieViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class ProfieViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelQualification: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var clinictTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension ProfieViewController {
    
    func initialLoads(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: .plain, target: self, action: #selector(editProfile))
        //self.navigationItem.title = Constants.string.healthFeed.localize()
    }
    
    @objc func editProfile(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.EditProfileTableViewController) as! EditProfileTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfieViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clinictTable.dequeueReusableCell(withIdentifier: "ClinicTableCell", for: indexPath) as! ClinicTableCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


class ClinicTableCell : UITableViewCell {
    @IBOutlet weak var clinitProfile: UIImageView!
    @IBOutlet weak var labelClinicName: UILabel!
    @IBOutlet weak var clinicAddress: UILabel!
    
}
