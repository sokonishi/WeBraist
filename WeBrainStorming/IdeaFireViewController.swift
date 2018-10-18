//
//  IdeaFireViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/18.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class IdeaFireViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var defaultStore : Firestore!
    
    var themeList:[String] = []
    var boardId:[String] = []
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var ideaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultStore = Firestore.firestore()
        
        ideaTableView.delegate = self
        ideaTableView.dataSource = self
        
        themeList = []
        boardId = []
        
        defaultStore.collection("DiscussionBoard").whereField("Lock", isEqualTo: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                    self.boardId.append(document.data()["BoardID"] as! String)
                }
                self.ideaTableView.reloadData()
                print("これ3",self.themeList)
            }
            print("これ2",self.themeList)
        }
        
        print("これ",themeList)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ideaCell") as! IdeaTableViewCell
        //セルにテキストを代入
        cell.ideaThemelabel.text = themeList[indexPath.row]
        return cell
    }
}
