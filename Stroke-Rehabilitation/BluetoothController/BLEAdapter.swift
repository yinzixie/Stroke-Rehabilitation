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
    
    static let PRESS_KEY = "1"
    static let RELEASE_KEY = "0"
    init() {
        
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
    
}
