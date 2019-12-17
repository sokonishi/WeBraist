//
//  AppDelegate.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/09/30.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    //アプリの立ち上げ時処理
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        //
        switchHomeView()
        
        return true
    }

    //Googleへの認証プロセスの最後に、アプリが受け取るURLを処理する(iOS９以降)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
    
    //Googleへの認証プロセスの最後に、アプリが受け取るURLを処理する(iOS８以前)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

//2回目以降のログイン省略
extension AppDelegate {
    
    func switchHomeView() {
        let user = Auth.auth().currentUser
        
        let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
        var viewController:UIViewController
        
        //表示するビューコントローラーを指定
        if  user == nil {
            // 未ログインの場合
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        } else {
            // ログイン済みの場合
            viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as UIViewController
        }
        
        window?.rootViewController = viewController
    }
    
}

