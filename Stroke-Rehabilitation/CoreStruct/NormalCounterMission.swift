//
//  GoalMission.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 23/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation

class NormalCounterMission {
    var MissionID:String
    var PatientID:String
    var AimGoal:Int //0 means no specific goal is setting
    var AimTime:Int //0 means no specific time is setting
    
    var StartTime:Int
    var FinalAchievement:Int
    var FinalTime:Int
    
    var ButtonTriggerEventList = [ButtonTriggerEvent]()
    
    init(missionID:String,patientID:String){
        MissionID = missionID
        PatientID = patientID
        AimGoal = 0
        AimTime = 0
        StartTime = 0
        FinalAchievement = 0
        FinalTime = 0
    }
    
    func setGoal(aimGoal:Int, aimTime:Int) {
        AimGoal = aimGoal
        AimTime = aimTime
    }
    
    func misionStartAt(startTime:Int) {
        StartTime = startTime
    }
    
    func setResult(achievement:Int, time:Int, eventList:[ButtonTriggerEvent]) {
        FinalAchievement = achievement
        FinalTime = time
        ButtonTriggerEventList = eventList
    }
}
