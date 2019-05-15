//
//  Mission.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class Mission {
    
    enum missiontype {
        case normal
        case game1
        case game2
        case game3
    }
    
    var MissionID:Int
    var MissionType:missiontype
    var AimNumber:Int?
    var AimTime:NSDate?
    var FinalNumber:Int = 0
    var FinalTime:Int? = nil
    
    var ButtonList = [Button]()
    var ButtonTriggerEventList = [ButtonTriggerEvent]()
    
    init(id:Int,type:missiontype,number:Int?,time:NSDate?){
        MissionID = id
        MissionType = type
        AimNumber = number
        AimTime = time
    }
    
}
