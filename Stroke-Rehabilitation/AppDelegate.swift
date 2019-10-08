//
//  AppDelegate.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 21/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //static var mission = NormalCounterMission(missionID: "NULL-mission", patientID: DBAdapter.logPatient.ID)
    
    static var BLEPage:BLEConnectionPage?
    static var normalCounterPage:NormalCounterPage?
    static var goalCounterPage:GoalCounterPage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = BLEAdapter()
        _ = DBAdapter()
        
        if (AppDelegate.BLEPage == nil) {
            // initialize view controller (for a storyboard, you'd do it like so, making sure your storyboard filename and view controller identifier are set properly):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            AppDelegate.BLEPage = storyboard.instantiateViewController(withIdentifier: "BLEConnectionPage") as? BLEConnectionPage
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if(AppDelegate.normalCounterPage != nil) {
            if(AppDelegate.normalCounterPage!.missionInProcess) {
                let triggerButton = Button(id: UserDefaultKeys.LeaveAppButton)
                let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: (AppDelegate.normalCounterPage?.mission.MissionID)!, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
                AppDelegate.normalCounterPage?.mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
            }
        }
        if(AppDelegate.goalCounterPage != nil) {
            if(AppDelegate.goalCounterPage!.missionInProcess) {
                let triggerButton = Button(id: UserDefaultKeys.LeaveAppButton)
                let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: (AppDelegate.goalCounterPage?.mission.MissionID)!, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
                AppDelegate.goalCounterPage?.mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if(AppDelegate.normalCounterPage != nil) {
             if(AppDelegate.normalCounterPage!.missionInProcess) {
                let triggerButton = Button(id: UserDefaultKeys.EnterAppButton)
                let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: (AppDelegate.normalCounterPage?.mission.MissionID)!, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
                AppDelegate.normalCounterPage?.mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
            }
        }
        if(AppDelegate.goalCounterPage != nil) {
            if(AppDelegate.goalCounterPage!.missionInProcess) {
                let triggerButton = Button(id: UserDefaultKeys.EnterAppButton)
                let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: (AppDelegate.goalCounterPage?.mission.MissionID)!, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
                AppDelegate.goalCounterPage?.mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

