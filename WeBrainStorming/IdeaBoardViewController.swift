//
//  IdeaBoardViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/19.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class IdeaBoardViewController: UIViewController {
    
    var defaultStore : Firestore!
    
    var boardID : String!
    var boardTheme : String!
    
    @IBOutlet var discussionBoard: UIView!
    @IBOutlet var detailPop: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var xLocation: NSLayoutConstraint!
    @IBOutlet weak var yLocation: NSLayoutConstraint!
    
    var longGesture = UILongPressGestureRecognizer()
    var startTransform:CGAffineTransform!
    
    var getLabel = UILabel()
    //表示するテキストデータの配列
    var textLabelList:[UILabel] = []
    var themeList:[String] = []
    var detailList:[String] = []
    var idList:[String] = []
    var infoList:[String] = []
    var xList:[CGFloat] = []
    var yList:[CGFloat] = []
    //    var nextBoard:[String] = []
    
    //カラー関係
    var buttonColorList:[UIColor] = [UIColor.black,UIColor.blue,UIColor.brown,UIColor.cyan,UIColor.green,UIColor.magenta,UIColor.orange,UIColor.purple,UIColor.red,UIColor.yellow]
    var ideaColor:Int = 0
    //firebaseから取ってくる様
    var ideaColorList:[Int] = []
    var colorNum = Int()
    
    var listCount:Int = 0
    var tag:Int = 1
    var taptag:Int!
    
    // タッチしたビューの中心とタッチした場所の座標のズレを保持する変数
    var gapX:CGFloat = 0.0  // x座標
    var gapY:CGFloat = 0.0  // y座標

    override func viewDidLoad() {
        super.viewDidLoad()

        defaultStore = Firestore.firestore()
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(DiscussionBoardViewController.longPress(_:)))
        longGesture.minimumPressDuration = 0.5
        view.addGestureRecognizer(longGesture)
        
        boardView.frame = CGRect(x: -800, y: -700, width: 2000, height: 2000)
        boardView.center = self.view.center
        
        themeLabel.text = boardTheme
        themeLabel.frame = CGRect(x:((self.view.bounds.width-240)/2),y:((self.view.bounds.height-60)/2),width:240,height:45)
        themeLabel.textAlignment = NSTextAlignment.center
        themeLabel.backgroundColor = UIColor.lightGray
        themeLabel.textColor = UIColor.white
        themeLabel.layer.cornerRadius = 7
        themeLabel.clipsToBounds = true
        themeLabel.font = UIFont.systemFont(ofSize: 18)
        
        //getDocumentsは取ってくる
        defaultStore.collection("IdeaList").whereField("BoardID", isEqualTo: boardID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    print(document.data()["Theme"] as! String)
                    self.idList.append(document.documentID)
                    self.themeList.append(document.data()["Theme"] as! String)
                    self.detailList.append(document.data()["Detail"] as! String)
                    self.ideaColorList.append(document.data()["TextColor"] as! Int)
                    //                    print(document.data()["X"])
                    self.xList.append(document.data()["X"] as! CGFloat)
                    self.yList.append(document.data()["Y"] as! CGFloat)
                    //                    print(self.themeList)
                }
                print(self.idList)
            }
            
            //UILabel削除
            if self.themeList.count != 0 {
                for text in self.boardView.subviews{
                    if text is UILabel {
                        text.removeFromSuperview()
                    }
                }
            }
            
            //Labelとして表示
            if self.themeList.count != 0 {
                for i in 0...self.themeList.count-1 {
                    var getLabel = UILabel(frame: CGRect(x: self.xList[i], y: self.yList[i], width: 160, height: 45))
                    getLabel.text = self.themeList[i]
                    getLabel.textAlignment = NSTextAlignment.center
                    // getLabel.backgroundColor = UIColor.red
                    getLabel.textColor = self.buttonColorList[self.ideaColorList[i]]
                    getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                    getLabel.backgroundColor = UIColor.white
                    getLabel.layer.borderWidth = 3
                    getLabel.layer.cornerRadius = 10
                    getLabel.layer.masksToBounds = true
                    //                    getLabel.sizeToFit()
                    // ユーザーの操作を有効にする
                    getLabel.isUserInteractionEnabled = true
                    // タッチしたものがlabelかどうかを判別する用のタグ
                    getLabel.tag = self.tag
                    self.tag += 1
                    //配列に追加
                    self.textLabelList.append(getLabel)
                    //ビューに追加
                    for text in self.textLabelList{
                        self.boardView.addSubview(text)
                    }
                }
            }
        }
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        print("ロングプッシュ")
        print(taptag)
        print(tag)
        //        print(textLabelList[taptag - 1].title)
        //        print(textLabelList[taptag - 1].detail)
        self.view.addSubview(detailPop)
        detailPop.center = self.view.center
        detailPop.layer.cornerRadius = 5
        detailPop.layer.masksToBounds = true
        textLabel.text = textLabelList[taptag - 1].text
        textView.text = detailList[taptag - 1]
        detailPop.backgroundColor = buttonColorList[ideaColorList[taptag - 1]]
    }
    
    // タッチした位置で最初に見つかったところにあるビューを取得してしまおうという魂胆
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 最初にタッチした指のみ取得
        if let touch = touches.first {
            // タッチしたビューをviewプロパティで取得する
            if let touchedView = touch.view {
                // tagでおじさんかそうでないかを判断する
                if touchedView.tag >= 1 {
                    // タッチした場所とタッチしたビューの中心座標がどうずれているか？
                    gapX = touch.location(in: view).x - touchedView.center.x
                    gapY = touch.location(in: view).y - touchedView.center.y
                    // 例えば、タッチしたビューの中心のxが50、タッチした場所のxが60→中心から10ずれ
                    // この場合、指を100に持って行ったらビューの中心は90にしたい
                    // ビューの中心90 = 持って行った場所100 - ずれ10
                    touchedView.center = CGPoint(x: touch.location(in: view).x - gapX, y: touch.location(in: view).y - gapY)
                    taptag = touchedView.tag
                }
                if touchedView.tag == -2 {
                    //                    let move:CGPoint = sender.translation(in: discussionBoard)
                    
                    gapX = touch.location(in: view).x - touchedView.center.x
                    gapY = touch.location(in: view).y - touchedView.center.y
                    
                    //ラベルの位置の制約に移動量を加算する。
                    xLocation.constant += gapX
                    yLocation.constant += gapY
                    
                    //画面表示を更新する。
                    discussionBoard.layoutIfNeeded()
                    
                    touchedView.center = CGPoint(x: touch.location(in: view).x - gapX, y: touch.location(in: view).y - gapY)
                    taptag = touchedView.tag
                    
                    print(xLocation)
                    
                    //移動量を0にする。
                    //                    sender.setTranslation(CGPoint.zero, in:view)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchesBeganと同じ処理だが、gapXとgapYはタッチ中で同じものを使い続ける
        // 最初にタッチした指のみ取得
        if let touch = touches.first {
            // タッチしたビューをviewプロパティで取得する
            if let touchedView = touch.view {
                // tagがどれか判断する
                if touchedView.tag >= 1 {
                    // gapX,gapYの取得は行わない
                    touchedView.center = CGPoint(x: touch.location(in: view).x - gapX, y: touch.location(in: view).y - gapY)
                }
                if touchedView.tag == -2 {
                    touchedView.center = CGPoint(x: touch.location(in: view).x - gapX, y: touch.location(in: view).y - gapY)
                }
            }
        }
    }
    
    //指が離れたところで位置を記憶させる
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // gapXとgapYの初期化
        gapX = 0.0
        gapY = 0.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touchesEndedと同じ処理
        self.touchesEnded(touches, with: event)
    }

    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func pinchLabel(_ sender: UIPinchGestureRecognizer) {
        boardView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    
}
