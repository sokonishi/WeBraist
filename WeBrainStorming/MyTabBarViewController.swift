//
//  MyTabBarViewController.swift
//  WeBrainStorming
//
//  Created by 小西壮 on 2018/10/21.
//  Copyright © 2018年 小西壮. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor(red: 32/255, green: 194/255, blue: 212/255, alpha: 1.0) // yellow
        
        // 背景色
        UITabBar.appearance().barTintColor = UIColor(red: 66/255, green: 74/255, blue: 93/255, alpha: 1.0) // grey black
    }

}
