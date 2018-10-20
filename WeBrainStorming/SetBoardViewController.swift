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
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var unlockBtn: UIButton!
    
    let lock:UIImage = UIImage(named:"lockIcon")!
    let lockBlue:UIImage = UIImage(named:"lockIconBlue")!
    let unlock:UIImage = UIImage(named:"unLockIcon")!
    let unlockBlue:UIImage = UIImage(named:"unLockIconBlue")!
    
    var lockOrNot:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()
        
        themeTextField.layer.borderWidth = 1
        themeTextField.layer.borderColor = UIColor.lightGray.cgColor
        themeTextField.layer.cornerRadius = 5
        
        detailTextField.layer.borderWidth = 1
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 5
        
        lockOrNot = 0

    }

    @IBAction func addBoardBtn(_ sender: UIButton) {
        
        //ランダムに変数を用意
        let uuid = NSUUID().uuidString
        
//        print(uuid)
        
        //日付入力
        let date = DateFormatter()
        date.dateFormat = "yyyy/MM/dd"
        let now = Date()
        print(date.string(from: now)) //2017年8月13日

        //ユーザーとボードを紐付け
        defaultStore.collection("DiscussionBoard").document(uuid).setData([
            "ThemeOfDiscussion": themeTextField.text!,
            "DetailOfDiscussion": detailTextField.text!,
            "Lock": lockOrNot,
            "Date": date.string(from: now),
            "AccountID": self.user?.uid,
            "BoardID": uuid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        //同時にディスカッションボード用のデータの外側を作成
        defaultStore.collection("IdeaList").document(uuid).setData([
            "Theme": themeTextField.text!,
            "Detail": detailTextField.text!,
            "TextColor": 0,
            "AccountID": self.user?.uid,
            "BoardID": uuid,
            "X": self.view.frame.width/2,
            "Y": self.view.frame.height/2
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
        
        if lockOrNot == 0 {
            lockBtn.setImage(lockBlue, for: .normal)
            unlockBtn.setImage(unlock, for: .normal)
        }
    }
    
    @IBAction func unLock(_ sender: UIButton) {
        lockOrNot = 1
        
        if lockOrNot == 1 {
            lockBtn.setImage(lock, for: .normal)
            unlockBtn.setImage(unlockBlue, for: .normal)
        }
    }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
