//
//  BlockCalendarViewController.swift
//  Project
//
//  Created by Vinod Reddy Sure on 23/05/20.
//  Copyright © 2020 css. All rights reserved.
//

import UIKit

class BlockCalendarViewController: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonBlockCalendar: UIButton!
    @IBOutlet weak var textFieldToData: UITextField!
    @IBOutlet weak var textFieldToTime: UITextField!
    @IBOutlet weak var textFieldFromTime: UITextField!
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textViewReason: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        intialLoads()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }

}

extension BlockCalendarViewController {
    func intialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.string.Cancel.localize(), style: .done, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.blockCalenar.localize()

        self.buttonCancel.addTarget(self, action: #selector(buttonCancelAction), for: .touchUpInside)

    }
    
    @IBAction func buttonCancelAction() {
        self.backButtonClick()
    }

}
