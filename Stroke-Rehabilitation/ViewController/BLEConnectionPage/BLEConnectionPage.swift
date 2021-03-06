//
//  BLEConnectionPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 18/8/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol BlePageDelegate {
    func appear()
    func disappear()
}

class BLEConnectionPage: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var peripheralTable: UITableView!
    @IBOutlet weak var armButton: ZFRippleButton!
    @IBOutlet weak var triggerButton: ZFRippleButton!
    
    @IBOutlet weak var armIDLabel: UILabel!
    @IBOutlet weak var triggerIDLabel: UILabel!
    
    @IBOutlet weak var settingView: UIView!
    
    var blePageDelegate:BlePageDelegate?
    //Data
    var centralManager : CBCentralManager!
    var RSSIs = [NSNumber]()
    var data = NSMutableData()
    var writeData: String = ""
    var peripherals: [CBPeripheral] = []
    var characteristicValue = [CBUUID: NSData]()
    var timer = Timer()
    var characteristics = [String : CBCharacteristic]()
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        disconnectFromDevice()
        self.peripherals = []
        self.RSSIs = []
        self.peripheralTable.reloadData()
        startScan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        armIDLabel.text = defaults.string(forKey: UserDefaultKeys.ArmID) ?? BLEAdapter.SENSOR0_ID
        triggerIDLabel.text = defaults.string(forKey: UserDefaultKeys.TriggerID) ?? BLEAdapter.SENSOR1_ID
        settingView.isHidden = true
        
        self.peripheralTable.reloadData()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //let backButton = UIBarButtonItem(title: "Disconnect", style: .plain, target: nil, action: nil)
        //navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //disconnectFromDevice()
        super.viewDidAppear(animated)
        blePageDelegate?.appear()
        //refreshScanView()
        //print("View Cleared")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blePageDelegate?.disappear()
        print("Stop Scanning")
        centralManager?.stopScan()
    }
    
    /*Okay, now that we have our CBCentalManager up and running, it's time to start searching for devices. You can do this by calling the "scanForPeripherals" method.*/
    
    func startScan() {
        peripherals = []
        print("Now Scanning...")
        self.timer.invalidate()
        centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        Timer.scheduledTimer(timeInterval: 17, target: self, selector: #selector(self.cancelScan), userInfo: nil, repeats: false)
    }
    
    /*We also need to stop scanning at some point so we'll also create a function that calls "stopScan"*/
    @objc func cancelScan() {
        self.centralManager?.stopScan()
        print("Scan Stopped")
        print("Number of Peripherals Found: \(peripherals.count)")
    }
    
    func refreshScanView() {
        peripheralTable.reloadData()
    }
    
    //-Terminate all Peripheral Connection
    /*
     Call this when things either go wrong, or you're done with the connection.
     This cancels any subscriptions if there are any, or straight disconnects if not.
     (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    func disconnectFromDevice () {
        if BLEAdapter.blePeripheral != nil {
            // We have a connection to the device but we are not subscribed to the Transfer Characteristic for some reason.
            // Therefore, we will just disconnect from the peripheral
            centralManager?.cancelPeripheralConnection(BLEAdapter.blePeripheral!)
        }
    }
    
    
    func restoreCentralManager() {
        //Restores Central Manager delegate if something went wrong
        centralManager?.delegate = self
    }
    
    /*
     Called when the central manager discovers a peripheral while scanning. Also, once peripheral is connected, cancel scanning.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
        BLEAdapter.blePeripheral = peripheral
        self.peripherals.append(peripheral)
        self.RSSIs.append(RSSI)
        peripheral.delegate = self
        self.peripheralTable.reloadData()
        if BLEAdapter.blePeripheral == nil {
            print("Found new pheripheral devices with services")
            print("Peripheral name: \(String(describing: peripheral.name))")
            print("**********************************")
            print ("Advertisement Data : \(advertisementData)")
        }
    }
    
    //Peripheral Connections: Connecting, Connected, Disconnected
    
    //-Connection
    func connectToDevice () {
        centralManager?.connect(BLEAdapter.blePeripheral!, options: nil)
    }
    
    /*
     Invoked when a connection is successfully created with a peripheral.
     This method is invoked when a call to connect(_:options:) is successful. You typically implement this method to set the peripheral’s delegate and to discover its services.
     */
    //-Connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("*****************************")
        print("Connection complete")
        print("Peripheral info: \(String(describing: BLEAdapter.blePeripheral))")
        
        //Stop Scan- We don't need to scan once we've connected to a peripheral. We got what we came for.
        centralManager?.stopScan()
        print("Scan Stopped")
        
        //Erase data that we might have
        data.length = 0
        
        //Discovery callback
        peripheral.delegate = self
        //Only look for services that matches transmit uuid
        peripheral.discoverServices([BLEService_UUID])
        
        settingView.isHidden = false
       
    }
    
    /*
     Invoked when the central manager fails to create a connection with a peripheral.
     */
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    func disconnectAllConnection() {
        centralManager.cancelPeripheralConnection(BLEAdapter.blePeripheral!)
    }
    
    /*
     Invoked when you discover the peripheral’s available services.
     This method is invoked when your app calls the discoverServices(_:) method. If the services of the peripheral are successfully discovered, you can access them through the peripheral’s services property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")
        
        if ((error) != nil) {
        print("Error discovering services: \(error!.localizedDescription)")
        return
        }
        
        guard let services = peripheral.services else {
        return
        }
        //We need to discover the all characteristic
        for service in services {
        
        peripheral.discoverCharacteristics(nil, for: service)
        // bleService = service
        }
        print("Discovered Services: \(services)")
    }
    
    /*
     Invoked when you discover the characteristics of a specified service.
     This method is invoked when your app calls the discoverCharacteristics(_:for:) method. If the characteristics of the specified service are successfully discovered, you can access them through the service's characteristics property. If successful, the error parameter is nil. If unsuccessful, the error parameter returns the cause of the failure.
     */
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    
        print("*******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics!")
        
        for characteristic in characteristics {
        //looks for the right characteristic
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
                BLEAdapter.rxCharacteristic = characteristic
                
                //Once found, subscribe to the this particular characteristic...
                peripheral.setNotifyValue(true, for: BLEAdapter.rxCharacteristic!)
                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                // didUpdateNotificationStateForCharacteristic method will be called automatically
                peripheral.readValue(for: characteristic)
                print("Rx Characteristic: \(characteristic.uuid)")
            }
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
                BLEAdapter.txCharacteristic = characteristic
                print("Tx Characteristic: \(characteristic.uuid)")
            }
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    // Getting Values From Characteristic
    
    /*After you've found a characteristic of a service that you are interested in, you can read the characteristic's value by calling the peripheral "readValueForCharacteristic" method within the "didDiscoverCharacteristicsFor service" delegate.
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    
        if characteristic == BLEAdapter.rxCharacteristic {
            if let ASCIIstring = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) {
            BLEAdapter.characteristicASCIIValue = ASCIIstring
            let receiveText = BLEAdapter.characteristicASCIIValue as String
            print("Value Recieved: \(receiveText)")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: nil)
            
            //receiveText.split(separator: ":")
            if(BLEAdapter.checkValue(value: receiveText)) {
                if(receiveText.split(separator: ":")[0] == BLEAdapter.ARM_ID ) {
                    if(receiveText.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY){
                        self.armButton.backgroundColor = UIColor.lightGray
                    }else if(receiveText.split(separator: ":")[1] == BLEAdapter.PRESS_KEY){
                         self.armButton.backgroundColor = UIColor(red: 0.16, green: 0.8, blue: 0.25, alpha: 1)
                    }
                }
                else if(receiveText.split(separator: ":")[0] == BLEAdapter.TRIGGER_ID ) {
                    if(receiveText.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY){
                       self.triggerButton.backgroundColor = UIColor.lightGray
                        
                    }else if(receiveText.split(separator: ":")[1] == BLEAdapter.PRESS_KEY){
                         self.triggerButton.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(0.58), blue: CGFloat(0), alpha: 1)
                    }
                }
            }
                
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        
        if error != nil {
            print("\(error.debugDescription)")
            return
        }
        if ((characteristic.descriptors) != nil) {
            for x in characteristic.descriptors!{
                let descript = x as CBDescriptor?
                print("function name: DidDiscoverDescriptorForChar \(String(describing: descript?.description))")
                print("Rx Value \(String(describing: BLEAdapter.rxCharacteristic?.value))")
                print("Tx Value \(String(describing: BLEAdapter.txCharacteristic?.value))")
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        
        if (error != nil) {
            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
        
        } else {
            print("Characteristic's value subscribed")
        }
        
        if (characteristic.isNotifying) {
            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
        settingView.isHidden = true
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
            guard error == nil else {
                print("Error discovering services: error")
                return
            }
            print("Message sent")
        }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Succeeded!")
    }
    
    //Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Connect to device where the peripheral is connected
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralListCell") as! PeripheralListCell
        let peripheral = self.peripherals[indexPath.row]
        let RSSI = self.RSSIs[indexPath.row]
        
        if peripheral.name == nil {
            cell.peripheralLabel.text = "nil"
        } else {
            cell.peripheralLabel.text = peripheral.name
        }
        cell.rssiLabel.text = "RSSI: \(RSSI)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEAdapter.blePeripheral = peripherals[indexPath.row]
        connectToDevice()
    }
    
    /*
     Invoked when the central manager’s state is updated.
     This is where we kick off the scan if Bluetooth is turned on.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            // We will just handle it the easy way here: if Bluetooth is on, proceed...start scan!
            print("Bluetooth Enabled")
            startScan()
        
        } else {
            //If Bluetooth is off, display a UI alert message saying "Bluetooth is not enable" and "Make sure that your bluetooth is turned on"
            print("Bluetooth Disabled- Make sure your Bluetooth is turned on")
            
            let alertVC = UIAlertController(title: "Bluetooth is not enabled", message: "Make sure that your bluetooth is turned on", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func swapID(_ sender: Any) {
        let temp = BLEAdapter.ARM_ID
        BLEAdapter.setArmID(id: BLEAdapter.TRIGGER_ID)
        BLEAdapter.setTriggerID(id: temp)
        
        let defaults = UserDefaults.standard
        armIDLabel.text = defaults.string(forKey: UserDefaultKeys.ArmID)
        triggerIDLabel.text = defaults.string(forKey: UserDefaultKeys.TriggerID) ?? BLEAdapter.SENSOR1_ID

    }
    
    @IBAction func start(_ sender: Any) {
        //Once connected, move to new view controller to manager incoming and outgoing data
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
         //let normalCounterPage = storyboard.instantiateViewController(withIdentifier: "NormalCounterPage") as! NormalCounterPage
         //normalCounterPage.peripheral = BLEAdapter.blePeripheral
        self.dismiss(animated: true, completion: nil)
    }
}


