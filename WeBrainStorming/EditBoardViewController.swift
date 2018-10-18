//
//  EditBoardViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/15.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditBoardViewController: UIViewController {
    
    var defaultStore : Firestore!
    let user = Auth.auth().currentUser
    var boardID : String!
    
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    
    var lockOrNot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultStore = Firestore.firestore()

//        print("memo1:",globalBoardID)
//        themeTextField.text = globalBoardID
        
        themeTextField.layer.borderWidth = 1
        themeTextField.layer.borderColor = UIColor.lightGray.cgColor
        themeTextField.layer.cornerRadius = 5
        
        detailTextField.layer.borderWidth = 1
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 5
        
        print(boardID)

        
        defaultStore.collection("DiscussionBoard").document(boardID).getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                self.themeTextField.text = document.data()?["ThemeOfDiscussion"] as? String
                self.detailTextField.text = document.data()?["DetailOfDiscussion"] as? String
                self.lockOrNot = document.data()?["Lock"] as? Int
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        
        let date = DateFormatter()
        date.dateFormat = "yyyy/MM/dd"
        let now = Date()
        
        defaultStore.collection("DiscussionBoard").document(boardID).setData([
            "AccountID": self.user?.uid,
            "BoardID": boardID,
            "Date": date.string(from: now),
            "Lock": lockOrNot,
            "ThemeOfDiscussion": themeTextField.text,
            "DetailOfDiscussion": detailTextField.text
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
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
