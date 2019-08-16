//
//  BlueToothCheckPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 17/8/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit
import CoreBluetooth

class BlueToothCheckPage: UIViewController, CBCentralManagerDelegate {
    var manage:CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        manage = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var consoleMsg = ""
        switch (central.state) {
        case .poweredOff:
            consoleMsg = "BLE is powered off"
        case .poweredOn:
            consoleMsg = "BLE is powered on"
        case .resetting:
            consoleMsg = "BLE is resetting"
        case .unauthorized:
            consoleMsg = "BLE is unauthorized"
        case .unknown:
            consoleMsg = "BLE is unknown"
        case .unsupported:
            consoleMsg = "BLE is unsupported"
        
        }
        print("\(consoleMsg)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
