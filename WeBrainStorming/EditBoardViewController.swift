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

class EditBoardViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var defaultStore : Firestore!
    let user = Auth.auth().currentUser
    var boardID : String!
    var userId: String!
    
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
//    var boardID : String!
    var memberID:[String] = []
    
    var boardImageCode:String!
    
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
        
        participantID.layer.borderWidth = 1
        participantID.layer.borderColor = UIColor.lightGray.cgColor
        participantID.layer.cornerRadius = 5
        
        boardImageCode = ""
        
        lockOrNot = 0
        print(boardID)
        
        defaultStore.collection("DiscussionBoard").document(boardID).getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                self.themeTextField.text = document.data()?["ThemeOfDiscussion"] as? String
                self.detailTextField.text = document.data()?["DetailOfDiscussion"] as? String
                self.lockOrNot = document.data()?["Lock"] as? Int
                self.memberID = (document.data()?["MemberID"] as? [String])!
                self.boardImageCode = document.data()?["BoardImageCode"] as? String
                self.boardImage.image = self.convertStringToUiImage(stringImageData: self.boardImageCode)
                self.random = document.data()?["BackgroundNum"] as? Int
                
                for i in 0 ... self.memberID.count-1 {
                    var memberLabel: UILabel!
                    print("iだよ",i)
                    if i >= 0 && i <= 2 {
                        memberLabel = UILabel(frame: CGRect(x:22 + i*112 , y: Int(self.participantID.frame.maxY) + 12, width: 107, height: 24))
                    } else if i >= 3 && i <= 5{
                        memberLabel = UILabel(frame: CGRect(x:22 + (i-3)*112 , y: Int(self.participantID.frame.maxY) + 41, width: 107, height: 24))
                    } else if i >= 6 && i <= 8 {
                        memberLabel = UILabel(frame: CGRect(x:22 + (i-6)*112 , y: Int(self.participantID.frame.maxY) + 70, width: 107, height: 24))
                    } else if i >= 9 && i <= 11 {
                        memberLabel = UILabel(frame: CGRect(x:22 + (i-9)*112 , y: Int(self.participantID.frame.maxY) + 70, width: 107, height: 24))
                    } else if i >= 12 && i <= 14 {
                        memberLabel = UILabel(frame: CGRect(x:22 + (i-12)*112 , y: Int(self.participantID.frame.maxY) + 70, width: 107, height: 24))
                    } else {
                        print("多すぎ")
                    }
                    memberLabel.text = self.memberID[i]
                    memberLabel.textAlignment = NSTextAlignment.center
                    memberLabel.textColor = UIColor(red: 32/255, green: 194/255, blue: 212/255, alpha: 1)
                    memberLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
                    memberLabel.layer.cornerRadius = 3
                    memberLabel.layer.masksToBounds = true
                    self.setBoardView.addSubview(memberLabel)
                }
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
            "DetailOfDiscussion": detailTextField.text,
            "BackgroundNum": random,
            "MemberID": memberID,
            "BoardImageCode": boardImageCode,
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
        for i in 1 ... memberID.count-1 {
            var memberLabel: UILabel!
            print("iだよ",i)
            if i >= 1 && i <= 2 {
                memberLabel = UILabel(frame: CGRect(x:22 + i*112 , y: Int(participantID.frame.maxY) + 12, width: 107, height: 24))
            } else if i >= 3 && i <= 5{
                memberLabel = UILabel(frame: CGRect(x:22 + (i-3)*112 , y: Int(participantID.frame.maxY) + 41, width: 107, height: 24))
            } else if i >= 6 && i <= 8 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-6)*112 , y: Int(participantID.frame.maxY) + 70, width: 107, height: 24))
            } else if i >= 9 && i <= 11 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-9)*112 , y: Int(participantID.frame.maxY) + 70, width: 107, height: 24))
            } else if i >= 12 && i <= 14 {
                memberLabel = UILabel(frame: CGRect(x:22 + (i-12)*112 , y: Int(participantID.frame.maxY) + 70, width: 107, height: 24))
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
