//
//  Patient.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

public class Patient {

    var ID:String //id identifier for log in
    var Name:String
    
    var NormalCounterGoal:Int
    var NormalCounterLimitTime:Int
    
    var HistoryNormalCounterMissionList = [NormalCounterMission]()
    
    init() {
        ID = "0"
        Name = "visitor"
        NormalCounterGoal = 0
        NormalCounterLimitTime = 0
    }
    
    func setPatientPresetGoal(normalGoal:Int,normalTime:Int) {
        NormalCounterGoal = normalGoal
        NormalCounterLimitTime = normalTime
    }
}
