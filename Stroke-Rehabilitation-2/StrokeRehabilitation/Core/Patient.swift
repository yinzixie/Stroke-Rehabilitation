//
//  Patient.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

class Patient {
    
   /* enum gender {
        case man
        case women
        case neutral
        
        func string_() -> String {
            
            switch self {
            case .man: return "man"
            case .women: return "women"
            case .neutral: return "neutral"            
            }
        }
    }*/
    
    var ID:String
    var Firstname:String
    var Givenname:String
    var Age:Int
    var Gender:String
    var AimMissionTableName:String
    var HistoryMissionTableName:String
    var AimMissionList = [Mission]()
    var HistoryMissionList = [Mission]()
    
    init(id:String,firstname:String,givenname:String,sex:String,age:Int) {
        ID = id
        Firstname = firstname
        Givenname = givenname
        Gender = sex
        Age = age
        AimMissionTableName = ID + "AimMissionTable"
        HistoryMissionTableName = ID + "HistoryMissionTable"
    }
    
}
