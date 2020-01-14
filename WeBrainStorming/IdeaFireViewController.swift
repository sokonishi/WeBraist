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
    var backgroundNumList: [Int] = []
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var ideaTableView: UITableView!
    
    var discussionBackgroundImage = ["Bora Bora","Combi","Flare","Instagram","Intuitive Purple","JShine","Martini","Mirage","Noon to Dusk","Purpink","Rastafari","Sky","The Strain","Timber","Wedding Day Blues","Wiretap","YouTube"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultStore = Firestore.firestore()
        
        ideaTableView.delegate = self
        ideaTableView.dataSource = self
        
        ideaTableView.tableFooterView = UIView()
        
        themeList = []
        boardId = []
        
        defaultStore.collection("DiscussionBoard").whereField("Lock", isEqualTo: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    self.themeList.append(document.data()["ThemeOfDiscussion"] as! String)
                    self.boardId.append(document.data()["BoardID"] as! String)
                    self.backgroundNumList.append(document.data()["BackgroundNum"] as! Int)
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
        cell.boardId = boardId[indexPath.row]
        cell.backgroundImage.image = UIImage(named: discussionBackgroundImage[backgroundNumList[indexPath.row]])
        return cell
    }
    
    //ボタンが押されたのを検知したときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toIdeaBoard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.ideaTableView.indexPathForSelectedRow{
            let boardID = self.boardId[indexPath.row]
            let boardTheme = self.themeList[indexPath.row]
            let boardColorNum = self.backgroundNumList[indexPath.row]
            //遷移先のViewControllerを格納
            let controller = segue.destination as! IdeaBoardViewController
            
            //遷移先の変数に代入
            controller.boardID = boardID
            controller.boardTheme = boardTheme
            controller.boardColorNum = boardColorNum
        }
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
