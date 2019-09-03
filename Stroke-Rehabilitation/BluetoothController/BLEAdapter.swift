//
//  BLEAdapter.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 18/8/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEAdapter{
    static var blePeripheral : CBPeripheral?
    
    static var txCharacteristic : CBCharacteristic?
    static var rxCharacteristic : CBCharacteristic?
    
    static var characteristicASCIIValue = NSString()
    
    static let SENSOR0_ID = "sensor0"
    static let SENSOR1_ID = "sensor1"
    
    static var ARM_ID = "sensor0"
    static var TRIGGER_ID = "sensor1"
    
    static let PRESS_KEY = "1"
    static let RELEASE_KEY = "0"
    
    init() {
        print("Init BLEdapter")
        //set id
        let defaults = UserDefaults.standard
        
        //defaults.setValue(BLEAdapter.ARM_ID, forKey: UserDefaultKeys.ArmID)
        //defaults.setValue(BLEAdapter.TRIGGER_ID, forKey: UserDefaultKeys.TriggerID)
        
        BLEAdapter.ARM_ID = defaults.string(forKey: UserDefaultKeys.ArmID) ?? BLEAdapter.SENSOR0_ID
        BLEAdapter.TRIGGER_ID = defaults.string(forKey: UserDefaultKeys.TriggerID) ?? BLEAdapter.SENSOR1_ID
    }
    
    func reFreshDevice(bleDevice:CBPeripheral){
        BLEAdapter.blePeripheral = bleDevice
    }
    
    static func checkValue(value:String)->Bool {
        if(value.split(separator: ":").count != 2) {
            return false
        }else {
            return true
        }
    }
    
    static func setArmID(id:String) {
        BLEAdapter.ARM_ID = id
        //write into defaults
        let defaults = UserDefaults.standard
        defaults.setValue(BLEAdapter.ARM_ID, forKey: UserDefaultKeys.ArmID)
    }
    
    static func setTriggerID(id:String) {
        BLEAdapter.TRIGGER_ID = id
        //write into defaults
        let defaults = UserDefaults.standard
        defaults.setValue(BLEAdapter.TRIGGER_ID, forKey: UserDefaultKeys.TriggerID)
    }
    
}
