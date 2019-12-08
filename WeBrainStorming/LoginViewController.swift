//
//  LoginViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/05.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var contractBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var googleButtonView: UIView!
    
    var  contractNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        print(self.emailTextField.frame.origin.y)
        //グーグルのボタン追加
        let googleBtn = GIDSignInButton()
        googleBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 50, height: 60)
        googleButtonView.addSubview(googleBtn)
        
        signUpBtn.isEnabled =  false
        logInBtn.isEnabled = false
        signUpBtn.backgroundColor = UIColor(red: 169/225, green: 169/225, blue: 169/255, alpha: 1.0)
        logInBtn.backgroundColor = UIColor(red: 169/225, green: 169/225, blue: 169/255, alpha: 1.0)
//        googleBtn.isEnabled = false
    }
    
    //Googleログイン時の処理
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        //Googleログイン時エラーが発生したら、エラーを返し、この関数から抜ける
        if let error = error {
            print("memo:Googleログイン後エラー",error)
            alert(memo:"memo:Googleログイン後エラー")
            return
        }
        //authenticationに情報が入っていなかったら、この関数から抜ける
        //user.authentication else に何もなかったら
        guard let authentication = user.authentication else { return }
        
        //ログインに成功したら、各種トークンを受け取る
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        //トークンを受け取った後の処理を記述
        //トークンを受け取った後の処理を記述.Googleから得たトークンをFirebaseへ保存
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("memo:FirebaseへGoogleから得たトークン保存時にエラー",error)
                self.alert(memo:"FirebaseへGoogleから得たトークン保存時にエラー")
                return
            }
            print("memo:Googleログイン成功",authResult?.additionalUserInfo)
//            self.alert(memo:"Googleログイン成功\(authResult?.user.email)")
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }
    }
    
    //ログイン失敗時の処理
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Googleログイン時エラーが発生したら、エラーを返し、この関数から抜ける
        if let error = error {
            print("memo:Googleログイン失敗エラー",error)
            alert(memo:"memo:Googleログイン失敗エラー")
            return
        }
    }

    @IBAction func new(_ sender: UIButton) {
        //createUserは新規登録
        print("memo:新規登録開始")
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!) { (authResult, error) in
            if let error = error {
                print("memo:新規登録エラー\(error)")
                self.alert(memo:"新規登録エラー\(error)")
                return
            }
            if let authResult = authResult{
                print("memo:新規登録成功",authResult.user.email!)
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        print("memo:ログイン開始")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { (user, error) in
            if let error = error {
                print("memo:ログインエラー\(error)")
                self.alert(memo:"ログインエラー\(error)")
                return
            }
            if let user = user {
                print("memo:ログイン成功",user.user.email!)
//                self.alert(memo:"ログイン成功")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func alert(memo:String){
        let alert = UIAlertController(title: "アラート", message: memo, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) -> Void in
            //OKを押した後の処理。
        }))
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
    }
    
    @IBAction func checkContractBtn(_ sender: UIButton) {
    
        if contractNum == 0 {
            
            contractNum = 1
            print(contractNum)
            let checkBoxImage = UIImage(named: "CheckBox_1")
            contractBtn.setImage(checkBoxImage, for: .normal)
            
            signUpBtn.isEnabled =  true
            logInBtn.isEnabled = true
            
            signUpBtn.backgroundColor = UIColor(red: 18/225, green: 182/225, blue: 199/255, alpha: 1.0)
            logInBtn.backgroundColor = UIColor(red: 18/225, green: 182/225, blue: 199/255, alpha: 1.0)
            
        } else if contractNum == 1 {

            contractNum = 0
            print(contractNum)
            let checkBoxImage = UIImage(named: "CheckBox_0")
            contractBtn.setImage(checkBoxImage, for: .normal)

            signUpBtn.isEnabled =  false
            logInBtn.isEnabled = false
//            self.googleBtn.isEnabled = false
            
            signUpBtn.backgroundColor = UIColor(red: 169/225, green: 169/225, blue: 169/255, alpha: 1.0)
            logInBtn.backgroundColor = UIColor(red: 169/225, green: 169/225, blue: 169/255, alpha: 1.0)
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
