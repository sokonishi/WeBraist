//
//  HomeViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/05.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageUI

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,CellButtonDelegate{

    var defaultStore : Firestore!
    @IBOutlet weak var discussionTableView: UITableView!
    //リフレッシュ
    private let refreshControl = UIRefreshControl()
    
    var themeList:[String] = []
    var detailList:[String] = []
    var idList:[String] = []
    var boardId:[String] = []
    var dateList:[String] = []
    var lockList:[Int] = []
    var backgroundNumList: [Int] = []
    var memberIDList: [NSArray] = []
    var memberID:[String] = []
    var boardImageCodeList: [String] = []
    var blockList:[String] = []
    var blockListString:[String] = []
    var checkBlockUser:[String] = []
    var iconImageCode: String!
    var userId: String!
    let user = Auth.auth().currentUser
    
    var discussionBackgroundImage = ["Bora Bora","Combi","Flare","Instagram","Intuitive Purple","JShine","Martini","Mirage","Noon to Dusk","Purpink","Rastafari","Sky","The Strain","Timber","Wedding Day Blues","Wiretap","YouTube"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultStore = Firestore.firestore()

        discussionTableView.delegate = self
        discussionTableView.dataSource = self
        
        themeList = []
        detailList = []
        idList = []
        boardId = []
        dateList = []
        lockList = []
        blockList = []
        checkBlockUser = []
        
        //リロードで更新のやつ
        discussionTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: .valueChanged)

        discussionTableView.tableFooterView = UIView()
        
        defaultStore.collection("UserInformation").document((self.user?.uid)!).getDocument { (document, error) in
            if let document = document, document.exists {
                
                print("viewDidLoadの処理の中")
                self.userId = document.data()!["UserID"] as? String
//                self.blockList = (document.data()?["BlockList"] as? [String]!)!
//                print("block",self.blockList)
                //getDocumentsは取ってくる
                self.blockList = (document.data()?["BlockList"] as? [String])!
                print("ブロックリスト",self.blockList)
                
                self.defaultStore.collection("DiscussionBoard").whereField("MemberID", arrayContains: self.userId).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
                            self.checkBlockUser = (document.data()["MemberID"] as? [String])!
                            print("ブロックユーザー",self.checkBlockUser[0])
                            print("いるかいないか",self.blockList.contains(self.checkBlockUser[0]))
                            
                            if self.blockList.contains(self.checkBlockUser[0]) == false {
                                self.idList.append(document.documentID)
                                self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                                self.detailList.append(document.data()["DetailOfDiscussion"] as! String)
                                self.boardId.append(document.data()["BoardID"] as! String)
                                self.dateList.append(document.data()["Date"] as! String)
                                self.lockList.append(document.data()["Lock"] as! Int)
                                self.backgroundNumList.append(document.data()["BackgroundNum"] as! Int)
                                self.memberIDList.append(document.data()["MemberID"] as! NSArray)
                                self.boardImageCodeList.append(document.data()["BoardImageCode"] as! String)
                            }
                        }
                        self.discussionTableView.reloadData()
                    }
                }

            } else {
                print("Document does not exist")
            }
        }
        print(memberIDList)
    }
    
    //リロードで更新のやつ
    @objc func refresh(sender: UIRefreshControl) {
        // ここに通信処理などデータフェッチの処理を書く
        // データフェッチが終わったらUIRefreshControl.endRefreshing()を呼ぶ必要がある
        idList = []
        themeList = []
        detailList = []
        boardId = []
        dateList = []
        lockList = []
        backgroundNumList = []
        memberIDList = []
        boardImageCodeList = []
        blockList = []
        checkBlockUser = []
        
//        defaultStore.collection("DiscussionBoard").whereField("AccountID", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
        defaultStore.collection("UserInformation").document((self.user?.uid)!).getDocument { (document, error) in
            if let document = document, document.exists {

                self.userId = document.data()!["UserID"] as? String
                self.blockList = (document.data()!["BlockList"] as? [String])!
                //getDocumentsは取ってくる
                self.defaultStore.collection("DiscussionBoard").whereField("MemberID", arrayContains: self.userId!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.checkBlockUser = (document.data()["MemberID"] as? [String])!
                            if self.blockList.contains(self.checkBlockUser[0]) == false {
                                self.idList.append(document.documentID)
                                self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                                self.detailList.append(document.data()["DetailOfDiscussion"] as! String)
                                self.boardId.append(document.data()["BoardID"] as! String)
                                self.dateList.append(document.data()["Date"] as! String)
                                self.lockList.append(document.data()["Lock"] as! Int)
                                self.backgroundNumList.append(document.data()["BackgroundNum"] as! Int)
                                self.memberIDList.append(document.data()["MemberID"] as! NSArray)
                                self.boardImageCodeList.append(document.data()["BoardImageCode"] as! String)
                            }
                        }
                        self.discussionTableView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        refreshControl.endRefreshing()
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return themeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("member")
        print(self.memberIDList)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell") as! CustomTableViewCell
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
//        print(self.memberIDList[indexPath.row])
        cell.delegate = self
        //タグの設定
        cell.reportBtn.tag = indexPath.row
        
        let subViews = cell.boardView.subviews
        for subview in subViews{
            if subview.tag == 11 {
                subview.removeFromSuperview()
            }
        }
        
        for i in 0 ... self.memberIDList[indexPath.row].count - 1 {
            defaultStore.collection("UserInformation").whereField("UserID", isEqualTo: self.memberIDList[indexPath.row][i]).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if document.data()["UserImage"] as? String == nil {
                            self.iconImageCode = ""
                        } else {
                            self.iconImageCode = document.data()["UserImage"] as? String
//                            print(self.iconImageCode)
                        }
                    }
                    let iconImage = UIImageView()
                    if self.iconImageCode == "" || self.self.iconImageCode == nil {
                        iconImage.image = UIImage(named: "iconBlue")
                    } else {
                        print("なんで")
                        iconImage.image = self.convertStringToUiImage(stringImageData: self.iconImageCode)
                    }
                    
                    iconImage.frame = CGRect(x: 22 + i*40, y: 250, width: 36, height: 36)
                    iconImage.tag = 11
                    iconImage.layer.cornerRadius = 18
                    iconImage.clipsToBounds = true
                    cell.boardView.addSubview(iconImage)
                    self.iconImageCode = ""
                }
            }
        }
    
//        //セルにテキストを代入
//        if boardImageCodeList[indexPath.row] != "" {
//            cell.imageOfDiscussion.image = self.convertStringToUiImage(stringImageData: self.boardImageCodeList[indexPath.row])
//        } else {
//            print("else働いてる")
//            cell.imageOfDiscussion.image = UIImage(named: discussionBackgroundImage[backgroundNumList[indexPath.row]])
//            cell.themeImageLabel.text = themeList[indexPath.row]
//        }
////        cell.backgroundImage.image = UIImage(named: discussionBackgroundImage[backgroundNumList[indexPath.row]])
////        cell.backgroundImage.alpha = 0.1
//        cell.themeLabel.text = themeList[indexPath.row]
//        cell.detailLabel.text = detailList[indexPath.row]
//        cell.dateLabel.text = dateList[indexPath.row]
//        cell.indexPath = indexPath
//        cell.boardIdCell = boardId[indexPath.row]
//        cell.delegate = self
////        cell.transform = cell.transform.rotated(by: CGFloat(-90 * CGFloat.pi / 180))
//        if lockList[indexPath.row] == 1 {
//            cell.keyMark.isHidden = true
//        }
        
        cell.setCell(boardImageCode: boardImageCodeList[indexPath.row], discussionBackgroundImage: discussionBackgroundImage[backgroundNumList[indexPath.row]], themeList: themeList[indexPath.row], detailList: detailList[indexPath.row], dateList: dateList[indexPath.row], boardId: boardId[indexPath.row], lockList: lockList[indexPath.row])
        
        return cell
    }
    
    //ボタンが押されたのを検知したときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toBoard", sender: nil)
    }

    func goNext(_ Id:String) {
        performSegue(withIdentifier: "toEditBoard", sender: Id)
    }
    
    func dispAlert(_ ID:String,reportBtnTag:Int) {

        let actionSheet: UIAlertController = UIAlertController(
            title: "選択肢を表示",
            message: "この投稿について",
            preferredStyle: UIAlertController.Style.actionSheet)

        // ②選択肢の作成と追加
        // titleに選択肢のテキストを、styleに.defaultを
        // handlerにボタンが押された時の処理をクロージャで実装する
        actionSheet.addAction(
            UIAlertAction(title: "削除する",
                          style: .default,
                          handler: {
                            (action: UIAlertAction!) -> Void in
                            print("削除する")
                            print(reportBtnTag)
                            self.memberID = self.memberIDList[reportBtnTag] as! [String]
                            print("その１",self.memberID)
                            self.memberID = self.memberID.filter{ $0 != self.userId}
                            print("その２",self.memberID)
                            print(ID)
                         
                            self.defaultStore.collection("DiscussionBoard").document(ID).updateData([
                                "MemberID": self.memberID,

                                ]) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                            }
            })
          
        )

        // ②選択肢の作成と追加
        actionSheet.addAction(
            UIAlertAction(title: "通報する",
                          style: .default,
                          handler: {
                            (action: UIAlertAction!) -> Void in
                            print("通報する")
                            if MFMailComposeViewController.canSendMail(){
                                
                                let mailComposeViewController = MFMailComposeViewController()
                                mailComposeViewController.setToRecipients(["sokonishi315@gmail.com"]) //宛先アドレス
                                mailComposeViewController.setSubject("このボードを通報する") //サブジェクト
                                mailComposeViewController.setMessageBody(ID, isHTML: false) //メール本文
                                mailComposeViewController.setCcRecipients(["sokonishi315@gmail.com"])
                                mailComposeViewController.setBccRecipients(["sokonishi315@gmail.com"])

                                mailComposeViewController.mailComposeDelegate = self //delegateの設定
                                
                                self.present(mailComposeViewController,animated: true,completion: nil)
                            } else {
                                print("送信できません。")
                            }
            })
        )
        
        // ②選択肢の作成と追加
        actionSheet.addAction(
            UIAlertAction(title: "投稿者をブロックする",
                          style: .default,
                          handler: {
                            (action: UIAlertAction!) -> Void in
                            print("投稿者をブロックする")
                            print("投稿者ID",self.memberIDList[reportBtnTag][0])
                            if self.memberIDList[reportBtnTag][0] as? String != self.userId {
                                self.blockList.append((self.memberIDList[reportBtnTag][0] as? String)!)
                                self.defaultStore.collection("UserInformation").document((self.user?.uid)!).updateData([
                                    "BlockList": self.blockList,
                                ]) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                    }
                                }
                            }
            })
        )
        
        // ②選択肢の作成と追加
        actionSheet.addAction(
            UIAlertAction(title: "キャンセル",
                          style: .default,
                          handler: {
                            (action: UIAlertAction!) -> Void in
                            print("キャンセル")
            })
        )
        // ③表示するViewと表示位置を指定する(デバイス自動判定版)
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = view
            let screenSize = UIScreen.main.bounds
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }

        // ③アクションシートを表示
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditBoard" {
            let addVC2 = segue.destination as! EditBoardViewController
            addVC2.boardID = sender as? String
        }
        if let indexPath = self.discussionTableView.indexPathForSelectedRow{
            let boardID = self.boardId[indexPath.row]
            let boardTheme = self.themeList[indexPath.row]
            let boardColorNum = self.backgroundNumList[indexPath.row]
            //遷移先のViewControllerを格納
            let controller = segue.destination as! DiscussionBoardViewController
            
            //遷移先の変数に代入
            controller.boardID = boardID
            controller.boardTheme = boardTheme
            controller.boardColorNum = boardColorNum
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
    
    // 画面の自動回転をさせない
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    // 画面をPortraitに指定する
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

}
