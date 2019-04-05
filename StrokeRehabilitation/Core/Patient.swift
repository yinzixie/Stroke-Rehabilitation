//
//  Patient.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class Patient {
    
    enum gender {
        case man
        case women
        case neutral
    }
    
    var ID:Int
    var Gender:gender
    var AimMissionList = [Mission]()
    var HistoryMissionList = [Mission]()
    
    init(id:Int,sex:gender) {
        ID = id
        Gender = sex
    }
    
}
