//
//  NormalCounterPage.swift
//  Stroke-Rehabilitation
//
//  Created by Reuben Chaffer on 3/5/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class NormalCounterPage: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var hintLoginNameLabel: UILabel!
    
    var count:Int = 0 //value to be displayed on the counter
    var armed:Bool = false //used for checking if the counter has been armed
    var audioPlayer = AudioEffectController()
    
    var peripheralManager: CBPeripheralManager?
    //var peripheral: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super_init()
        // Do any additional setup after loading the view.
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        
        if(DBAdapter.logPatient?.ID == UserDefaultKeys.VisitorID){
            print("Entering as a vistor...")
        }else {
            print("Entering as patient with ID: " + DBAdapter.logPatient!.ID)
        }
    }
    
    func super_init() {
        DBAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         hintLoginNameLabel.text = DBAdapter.logPatient.Name
    }
    
    @IBAction func bluetoothSettings(_ sender: Any) {
        performSegue(withIdentifier: "bluetoothSegue", sender: self)
        
    }
    /*
     The arm function is used to arm the counter, making it ready to trigger.
     */
    func arm() -> Void
    {
        if armed == false
        {
            armed = true
        }
        
    }
    /*
     The trigger function is used to either increment the counter, if it has been armed, or to display a message telling the user they pressed the wrong button.
     */
    func trigger() -> Void
    {
        if armed == true
        {
            if count >= 0
            {
                count += 1 //increase the value of count
                counterLabel.text = String(count) //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                print(count)
            }
        }
        
    }
    
    
    
    func reset() -> Void
    {
        count = 0
        counterLabel.text = String(count)
    }
    
    
    @IBAction func armButtonPress(_ sender: UIButton) {
        //links our arm button and tells it to run the arm function when pressed
        audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        arm()
    }
    
    @IBAction func triggerButtonPress(_ sender: UIButton) {
        //links our trigger button and tells it to run the trigger function when presed
        audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        trigger()
    }
    
    @IBAction func resetButtonPress(_ sender: UIButton) {
        reset()
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

extension NormalCounterPage:CBPeripheralManagerDelegate {
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let rawValue = BLEAdapter.characteristicASCIIValue as String
            if(BLEAdapter.checkValue(value: rawValue)) {
                if(rawValue.split(separator: ":")[0] == BLEAdapter.ARM_ID && rawValue.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY) {
                    self.audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
                    self.arm()
                }
                else if(rawValue.split(separator: ":")[0] == BLEAdapter.TRIGGER_ID && rawValue.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY) {
                    self.audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
                    self.trigger()
                    
                }
            }
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
    
    
}
