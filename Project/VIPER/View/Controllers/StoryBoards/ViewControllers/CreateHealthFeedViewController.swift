//
//  CreateHealthFeedViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit

class CreateHealthFeedViewController: UIViewController {
    @IBOutlet weak var labelAddArticleString: UILabel!
    @IBOutlet weak var textFieldTitle: HoshiTextField!
    @IBOutlet weak var labelAddCoverPhotoString: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var labelDescriptionString: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var buttonPublish: UIButton!
    @IBOutlet weak var buttonAddImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()

    }
    

}

extension CreateHealthFeedViewController {
    func initialLoads(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").resizeImage(newWidth: 20), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.healthFeed.localize()

        self.buttonAddImage.addTarget(self, action: #selector(chooseCoverPhoto), for: .touchUpInside)
    }
    
    @objc func chooseCoverPhoto(){
        self.showImage { (image) in
            if image != nil {
                self.coverImage.image = image
            }
        }

    }
}
