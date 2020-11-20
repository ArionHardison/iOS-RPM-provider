//
//  ProfieViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfieViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelQualification: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var clinictTable: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var clincList : [Clinics] = [Clinics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        self.setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.setupData()
    }
    
    func setupAction(){
        self.logoutBtn.addTap{
            self.logout()
        }
    }
    
    func setupData(){
         let data : ProfileEntity = profile
            self.profileImage.setURLImage(data.doctor?.doctor_profile?.profile_pic ?? "")
            self.labelName.text = "\(data.doctor?.first_name ?? "") \(data.doctor?.last_name ?? "")"
            self.clincList = data.clinics ?? [Clinics]()
            self.clinictTable.reloadData()
        }
    

}

extension ProfieViewController {
    
    func initialLoads(){
        
        self.profileImage.makeRoundedCorner()
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
        return self.clincList.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clinictTable.dequeueReusableCell(withIdentifier: "ClinicTableCell", for: indexPath) as! ClinicTableCell
        self.populateCell(cell: cell, data: self.clincList[indexPath.row])
        return cell
    }
    
    func populateCell(cell : ClinicTableCell , data : Clinics){
//        cell.clinitProfile.setURLImage(data.)
        cell.labelClinicName.text = data.name ?? ""
        cell.clinicAddress.text  = data.address ?? ""
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


// MARK:- PostViewProtocol

extension ProfieViewController : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        DispatchQueue.main.async {
            forceLogout()
        }
    }
    
    func showError(error: CustomError) {
        
        DispatchQueue.main.async {
            showAlert(message: error.localizedDescription, okHandler: nil, fromView: self)
        }
    }
    
    // MARK:- Logout
    
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.areYouSureWantToLogout.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            self.presenter?.HITAPI(api: Base.logout.rawValue, params: nil, methodType: .POST, modelClass: LoginModel.self, token: false)
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        
        alert.view.tintColor = .primary
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
}
