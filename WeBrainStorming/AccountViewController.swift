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

class AccountViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var defaultStore : Firestore!
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userIDField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    var userImageCode:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()
        
        
        
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        guard let image = info[.originalImage] as? UIImage else { fatalError("Expected a dictionary containing an image, but was provided the following: \(info)") }
        // ビューに表示する
        self.userImage.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)

        //投稿画像
        if let maxQualityImageData = userImage.image!.jpegData(compressionQuality: 0.1) {
            //画像をNSDataにキャスト
            let data:NSData = maxQualityImageData as NSData
            
            let base64String = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters) as String
            
            userImageCode = base64String
            
            iconImage.image = convertStringToUiImage(stringImageData: base64String)
        }
    }
    
    func convertStringToUiImage(stringImageData: String) -> UIImage! {
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:NSData? =
            NSData(base64Encoded:stringImageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess as Data)
            return img
            
        }
        
        return nil
    }
    
    @IBAction func resetPicture(_ sender: UIButton) {
        // アラートで確認
        let alert = UIAlertController(title: "確認", message: "画像を初期化してもよいですか？", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction) -> Void in
            // デフォルトの画像を表示する
            self.userImage.image = UIImage(named: "スクリーンショット 2018-10-05 13.03.17.png")
        })
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        // アラートにボタン追加
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        // アラート表示
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        defaultStore.collection("UserInformation").document((self.user?.uid)!).setData([
            "UserName": userNameField.text!,
            "UserID": userIDField.text!,
//            "Lock": lockOrNot,
            "AccountID": self.user?.uid,
            "UserImage": userImageCode
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
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

