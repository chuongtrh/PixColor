//
//  AppDelegate.swift
//  livecolor
//
//  Created by Sam on 5/26/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import PINRemoteImage
import PINCache

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    //MARK - Application life cyclie
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.backgroundColor = background_color
        
        let cache:PINCache = PINRemoteImageManager.shared().cache as! PINCache
        cache.memoryCache.costLimit = UInt(600 * 600 * 100 * UIScreen.main.scale)
        // ~50 MB
        cache.diskCache.byteLimit = 100 * 1024 * 1024
        // 7 days
        cache.diskCache.ageLimit = 60 * 60 * 24 * 7
        
        //printFonts()
        
        return true
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

    //MAKR: -
    func application(_ app: UIApplication, open url: URL, _ options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }

}

