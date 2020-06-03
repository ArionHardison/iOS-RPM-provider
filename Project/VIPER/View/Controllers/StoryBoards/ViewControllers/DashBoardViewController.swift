//
//  HomeViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 11/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var buttonProfile: UIButton!
    let titles = ["Reach","Calender","Patients","Feedback","Chat","Health Feed"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }



}

extension DashBoardViewController {
    
    func initialLoads(){
        
        registerCell()
        self.buttonProfile.addTarget(self, action: #selector(ontapProfile), for: .touchUpInside)
        
    }
    
    func registerCell(){
        
        self.categoriesCollection.register(UINib(nibName: "HomeOptionCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeOptionCollectionViewCell")
    }
    
    @objc func ontapProfile(){
        
        self.push(id: Storyboard.Ids.ProfieViewController, animation: true)
    }
    
}
//MARK:- COLLECTION VIEW DELEGATES AND DATASOURCES :

extension DashBoardViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "HomeOptionCollectionViewCell", for: indexPath) as! HomeOptionCollectionViewCell
        cell.labelTitle.text = titles[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 5 {
            
            self.push(id: Storyboard.Ids.HealthFeedViewController, animation: true)
        }
        
        if indexPath.item == 3 {
            self.push(id: Storyboard.Ids.FeedBackViewController, animation: true)
        }
        
        if indexPath.item == 2 {
            self.push(id: Storyboard.Ids.PatientsViewController, animation: true)
        }
        
        if indexPath.item == 4 {
            
            self.push(id: Storyboard.Ids.ChatViewController, animation: true)
        }
        
        if indexPath.item == 1 {
            self.push(id: Storyboard.Ids.CalendarViewController, animation: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.categoriesCollection.frame.width/2.1, height: 80)
    }
   
}

