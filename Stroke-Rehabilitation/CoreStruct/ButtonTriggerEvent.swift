//
//  ButtonTriggerEvent.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class ButtonTriggerEvent {
    var EventID:String
    var PatientID:String
    var MissionID:String
    var Button:Button //button id in database
    var TriggerTime:Int
    
    init(missionID:String, patientID:String, button:Button, timeinterval:Int) {
        MissionID = missionID
        PatientID = patientID
        Button = button
        TriggerTime = timeinterval
        EventID = missionID + "-" + Button.ButtonID + "-" + String(timeinterval)
    }
}
