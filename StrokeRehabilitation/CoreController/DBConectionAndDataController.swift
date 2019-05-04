//
//  DBConectionAndDataController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 4/5/19.
//  Copyright © 2019 Project. All rights reserved.
//

import Foundation

protocol TellAccountTableAddAccount {
    func addAccount()
}

public class DBConectionAndDataController {
    
    static var tellAccountTableAddAccount:TellAccountTableAddAccount?
    
    static let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
    
    static  var patientList = [Patient]()
        
    
    init() {
        print("Init DBConectionAndDataController")
        DBConectionAndDataController.patientList = DBConectionAndDataController.database.selectAllPatients()
    }
    
    static func refreshPatientList(){
        DBConectionAndDataController.patientList = DBConectionAndDataController.database.selectAllPatients()
    }
    
    static func addPatient(patient:Patient)->Bool {
        guard database.insertPatient(patient:patient) else {
            return false
        }
        DBConectionAndDataController.refreshPatientList()
        tellAccountTableAddAccount?.addAccount()
        return true
    }
    
    static func deletePatient(patient:Patient)->Bool {
        if(database.deletePatient(patient: patient)) {
            database.deletePatientRelevantTable(patient: patient)
            DBConectionAndDataController.refreshPatientList()
            return true
        }
        return false
    }
    
}
