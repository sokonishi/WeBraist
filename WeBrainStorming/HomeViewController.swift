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
    let user = Auth.auth().currentUser
    
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
        
        //リロードで更新のやつ
        discussionTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: .valueChanged)
        
        //getDocumentsは取ってくる
        //.order(by: "Date", descending: true)
        defaultStore.collection("DiscussionBoard").whereField("AccountID", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
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
                }
//                print(self.themeList)
//                print(self.detailList)
//
//
//                print(self.themeList.count)
//                print(self.detailList.count)
                self.discussionTableView.reloadData()
            }
        }
//        print("sss",themeList)
//        print(detailList)
//
//
//        print(themeList.count)
//        print(detailList.count)
//
//        print("ここから")
//        print(user?.uid)
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
        
        defaultStore.collection("DiscussionBoard").whereField("AccountID", isEqualTo: user?.uid).order(by: "Date").getDocuments() { (querySnapshot, err) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell") as! CustomTableViewCell
        
        //セルにテキストを代入
        cell.imageOfDiscussion.image = UIImage(named: "mindmap.jpg")
        cell.themeLabel.text = themeList[indexPath.row]
        cell.detailLabel.text = detailList[indexPath.row]
        cell.dateLabel.text = dateList[indexPath.row]
        cell.indexPath = indexPath
        cell.boardId = boardId[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //ボタンが押されたのを検知したときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextBoardId = boardId[indexPath.row]
        performSegue(withIdentifier: "toBoard", sender: nextBoardId)
    }

    func goNext(_ Id:String) {
        performSegue(withIdentifier: "toEditBoard", sender: Id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBoard" {
            let addVC = segue.destination as! DiscussionBoardViewController
            addVC.boardID = sender as! String
        }
        if segue.identifier == "toEditBoard" {
            let addVC2 = segue.destination as! EditBoardViewController
            addVC2.boardID = sender as! String
        }
    }

}
