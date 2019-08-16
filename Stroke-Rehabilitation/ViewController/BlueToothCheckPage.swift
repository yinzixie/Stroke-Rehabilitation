//
//  BlueToothCheckPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 17/8/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit
import CoreBluetooth

class BlueToothCheckPage: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    var manager:CBCentralManager!
    
   
    @IBOutlet weak var la: UILabel!
    @IBOutlet weak var la2: UILabel!
    
    var bleButtons: CBPeripheral?
    var characteristic: CBMutableCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //find bluetooth and try to connect
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if(peripheral.name == "Adafruit Bluefruit LE") {
            print("Peripheral: \(peripheral)")
            la2.text = "Peripheral: \(String(describing: peripheral.name))"
            
            bleButtons = peripheral
            
            bleButtons?.delegate = self
            
            
            
            manager.connect(bleButtons!, options: nil)
        }
    }
    
    //connected succeed!
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        manager.stopScan()
    }
    
    //disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("DisConnected!")
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    private let Service_UUID: String = "CDD1"
    private let Characteristic_UUID: String = "CDD2"
    
    /** 发现服务 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service: CBService in peripheral.services! {
            print("外设中的服务有：\(service)")
        }
        //本例的外设中只有一个服务
        let service = peripheral.services?.last
        // 根据UUID寻找服务中的特征
        peripheral.discoverCharacteristics([CBUUID.init(string: Characteristic_UUID)], for: service!)
    }
    
    /** 发现特征 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic: CBCharacteristic in service.characteristics! {
            print("外设中的特征有：\(characteristic)")
        }
        
        self.characteristic = service.characteristics?.last as! CBMutableCharacteristic
        // 读取特征里的数据
        peripheral.readValue(for: self.characteristic!)
        // 订阅
        peripheral.setNotifyValue(true, for: self.characteristic!)
    }
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = characteristic.value
        self.la2.text = String.init(data: data!, encoding: String.Encoding.utf8)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var consoleMsg = ""
        switch (central.state) {
        case .poweredOff:
            consoleMsg = "BLE is powered off"
        case .poweredOn:
            consoleMsg = "BLE is powered on"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            consoleMsg = "BLE is resetting"
        case .unauthorized:
            consoleMsg = "BLE is unauthorized"
        case .unknown:
            consoleMsg = "BLE is unknown"
        case .unsupported:
            consoleMsg = "BLE is unsupported"
        
        }
        la.text = consoleMsg
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
