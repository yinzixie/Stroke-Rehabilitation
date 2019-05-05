//
//  Mission.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class Mission {
    
    var MissionID:Int
    var MissionType:CounterModel
    var AimNumber:Int?
    var AimTime:Int?
    var FinalNumber:Int = 0
    var FinalTime:Int? = nil
    
    var ButtonList = [Button]()
    var ButtonTriggerEventList = [ButtonTriggerEvent]()
    
    init(id:Int,type:CounterModel,number:Int?,time:Int?){
        MissionID = id
        MissionType = type
        AimNumber = number
        AimTime = time
    }
    
}
