//
//  AppDelegate.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navController: UINavigationController?
    var window: UIWindow?

    var pitchExamples = Array<Array<String>>()
    var pitchTrials = Array<Array<String>>()
    var pitchTasks = Array<Array<String>>()
    var digitalSpanForward = Array<String>()
    var digitalSpanBackward = Array<String>()
    var wordListTrials = Array<String>()
    var wordListTasks = Array<String>()
    var stroopImages = Array<String>()
    var stroopVideos = Array<String>()
    var namingTaskPractice = Array<String>()
    var namingTaskTask = Array<String>()
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    static var position = 0
    static var testPosition = 0
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        AppUtility.lockOrientation(.all)
        
        do {
            try DatabaseController.saveContext()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

