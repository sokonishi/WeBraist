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

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var defaultStore : Firestore!
    @IBOutlet weak var discussionTableView: UITableView!
    
    var themeList:[String] = []
    var detailList:[String] = []
    var idList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultStore = Firestore.firestore()

        discussionTableView.delegate = self
        discussionTableView.dataSource = self
        
        themeList = []
        detailList = []
        idList = []
        
        //getDocumentsは取ってくる
        defaultStore.collection("DiscussionBoard").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.idList.append(document.documentID)
                    self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                    self.detailList.append(document.data()["DetailOfDiscussion"] as! String)
                }
                self.discussionTableView.reloadData()
            }
        }
        
        print(themeList)
        print(detailList)
        print(idList)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell") as! CustomTableViewCell
        
        //セルにテキストを代入
        cell.imageOfDiscussion.image = UIImage(named: "mindmap.jpg")
        cell.themeLabel.text = themeList[indexPath.row]
        cell.detailLabel.text = detailList[indexPath.row]
        
        return cell
    }

}
