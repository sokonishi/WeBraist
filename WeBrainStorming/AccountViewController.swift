//
//  AccountViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/15.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AccountViewController: UIViewController{
    
    var defaultStore : Firestore!
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userIDField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()

    }
    
    @IBAction func register(_ sender: UIButton) {
        
        defaultStore.collection("UserInformation").document((self.user?.uid)!).setData([
            "UserName": userNameField.text!,
            "UserID": userIDField.text!,
//            "Lock": lockOrNot,
            "AccountID": self.user?.uid,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            print("memo:サインアウト成功")
        } catch let signOutError as NSError {
            print("memo:サインアウトエラー",signOutError)
            alert(memo: "サインアウトエラー\(signOutError)")
        }
        
    }
    
    func alert(memo:String){
        let alert = UIAlertController(title: "アラート", message: memo, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            //OKを押した後の処理。
        }))
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
    }
    
}
