//
//  SetBoardViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/05.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SetBoardViewController: UIViewController {
    
    var defaultStore : Firestore!
    
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    
    var lockOrNot:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()
        
        lockOrNot = 0

    }

    @IBAction func addBoardBtn(_ sender: UIButton) {
        
        defaultStore.collection("DiscussionBoard").addDocument(data:[
            "ThemeOfDiscussion": themeTextField.text!,
            "DetailOfDiscussion": detailTextField.text!,
            "Lock": lockOrNot,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    @IBAction func lock(_ sender: UIButton) {
        lockOrNot = 0
    }
    
    @IBAction func unLock(_ sender: UIButton) {
        lockOrNot = 1
    }
    
}
