//
//  DBAdapter.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 4/5/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation

protocol TellUserListTableAddAccount {
    func addAccount()
}

protocol SendMessageToNormalCounterPage {
    func userChanged()
}

protocol SendMessageToGoalCounterPage {
    func userChanged()
}

public class DBAdapter {
    static var tellUserListTableAddAccount:TellUserListTableAddAccount?
    static var delegateForNormalCounterPage:SendMessageToNormalCounterPage?
    static var delegateForGoalCounterPage:SendMessageToGoalCounterPage?
    
    static var database:SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
    static var patientList = [Patient]()
    static var logPatient:Patient!
    
    init() {
        print("Init DBAdapter")
        //get all patients
        DBAdapter.patientList = DBAdapter.database.selectAllPatients()
        //get login cache
        let defaults = UserDefaults.standard
        let logid = defaults.string(forKey: UserDefaultKeys.LoginUserID) ?? UserDefaultKeys.VisitorID
        DBAdapter.logPatient = DBAdapter.database.selectPatientByID(id: logid)
        if((DBAdapter.logPatient) == nil) {
            DBAdapter.logPatient = DBAdapter.database.selectPatientByID(id: UserDefaultKeys.VisitorID)
        }
    }
    
    static func refreshPatientList(){
        DBAdapter.patientList = DBAdapter.database.selectAllPatients()
    }
    
    static func refreshlogPatient(patient:Patient){
        DBAdapter.logPatient = patient
        
        //set login cache
        let defaults = UserDefaults.standard
        defaults.setValue(patient.ID, forKey: UserDefaultKeys.LoginUserID)
        
        //tell relative pages log user has changed
        delegateForNormalCounterPage?.userChanged()
        delegateForGoalCounterPage?.userChanged()
    }
    
    static func refreshlogPatientData() {
        DBAdapter.logPatient = DBAdapter.database.selectPatientByID(id: DBAdapter.logPatient.ID)
    }
    
    
    static func addPatient(patient:Patient)->Bool {
        guard database.insertPatient(patient:patient) else {
            return false
        }
        DBAdapter.refreshPatientList()
        tellUserListTableAddAccount?.addAccount()
        return true
    }
    
    static func deletePatient(patient:Patient)->Bool {
        if(database.deletePatient(patient: patient)) {
            DBAdapter.refreshPatientList()
            return true
        }
        return false
    }
    
    static func selectPatientByID(id:String)->Patient? {
        let sPatient = database.selectPatientByID(id: id)
        return sPatient
    }
    
    static func selectPatientName(id:String)->String? {
        let sPatient = database.selectPatientByID(id: id)
        return sPatient!.Name
    }
    
    static func isUserIDExist(id:String)->Bool {
        let sPatient = database.selectPatientByID(id: id)
        if((sPatient) != nil) {
            return true
        }else {
            return false
        }
    }
    
    static func isExericeAtDay(day:Date)->Bool {
        for mission in  DBAdapter.logPatient.HistoryNormalCounterMissionList {
            if(TimeInfo.compareOneDay(oneDay:day, withAnotherDay:Date(timeIntervalSince1970: TimeInterval(mission.StartTime))) == 0) {
               return true
            }
        }
        return false
    }
    
    static func numberOfCompletedMission(missionList:[NormalCounterMission])->Int {
        var result = 0
        for mission in missionList {
            if(mission.FinalAchievement >= mission.AimGoal) {
                result += 1
            }
        }
        return result
    }
    
    static func numberOfReps(missionList:[NormalCounterMission])->Int {
        var result = 0
        for mission in missionList {
                result += mission.FinalAchievement
        }
        return result
    }
    
    static func numberOfTimes(missionList:[NormalCounterMission])->Float {
        var result = 0
        for mission in missionList {
            let difference = mission.FinalTime - mission.StartTime
                result += difference
            }
        return Float(result)
    }
    
    static func selectNormalCounterMissionForDay(day:Date)->[NormalCounterMission] {
        var result = [NormalCounterMission]()
        for mission in  DBAdapter.logPatient.HistoryNormalCounterMissionList {
            if(TimeInfo.compareOneDay(oneDay:day, withAnotherDay:Date(timeIntervalSince1970: TimeInterval(mission.StartTime))) == 0) {
                result += [mission]
            }
        }
         return result
    }
    
    static func updatePatientNormalCounterPresetGoal(patient:Patient) {
        database.updateNormalCounterPresetGoal(patient: patient)
        //logPatient = database.selectPatientByID(id: patient.ID)
        refreshPatientList()
        //tellNormalCounterScreenUpdate?.updateData()
    }
    
    static func insertNormalCounterMission(mission:NormalCounterMission)->Bool {
        //insert mission
        if(database.insertNormoalCounterMission(mission: mission)) {
            return true
        }
        else {
            return false
        }
    }
    
}
