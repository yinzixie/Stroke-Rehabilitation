//
//  ButtonTriggerEvent.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class ButtonTriggerEvent {
    var Button:Button
    var Time:NSDate
    
    init(button:Button,time:NSDate) {
        Button = button
        Time = time
    }
    
    
}
