//
//  DiscussionBoardViewController.swift
//  
//
//  Created by 小西壮 on 2018/10/11.
//

import UIKit
import Firebase
import FirebaseFirestore

class DiscussionBoardViewController: UIViewController {
    
    var defaultStore : Firestore!
    
    var boardID : String!
    var boardTheme : String!
    var boardColorNum : Int!
    
    @IBOutlet var discussionBoard: UIView!
    @IBOutlet var insertPop: UIView!
    @IBOutlet var detailPop: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var boardView: UIView!
//
//    @IBOutlet weak var themeLabel: UILabel!
//
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
    
    var discussionBackgroundImage = ["Bora Bora","Combi","Flare","Instagram","Intuitive Purple","JShine","Martini","Mirage","Noon to Dusk","Purpink","Rastafari","Sky","The Strain","Timber","Wedding Day Blues","Wiretap","YouTube"]
    
    let lightBlue:UIColor = UIColor(red: 81/255, green: 167/255, blue: 249/255, alpha: 1)
    let yellow:UIColor = UIColor(red: 245/255, green: 211/255, blue: 40/255, alpha: 1)
    let pink:UIColor =  UIColor(red: 255/255, green: 47/255, blue: 146/255, alpha: 1)
    let orange:UIColor =  UIColor(red: 243/255, green: 144/255, blue: 25/255, alpha: 1)
    let purple:UIColor =  UIColor(red: 179/255, green: 106/255, blue: 226/255, alpha: 1)
    let red:UIColor =  UIColor(red: 200/255, green: 37/255, blue: 6/255, alpha: 1)
    let green:UIColor =  UIColor(red: 112/255, green: 191/255, blue: 65/255, alpha: 1)
    let con:UIColor = UIColor(red: 22/255, green: 79/255, blue: 134/255, alpha: 1)
    let brown:UIColor = UIColor(red: 157/255, green: 67/255, blue: 23/255, alpha: 1)
    let greenBlue:UIColor = UIColor(red: 24/255, green: 163/255, blue: 165/255, alpha: 1)
    
    //カラー関係
    var buttonColorList:[UIColor] = []
    var ideaColor:Int = 0
    
    //firebaseから取ってくる様
    var ideaColorList:[Int] = []
    var colorNum = Int()
    let coverButton = UILabel()
    
    var listCount:Int = 0
    var tag:Int = 1
    var taptag:Int!
    
    // タッチしたビューの中心とタッチした場所の座標のズレを保持する変数
    var gapX:CGFloat = 0.0  // x座標
    var gapY:CGFloat = 0.0  // y座標
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultStore = Firestore.firestore()
        
        buttonColorList = [lightBlue,yellow,pink,orange,purple,red,green,con,brown,greenBlue]
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(DiscussionBoardViewController.longPress(_:)))
        longGesture.minimumPressDuration = 0.5
        view.addGestureRecognizer(longGesture)
        
        boardView.frame = CGRect(x: -800, y: -700, width: 3000, height: 2000)
        boardView.center = self.view.center
        boardView.layer.borderColor = UIColor.lightGray.cgColor
        boardView.backgroundColor = UIColor.white
        boardView.layer.borderWidth = 3
        
        let backgroundImage = UIImageView(frame: CGRect(x: -800, y: -700, width: 3000, height: 2000))
        backgroundImage.center = self.view.center
        backgroundImage.image = UIImage(named: discussionBackgroundImage[boardColorNum])
        backgroundImage.alpha = 0.3
        backgroundImage.layer.zPosition = -1
        self.view.addSubview(backgroundImage)
        
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
                    if self.detailList[i] != "" {
                        getLabel.textColor = UIColor.white
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = self.buttonColorList[self.ideaColorList[i]]
                    } else {
                        getLabel.textColor = self.buttonColorList[self.ideaColorList[i]]
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = UIColor.white
                    }
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
            let themeLabel = UILabel(frame: CGRect(x:(self.boardView.bounds.width-240)/2,y:(self.boardView.bounds.height-60)/2,width:240,height:45))
            themeLabel.text = self.boardTheme
            themeLabel.textAlignment = NSTextAlignment.center
            themeLabel.backgroundColor = UIColor.lightGray
            themeLabel.textColor = UIColor.white
            themeLabel.layer.cornerRadius = 7
            themeLabel.clipsToBounds = true
            themeLabel.font = UIFont.systemFont(ofSize: 18)
            
            self.boardView.addSubview(themeLabel)
        }
        
    }

    @IBAction func add(_ sender: UIButton) {
        self.view.addSubview(insertPop)
        insertPop.center = self.view.center
        insertPop.layer.cornerRadius = 5
        insertPop.layer.masksToBounds = true
        //      色指定buttonの生成
        for i in 0...self.buttonColorList.count-1 {
            let buttonColor = UIButton()
            buttonColor.frame = CGRect(x:26 + i * 27, y:120,
                                       width:25, height:25)
            buttonColor.backgroundColor = self.buttonColorList[i]
            buttonColor.tag = i
            buttonColor.addTarget(self, action: #selector(DiscussionBoardViewController.changeColor(sender:)), for: .touchUpInside)
            self.insertPop.addSubview(buttonColor)
        }
    }
 
    @IBAction func insertBtn(_ sender: UIButton) {
//        print(ideaColor)
        
        //===============Firebaseにデータを保存===========================
        defaultStore.collection("IdeaList").addDocument(data:[
            "Theme": textField.text!,
            "Detail": textView.text!,
            "TextColor": ideaColor,
            "BoardID":boardID,
            "X":1400,
            "Y":800
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        //================ここまで===========================
        
        // 初期位置を調整
        // getLabel.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        
        self.insertPop.removeFromSuperview()

        
        //=====================関数でまとめる=============================
        //番号リセット
        taptag = 1
        tag = 1
        
        print("Reload:空にする")
        //データベースから取り出す
        textLabelList = []
        themeList = []
        detailList = []
        ideaColorList = []
        idList = []
        xList = []
        yList = []
        
        //getDocumentsは取ってくる
        defaultStore.collection("IdeaList").whereField("BoardID", isEqualTo: boardID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    self.idList.append(document.documentID)
                    self.themeList.append(document.data()["Theme"] as! String)
                    self.detailList.append(document.data()["Detail"] as! String)
                    self.ideaColorList.append(document.data()["TextColor"] as! Int)
                    //                    print(document.data()["X"])
                    self.xList.append(document.data()["X"] as! CGFloat)
                    self.yList.append(document.data()["Y"] as! CGFloat)
                    //                    print(self.themeList)
                }
                print(self.ideaColorList)
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
                    if self.detailList[i] != "" {
                        getLabel.textColor = UIColor.white
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = self.buttonColorList[self.ideaColorList[i]]
                    } else {
                        getLabel.textColor = self.buttonColorList[self.ideaColorList[i]]
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = UIColor.white
                    }
                    getLabel.layer.borderWidth = 3
                    getLabel.layer.cornerRadius = 10
                    getLabel.layer.masksToBounds = true
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
            let themeLabel = UILabel(frame: CGRect(x:(self.boardView.bounds.width-240)/2,y:(self.boardView.bounds.height-60)/2,width:240,height:45))
            themeLabel.text = self.boardTheme
            themeLabel.textAlignment = NSTextAlignment.center
            themeLabel.backgroundColor = UIColor.lightGray
            themeLabel.textColor = UIColor.white
            themeLabel.layer.cornerRadius = 7
            themeLabel.clipsToBounds = true
            themeLabel.font = UIFont.systemFont(ofSize: 18)
            
            self.boardView.addSubview(themeLabel)
        }
    }
    
    
    @IBAction func reload(_ sender: UIButton) {
        
        //=====================関数でまとめる=============================
        //番号リセット
        taptag = 1
        tag = 1
        
        print("Reload:空にする")
        //データベースから取り出す
        textLabelList = []
        themeList = []
        detailList = []
        ideaColorList = []
        idList = []
        xList = []
        yList = []
        
        //getDocumentsは取ってくる
        defaultStore.collection("IdeaList").whereField("BoardID", isEqualTo: boardID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    self.idList.append(document.documentID)
                    self.themeList.append(document.data()["Theme"] as! String)
                    self.detailList.append(document.data()["Detail"] as! String)
                    self.ideaColorList.append(document.data()["TextColor"] as! Int)
                    //                    print(document.data()["X"])
                    self.xList.append(document.data()["X"] as! CGFloat)
                    self.yList.append(document.data()["Y"] as! CGFloat)
                    //                    print(self.themeList)
                }
                print(self.ideaColorList)
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
                    if self.detailList[i] != "" {
                        getLabel.textColor = UIColor.white
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = self.buttonColorList[self.ideaColorList[i]]
                    } else {
                        getLabel.textColor = self.buttonColorList[self.ideaColorList[i]]
                        getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                        getLabel.backgroundColor = UIColor.white
                    }
                    getLabel.layer.borderWidth = 3
                    getLabel.layer.cornerRadius = 10
                    getLabel.layer.masksToBounds = true
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
            
            let themeLabel = UILabel(frame: CGRect(x:(self.boardView.bounds.width-240)/2,y:(self.boardView.bounds.height-60)/2,width:240,height:45))
            themeLabel.text = self.boardTheme
            //        themeLabel.frame = CGRect(x:((self.view.bounds.width-240)/2),y:((self.view.bounds.height-60)/2),width:240,height:45)
            //            themeLabel.frame = CGRect(x:(self.boardView.bounds.width-240)/2,y:(self.boardView.bounds.height-60)/2,width:240,height:45)
            themeLabel.textAlignment = NSTextAlignment.center
            themeLabel.backgroundColor = UIColor.lightGray
            themeLabel.textColor = UIColor.white
            themeLabel.layer.cornerRadius = 7
            themeLabel.clipsToBounds = true
            themeLabel.font = UIFont.systemFont(ofSize: 18)
            
            self.boardView.addSubview(themeLabel)
        }
        //=====================ここまで=============================
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        print("ロングプッシュ")
        print(taptag)
        print(tag)
        //        print(textLabelList[taptag - 1].title)
        //        print(textLabelList[taptag - 1].detail)
        if taptag >= 1 {
            print(detailList)
            print(taptag)
            self.view.addSubview(detailPop)
            detailPop.center = self.view.center
            detailPop.layer.cornerRadius = 5
            detailPop.layer.masksToBounds = true
            themeField.text = textLabelList[taptag - 1].text
            detailView.text = detailList[taptag - 1]
            detailPop.backgroundColor = buttonColorList[ideaColorList[taptag - 1]]
            for i in 0...self.buttonColorList.count-1 {
                let buttonColor = UIButton()
                buttonColor.frame = CGRect(x:26 + i * 27, y:120,
                                           width:25, height:25)
                buttonColor.backgroundColor = self.buttonColorList[i]
                buttonColor.tag = i
                buttonColor.addTarget(self, action: #selector(DiscussionBoardViewController.changeColor2(sender:)), for: .touchUpInside)
                self.detailPop.addSubview(buttonColor)
            }
        }
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        
        print(idList)
        print(idList.count)
        print(taptag - 1)
        
        if taptag >= 1 {
            //保存処理
            self.defaultStore.collection("IdeaList").document(self.idList[taptag - 1]).setData([
                "Theme": themeField.text!,
                "Detail": detailView.text!,
                "TextColor": ideaColor,
                "BoardID": boardID,
                "X": xList[taptag - 1],
                "Y": yList[taptag - 1]
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written")
                }
            }
            
            //=====================関数でまとめる=============================
            //番号リセット
            taptag = 1
            tag = 1
            
            
            print("Edit:空にする")
            //データベースから取り出す
            textLabelList = []
            themeList = []
            detailList = []
            ideaColorList = []
            idList = []
            xList = []
            yList = []
            
            //getDocumentsは取ってくる
            defaultStore.collection("IdeaList").whereField("BoardID", isEqualTo: boardID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                    print("\(document.documentID) => \(document.data())")
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
                        if self.detailList[i] != "" {
                            getLabel.textColor = UIColor.white
                            getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                            getLabel.backgroundColor = self.buttonColorList[self.ideaColorList[i]]
                        } else {
                            getLabel.textColor = self.buttonColorList[self.ideaColorList[i]]
                            getLabel.layer.borderColor = self.buttonColorList[self.ideaColorList[i]].cgColor
                            getLabel.backgroundColor = UIColor.white
                        }
                        getLabel.layer.borderWidth = 3
                        getLabel.layer.cornerRadius = 10
                        getLabel.layer.masksToBounds = true
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
                
                let themeLabel = UILabel(frame: CGRect(x:(self.boardView.bounds.width-240)/2,y:(self.boardView.bounds.height-60)/2,width:240,height:45))
                themeLabel.text = self.boardTheme
                themeLabel.textAlignment = NSTextAlignment.center
                themeLabel.backgroundColor = UIColor.lightGray
                themeLabel.textColor = UIColor.white
                themeLabel.layer.cornerRadius = 7
                themeLabel.clipsToBounds = true
                themeLabel.font = UIFont.systemFont(ofSize: 18)
                
                self.boardView.addSubview(themeLabel)
            }
            //=====================ここまで=============================
            
            self.detailPop.removeFromSuperview()
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        self.detailPop.removeFromSuperview()
        self.insertPop.removeFromSuperview()
    }
    
    @objc func changeColor(sender: UIButton) { // buttonの色を変化させるメソッド
        print("ボタン押された",sender.tag)
        coverButton.removeFromSuperview()
        ideaColor = sender.tag
        let num = sender.tag
        coverButton.frame = CGRect(x:26 + num * 27, y:120,
                                   width:25, height:25)
        coverButton.backgroundColor = UIColor.white
        coverButton.alpha = 0.7
        self.insertPop.addSubview(coverButton)
    }
    
    @objc func changeColor2(sender: UIButton) { // buttonの色を変化させるメソッド
        print("ボタン押された",sender.tag)
        coverButton.removeFromSuperview()
        ideaColor = sender.tag
        let num = sender.tag
        coverButton.frame = CGRect(x:26 + num * 27, y:120,
                                   width:25, height:25)
        coverButton.backgroundColor = UIColor.white
        coverButton.alpha = 0.7
        self.detailPop.addSubview(coverButton)
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
        
        if let touch = touches.first {
            // タッチしたビューをviewプロパティで取得する
            if let touchedView = touch.view {
                // tagがどれか判断する
                if touchedView.tag >= 1 {
                    // gapX,gapYの取得は行わない
                    // touchedView.center = CGPoint(x: touch.location(in: view).x - gapX, y: touch.location(in: view).y - gapY)
                    
                    print(taptag)
                    if taptag >= 1 {
                        print(idList.count)
                        //labelの位置を記憶
                        self.defaultStore.collection("IdeaList").document(self.idList[taptag - 1]).setData([
                            "Theme": textLabelList[taptag - 1].text!,
                            "Detail": detailList[taptag - 1],
                            "TextColor": ideaColorList[taptag - 1],
                            "BoardID":boardID,
                            "X": touch.location(in: view).x - gapX,
                            "Y": touch.location(in: view).y - gapY
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written")
                            }
                        }
                    }
                }
            }
        }
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
