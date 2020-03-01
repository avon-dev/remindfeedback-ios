//
//  AppDelegate.swift
//  rfios
//
//  Created by Taeheon Woo on 2019/11/08.
//  Copyright © 2019 avon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIUtil.screenSize = UIScreen.main.bounds // 단말기의 화면 크기를 저장
        UIUtil.screenWidth = UIUtil.screenSize.width // 단말기 화면의 가로 길이 저장
        UIUtil.screenHeight = UIUtil.screenSize.height // 단말기 화면의 세로 길이 저장
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension UIApplication {
    class var statusBarView: UIView? {
        var statusBarView: UIView?
        
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = UIApplication.shared.keyWindow?.viewWithTag(tag) {
                statusBarView = statusBar
                
            } else {
                let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBar.tag = tag
                UIApplication.shared.keyWindow?.addSubview(statusBar)
                statusBarView = statusBar
                
            }
            
        } else {
            statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            
        }
        
        return statusBarView
        
    }
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            return statusBarView?.backgroundColor
            
        }
        set {
            statusBarView?.backgroundColor = newValue
            
        }
        
    }
    
}


