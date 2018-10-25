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

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CellButtonDelegate{

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
    var boardImageCodeList: [String] = []
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
        
        //リロードで更新のやつ
        discussionTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: .valueChanged)
        
//        discussionTableView.transform = discussionTableView.transform.rotated(by: CGFloat(90 * CGFloat.pi / 180))
        discussionTableView.tableFooterView = UIView()
        
        defaultStore.collection("UserInformation").document((self.user?.uid)!).getDocument { (document, error) in
            if let document = document, document.exists {
                self.userId = document.data()!["UserID"] as? String
            } else {
                print("Document does not exist")
            }
        }
        //getDocumentsは取ってくる
        //.order(by: "Date", descending: true)
        defaultStore.collection("DiscussionBoard").whereField("MemberID", isEqualTo: self.userId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
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
                self.discussionTableView.reloadData()
                //                print(self.memberIDList[0][1])
            }
        }
    }
    
    //リロードで更新のやつ
    @objc func refresh(sender: UIRefreshControl) {
        // ここに通信処理などデータフェッチの処理を書く
        // データフェッチが終わったらUIRefreshControl.endRefreshing()を呼ぶ必要がある
        
        themeList = []
        detailList = []
        idList = []
        boardId = []
        dateList = []
        
//        defaultStore.collection("DiscussionBoard").whereField("AccountID", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
        defaultStore.collection("DiscussionBoard").whereField("MemberID", arrayContains: userId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.idList.append(document.documentID)
                    self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                    self.detailList.append(document.data()["DetailOfDiscussion"] as! String)
                    self.boardId.append(document.data()["BoardID"] as! String)
                    self.dateList.append(document.data()["Date"] as! String)
                    self.lockList.append(document.data()["Lock"] as! Int)
                    self.backgroundNumList.append(document.data()["BackgroundNum"] as! Int)
                }
                print("test:リロード")
                print("test:テーマの数",self.themeList.count)
                self.discussionTableView.reloadData()
            }
        }
        
        refreshControl.endRefreshing()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("test:セルの数")
//        print("test:テーマの数2",self.themeList.count)
        return themeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("test:インデックスパス")
        print(indexPath.row)
        print("memberIDList",memberIDList)
        print(memberIDList[indexPath.row])
        print(memberIDList[indexPath.row].count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell") as! CustomTableViewCell
    
        for i in 0 ... self.memberIDList[indexPath.row].count - 1 {
            defaultStore.collection("UserInformation").whereField("UserID", isEqualTo: self.memberIDList[indexPath.row][i]).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.iconImageCode = document.data()["UserImage"] as! String
                    }
                    let iconImage = UIImageView()
                    iconImage.image = self.convertStringToUiImage(stringImageData: self.iconImageCode)
                    iconImage.frame = CGRect(x: 22 + i*40, y: 250, width: 36, height: 36)
                    iconImage.layer.cornerRadius = 18
                    iconImage.clipsToBounds = true
                    cell.boardView.addSubview(iconImage)
                }
            }
        }
    
        //セルにテキストを代入
        if boardImageCodeList[indexPath.row] != "" {
            cell.imageOfDiscussion.image = self.convertStringToUiImage(stringImageData: self.boardImageCodeList[indexPath.row])
        } else {
            print("else働いてる")
            cell.imageOfDiscussion.image = UIImage(named: discussionBackgroundImage[backgroundNumList[indexPath.row]])
            cell.themeImageLabel.text = themeList[indexPath.row]
        }
//        cell.backgroundImage.image = UIImage(named: discussionBackgroundImage[backgroundNumList[indexPath.row]])
//        cell.backgroundImage.alpha = 0.1
        cell.themeLabel.text = themeList[indexPath.row]
        cell.detailLabel.text = detailList[indexPath.row]
        cell.dateLabel.text = dateList[indexPath.row]
        cell.indexPath = indexPath
        cell.boardId = boardId[indexPath.row]
        cell.delegate = self
//        cell.transform = cell.transform.rotated(by: CGFloat(-90 * CGFloat.pi / 180))
        if lockList[indexPath.row] == 1 {
            cell.keyMark.isHidden = true
        }
        return cell
    }
    
    //ボタンが押されたのを検知したときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toBoard", sender: nil)
    }

    func goNext(_ Id:String) {
        performSegue(withIdentifier: "toEditBoard", sender: Id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditBoard" {
            let addVC2 = segue.destination as! EditBoardViewController
            addVC2.boardID = sender as! String
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

}
