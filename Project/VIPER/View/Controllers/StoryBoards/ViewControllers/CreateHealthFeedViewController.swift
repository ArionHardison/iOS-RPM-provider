//
//  CreateHealthFeedViewController.swift
//  Mi Dokter
//
//  Created by Mithra Mohan on 17/03/20.
//  Copyright © 2020 Mithra Mohan. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateHealthFeedViewController: UIViewController {
    @IBOutlet weak var labelAddArticleString: UILabel!
    @IBOutlet weak var textFieldTitle: HoshiTextField!
    @IBOutlet weak var labelAddCoverPhotoString: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var labelDescriptionString: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var buttonPublish: UIButton!
    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var addImg: UIImageView!

    var isImageAdded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()

    }
    

}

extension CreateHealthFeedViewController {
    func initialLoads(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(UIColor.white), style: .plain, target: self, action: #selector(self.backButtonClick))

        self.navigationItem.title = Constants.string.healthFeed.localize()
        self.descriptionTextView.delegate = self
        self.coverImage.addTap {
            self.chooseCoverPhoto()
        }
        self.buttonAddImage.addTarget(self, action: #selector(chooseCoverPhoto), for: .touchUpInside)
        self.setupAction()
    }
    
    func setupAction(){
        self.buttonPublish.addTap {
            if self.validation(){
                var article = ArticleReq()
                article.name = self.textFieldTitle.getText
                article.description = self.descriptionTextView.text
                self.addArticleDetail(data: article)
            }
        }
    }
    
    @objc func chooseCoverPhoto(){
        self.showImage { (image) in
            if image != nil {
                self.isImageAdded = true
                self.coverImage.image = image
            }
        }

    }
    
    func validation() -> Bool{
        if !isImageAdded{
            showToast(msg: "Add Image for your Article")
            return false
        }else if self.textFieldTitle.getText.isEmpty{
            
            showToast(msg: "Enter your Article Title")
            return false
        }else if self.descriptionTextView.text.isEmpty{
            showToast(msg: "Please Describe about your Article")
            return false
        }else{
            return true
        }
    }
}


//Api calls
extension CreateHealthFeedViewController : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch String(describing: modelClass) {
            case model.type.CommonModel:
                guard let data = dataDict as? CommonModel else { return }
                showToast(msg: data.message ?? "")
                self.popOrDismiss(animation: true)
                break
            
            default: break
            
        }
    }
    
    func showError(error: CustomError) {
        
    }
    
    func addArticleDetail(data : ArticleReq){
        let url = "\(Base.addArticle.rawValue)"
       
        var uploadimgeData:Data = Data()
        
        if  let dataImg = self.coverImage.image?.pngData() {
            uploadimgeData = dataImg
        }
        
        self.presenter?.IMAGEPOST(api: url, params: convertToDictionary(model: data) ?? ["":""], methodType: .POST, imgData: ["cover_photo":uploadimgeData], imgName: "cover_photo", modelClass: CommonModel.self, token: true)
    }
    
}

extension CreateHealthFeedViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
