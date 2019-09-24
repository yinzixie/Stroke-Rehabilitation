//
//  GoalCounterPage.swift
//  Stroke-Rehabilitation
//
//  Created by Edward Boreham on 7/5/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit
import CoreBluetooth

class GoalCounterPage: UIViewController{
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var hintLoginNameLabel: UILabel!
   
    var peripheralManager: CBPeripheralManager?
    //var peripheral: CBPeripheral?
    
    var mission:NormalCounterMission!
    var missionInProcess = false // is mission in processing
    
    var audioPlayer = AudioEffectController()
    
    var countdown = TimeInterval(0) //time of timer
    
    var realCount:Int = 0 //true press value
    var displayCount:Int = 0//value to be displayed on the counter
    
    var timer = Timer()
    var isTimerRunning = false
    
    var armed:Bool = false //used for checking if the counter has been armed
    var firstArm:Bool = true //if this variable is true, armed has not been pressed, and the timer will be activated.
    
    var hasGoal:Bool = false
    var hasTimer:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        // Do any additional setup after loading the view.
        
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
        //register DBAdapter
        DBAdapter.delegateForGoalCounterPage = self
        
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        
        //get preset mission
        let mission_id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: mission_id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        progressBar.setProgress(0, animated: false)
        
        goalLabel.text = String(displayCount)
        timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        
        if(mission.AimGoal > 0 && mission.AimTime > 0) {
            hasGoal = true
            hasTimer = true
            print("Count down version with goal")
        }else if(mission.AimTime > 0) {
            hasTimer = true
            print("Count Down version(without arm goal)")
        }else if(mission.AimGoal > 0) {
            hasGoal = true
            print("Timer version with goal")
        }else {
            print("Timer version(without any goal)")
        }
        
        
    }
    
    func runTimer() //runs the specified function (updateTimer) once every timeInterval (1 second)
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GoalCounterPage.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // stop timer
    func stopTimer() {
        timer.invalidate() //destroy timer
        timer = Timer()
    }
    
    @objc func updateTimer()//decrements the timer every second and refreshes the label
    {
        if(hasTimer) {
            countdown -= 1
            timerLabel.text = TimerFormattor.formatter.string(from: countdown)
            
            //time is up before user finish all task
            if countdown == 0
            {
                missionFinshed()
                
                let alert = UIAlertController(title: "Time's Up!", message: "Your timer has ended. Tap finish to bring up the goal page or Reset to start again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: {(alert: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                })) //back to normal counter page
                alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(alert: UIAlertAction!) in self.reset()}))
                self.present(alert, animated: true)//presents the alert
            }
        }else {
            countdown += 1
            timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        }
    }
    
    
    /*
     The arm function is used to arm the counter, making it ready to trigger.
     */
    func arm() -> Void
    {
        if firstArm == true
        {
            missionStart()
            firstArm = false
        }
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
            realCount += 1
            if displayCount > 0
            {
                displayCount -= 1 //decrease the value of count
                goalLabel.text = String(displayCount) //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                progressBar.setProgress(Float(mission.AimGoal - displayCount)/Float(mission.AimGoal), animated: true)
               
                print(displayCount)
            }
            else //if the counter is zero or below, keep decrementing but remove the negative sign so it looks like its counting up
            {
                displayCount -= 1 //decrease the value of count
                var stringCount = String(displayCount)
                stringCount.remove(at: stringCount.startIndex)
                goalLabel.text = stringCount //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                print(displayCount)
            }
            
            //user finish mission before the time is up
            if mission.AimGoal > 0 && displayCount == 0
            {
                missionFinshed()
                
                let alert = UIAlertController(title: "Congratulations!", message: "You have completed your target reps.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: {(alert: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                })) //back to normal counter page
                alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(alert: UIAlertAction!) in self.reset()}))
                self.present(alert, animated: true)//presents the alert
            }
        }
    }
    
    func reset() -> Void //resets the goal and timer values to their starting values and refreshes the labels
    {
        stopTimer()
        firstArm = true
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        goalLabel.text = String(displayCount)
        timerLabel.text = TimerFormattor.formatter.string(from: countdown)
    }
    
    @IBAction func arm(_ sender: AnyObject) { //links our arm button and tells it to run the arm function when pressed
        audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        let armButton = Button(id: UserDefaultKeys.ArmButton)
        let armButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: armButton, timeinterval: TimeInfo.getStamp())
        //print(armButtonTriigerEvent.EventID)
        mission.ButtonTriggerEventList.append(armButtonTriigerEvent)
        arm()
    }
    
    @IBAction func trigger(_ sender: AnyObject) { //links our trigger button and tells it to run the trigger function when presed
        audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        let triggerButton = Button(id: UserDefaultKeys.TriggerButton)
        let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
        //print(triggerButtonTriigerEvent.EventID)
        mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
        trigger()
    }
    
    @IBAction func reset(_ sender: Any) {
        //judge wether is in mission
        if(true) {
            //pop up alert "you haven't finished your task"
            //choose yes
            
        }else {
            //if in timer version without goal
            //save mission
           
            
            
        }
        
        //
        reset()
    }
    
    func missionStart() {
        runTimer()
        missionInProcess = true
        mission.StartTime = TimeInfo.getStamp()
    }
    
    func missionFinshed(){
        stopTimer()
        missionInProcess = false
        //make sure user exactly did some press
        if(mission.ButtonTriggerEventList.count != 0) {
            mission.FinalTime = TimeInfo.getStamp()
            mission.FinalAchievement = realCount
           
            if(DBAdapter.insertNormalCounterMission(mission: mission)) {
                print("Succeed to save statistic data")
                DBAdapter.refreshlogPatientData()
            }else {
                print("Failed to save statistic data")
            }
            
        }else {
            print("No data need to be stored")
        }
        updateMission()
    }
    
    @IBAction func backPreviousPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToGoalCounterSettingPage" {
            let goalCounterSettingPage = segue.destination as! GoalCounterSettingPage
            goalCounterSettingPage.tellGoalCounterPageUpdate = self
        }
    }
}

extension GoalCounterPage:TellGoalCounterPageUpdate   {
    func updateMission() {
        stopTimer()
        missionInProcess = false
        realCount = 0
        let _id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: _id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        progressBar.setProgress(0, animated: false)
        
        goalLabel.text = String(displayCount)
        timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        
        firstArm = true
        //timer = Timer()
        hasGoal = false
        hasTimer = false
        
        if(mission.AimGoal > 0 && mission.AimTime > 0) {
            hasGoal = true
            hasTimer = true
            print("Count down version with goal")
        }else if(mission.AimTime > 0) {
            hasTimer = true
            print("Count Down version(without arm goal)")
        }else if(mission.AimGoal > 0) {
            hasGoal = true
            print("Timer version with goal")
        }else {
            print("Timer version(without any goal)")
        }
    }
}

extension GoalCounterPage:SendMessageToGoalCounterPage {
    func userChanged() {
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        //set mission
        updateMission()
    }
    
    
}

extension GoalCounterPage:CBPeripheralManagerDelegate {
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let rawValue = BLEAdapter.characteristicASCIIValue as String
            if(BLEAdapter.checkValue(value: rawValue)) {
                if(rawValue.split(separator: ":")[0] == BLEAdapter.ARM_ID && rawValue.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY) {
                    self.audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
                    let armButton = Button(id: UserDefaultKeys.ArmButton)
                    let armButtonTriigerEvent = ButtonTriggerEvent(missionID: self.mission.MissionID, patientID: DBAdapter.logPatient.ID, button: armButton, timeinterval: TimeInfo.getStamp())
                    //print(armButtonTriigerEvent.EventID)
                    self.mission.ButtonTriggerEventList.append(armButtonTriigerEvent)
                    self.arm()
                }
                else if(rawValue.split(separator: ":")[0] == BLEAdapter.TRIGGER_ID && rawValue.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY) {
                    self.audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
                    let triggerButton = Button(id: UserDefaultKeys.TriggerButton)
                    let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: self.mission.MissionID, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
                    //print(triggerButtonTriigerEvent.EventID)
                    self.mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
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