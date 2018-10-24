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

class SetBoardViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var defaultStore : Firestore!
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var setBoardView: UIView!
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var participantID: UITextField!
    
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var unlockBtn: UIButton!
    
    @IBOutlet weak var boardImage: UIImageView!
    
    let lock:UIImage = UIImage(named:"lockIcon")!
    let lockBlue:UIImage = UIImage(named:"lockIconBlue")!
    let unlock:UIImage = UIImage(named:"unLockIcon")!
    let unlockBlue:UIImage = UIImage(named:"unLockIconBlue")!
    
    var lockOrNot:Int!
    var random: Int!
    var boardID : String!
    var memberID: [String] = []
    
    var boardImageCode:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()
        
        memberID = []
//        memberID.append((self.user?.uid)!)
        
        themeTextField.layer.borderWidth = 1
        themeTextField.layer.borderColor = UIColor.lightGray.cgColor
        themeTextField.layer.cornerRadius = 5
        
        detailTextField.layer.borderWidth = 1
        detailTextField.layer.borderColor = UIColor.lightGray.cgColor
        detailTextField.layer.cornerRadius = 5
        
        participantID.layer.borderWidth = 1
        participantID.layer.borderColor = UIColor.lightGray.cgColor
        participantID.layer.cornerRadius = 5
        
        lockOrNot = 0

    }

    @IBAction func addBoardBtn(_ sender: UIButton) {
        //ランダムに変数を用意
        let uuid = NSUUID().uuidString
        boardID = uuid
        
        //背景カラーをランダムに生成
        random = Int(arc4random()) % 17
        print(random)
        
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
            "BoardID": uuid,
            "BackgroundNum": random,
            "MemberID": memberID
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func addPictureBtn(_ sender: UIButton) {
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
        self.boardImage.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        //投稿画像
        if let maxQualityImageData = boardImage.image!.jpegData(compressionQuality: 0.1) {
            //画像をNSDataにキャスト
            let data:NSData = maxQualityImageData as NSData
            let base64String = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters) as String
            boardImageCode = base64String
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
    
    @IBAction func addMember(_ sender: UIButton) {
        memberID.append(participantID.text!)
        print(memberID)
        print("押されたよ")
        let checkTextframe = participantID.convert(participantID.frame, to: self.view)
        print(checkTextframe.origin.y)
        print(participantID.frame.maxY)
        for i in 0 ... memberID.count-1 {
            var memberLabel: UILabel!
            print("iだよ",i)
            if i >= 0 && i <= 2 {
                memberLabel = UILabel(frame: CGRect(x:22 + i*110 , y: Int(participantID.frame.maxY) + 12, width: 105, height: 24))
            } else if i >= 3 && i <= 5{
                memberLabel = UILabel(frame: CGRect(x:22 + (i-4)*110 , y: Int(participantID.frame.maxY) + 41, width: 105, height: 24))
            } else if i >= 6 && i <= 8 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-8)*110 , y: Int(participantID.frame.maxY) + 70, width: 105, height: 24))
            } else if i >= 9 && i <= 11 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-8)*110 , y: Int(participantID.frame.maxY) + 70, width: 105, height: 24))
            } else if i >= 12 && i <= 14 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-8)*110 , y: Int(participantID.frame.maxY) + 70, width: 105, height: 24))
            } else {
                print("多すぎ")
            }
            memberLabel.text = memberID[i]
            memberLabel.textAlignment = NSTextAlignment.center
            memberLabel.textColor = UIColor(red: 32/255, green: 194/255, blue: 212/255, alpha: 1)
            memberLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            memberLabel.layer.cornerRadius = 3
            memberLabel.layer.masksToBounds = true
            self.setBoardView.addSubview(memberLabel)
        }
        participantID.text = ""
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
