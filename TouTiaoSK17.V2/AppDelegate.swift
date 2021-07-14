//
//  AppDelegate.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/6/25.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //1.创建新window
                self.window = UIWindow.init(frame: UIScreen.main.bounds)
        //2.设置window的rootViewController
        //导航栏设置
        self.window?.rootViewController = UINavigationController.init(rootViewController: MenuViewController())
//        self.window?.rootViewController = MenuViewController()
        //3.设置背景色
//               self.window?.backgroundColor = UIColor.white
        //4.展示window和设置为关键window
                self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle



}

