//
//  SpecialititesListViewController.swift
//  MiDokter Pro
//
//  Created by Sethuram Vijayakumar on 16/12/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class SpecialititesListViewController: UIViewController {
    
    @IBOutlet weak var allergyTableView : UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var toptitleView: UIView!

    @IBOutlet weak var titleLbl: PaddingLabel!
    
    @IBOutlet weak var allergySearchBar: UISearchBar!
  
    var specialityId = [Int]()
    var specialityName = [String]()
    var onClickDone : (([String],[Int])->Void)?
    var onClickCancel : ((String)->Void)?
    var services : [Services] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpnavigation()
        self.allergyTableView.register(UINib(nibName: "FAQCell", bundle: nil), forCellReuseIdentifier: "FAQCell")
        self.allergyTableView.allowsMultipleSelection = true
    
    }
    
    
        
    func setUpnavigation() {

        self.navigationController?.isNavigationBarHidden = true

        
        Common.setFontWithType(to: doneBtn, size: 16, type: .regular)
        Common.setFontWithType(to: allergySearchBar, size: 16, type: .regular)
        Common.setFontWithType(to: titleLbl, size: 16, type: .meduim)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.titleLbl.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
    }
    func addAction(){
        
        
    }
    
    @IBAction private func backAction (sender : UIButton){
     
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction private func doneAction (sender : UIButton){
        print(specialityName)
        self.onClickDone?(specialityName,specialityId)

    }

}

extension SpecialititesListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("FaqHeaderView", owner: self, options: nil)?.first as? FaqHeaderView
        headerView?.titleLbl.text = "Specialities"
        headerView?.plusLbl.isHidden = true
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        view.backgroundColor = .clear //UIColor(named: "TextForegroundColor")
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQCell
        cell?.textLbl.text = self.services[indexPath.row].name
        cell?.accessoryType = .none
        cell?.tintColor = .AppBlueColor

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? FAQCell
        cell?.accessoryType = .checkmark
        self.specialityId.append(self.services[indexPath.row].id ?? 0)
        self.specialityName.append(self.services[indexPath.row].name ?? "")

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? FAQCell
        cell?.accessoryType = .none
        let names = self.services[indexPath.row].name
        let ids = self.specialityName.lastIndex{$0 == names}
        self.specialityName.remove(at: ids!)
        self.specialityId.remove(at: ids!)


    }

    
}
