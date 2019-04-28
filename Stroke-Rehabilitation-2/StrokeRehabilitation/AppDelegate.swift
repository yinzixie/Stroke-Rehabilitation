//
//  AppDelegate.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 2/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        login()
        // Override point for customization after application launch.
        return true
    }
    
    func login(){
        let genderValue = "Man"
        let id = "1"
        let age = "12"
        let firstname = "liao"
        let givenname = "tech"
        
        guard (id != "") else{
            parameterAlert(message: "Please input id!")
            return
        }
        guard (firstname != "") else{
            parameterAlert(message: "Please input first name!")
            return
        }
        guard (givenname != "") else{
            parameterAlert(message: "Please input given name!")
            return
        }
       
        
     
        
         let patient:Patient = Patient(id:id,firstname:firstname,givenname:givenname,sex:genderValue,age:Int(age )!)
        
        
        guard database.insertPatient(patient:patient) else {
//            parameterAlert(message: "Create Failed!Usually caused by repeated id")
            return
        }

    }
    
    
    func parameterAlert(message:String){
       
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

