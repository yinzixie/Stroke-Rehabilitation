//
//  GoalCounterPage.swift
//  Stroke-Rehabilitation
//
//  Created by Edward Boreham on 7/5/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class GoalCounterPage: UIViewController{
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var hintLoginNameLabel: UILabel!
    
    var mission:NormalCounterMission!
    var audioPlayer = AudioEffectController()
    
    var countdown = TimeInterval(0) //time of timer
    var count:Int = 0//value to be displayed on the counter
    
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
        
        //register DBAdapter
        DBAdapter.delegateForGoalCounterPage = self
        
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        
        //get preset mission
        let mission_id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: mission_id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        count = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        progressBar.setProgress(0, animated: false)
        
        goalLabel.text = String(count)
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
            
            if countdown == 0
            {
                stopTimer()
                missionFinshed()
                
                let alert = UIAlertController(title: "Time's Up!", message: "Your timer has ended. Tap finish to exist goal page or Reset to start again.", preferredStyle: .alert)
                
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
            runTimer()
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
            if count > 0
            {
                count -= 1 //decrease the value of count
                goalLabel.text = String(count) //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                progressBar.setProgress(Float(mission.AimGoal - count)/Float(mission.AimGoal), animated: true)
               
                print(count)
            }
            else //if the counter is zero or below, keep decrementing but remove the negative sign so it looks like its counting up
            {
                count -= 1 //decrease the value of count
                var stringCount = String(count)
                stringCount.remove(at: stringCount.startIndex)
                goalLabel.text = stringCount //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                print(count)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error:", message: "You need to hit the arm button before you can trigger the counter.", preferredStyle: .alert)//an alert to warn users that they have hit the trigger button without arming the counter.
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil)) //an optional continue button
            self.present(alert, animated: true, completion: nil)
            
            // tells the timer to wait 3 seconds, before dismissing the alert.
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // code that is excecuted after a short delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        if mission.AimGoal > 0 && count == 0
        {
            stopTimer()
            missionFinshed()
            
            let alert = UIAlertController(title: "Congratulations!", message: "You have completed your target reps.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: {(alert: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            })) //back to normal counter page
            alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(alert: UIAlertAction!) in self.reset()}))
            self.present(alert, animated: true)//presents the alert
        }
    }
    
    func reset() -> Void //resets the goal and timer values to their starting values and refreshes the labels
    {
        stopTimer()
        firstArm = true
        
        count = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        goalLabel.text = String(count)
        timerLabel.text = TimerFormattor.formatter.string(from: countdown)
    }
    
    @IBAction func arm(_ sender: AnyObject) { //links our arm button and tells it to run the arm function when pressed
        audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        let armButton = Button(id: UserDefaultKeys.ArmButton)
        let armButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: armButton, timeinterval: TimeInfo.getStamp())
        print(armButtonTriigerEvent.EventID)
        mission.ButtonTriggerEventList.append(armButtonTriigerEvent)
        arm()
    }
    
    @IBAction func trigger(_ sender: AnyObject) { //links our trigger button and tells it to run the trigger function when presed
        audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        let triggerButton = Button(id: UserDefaultKeys.TriggerButton)
        let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
        print(triggerButtonTriigerEvent.EventID)
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
    
    func missionFinshed(){
        mission.FinalAchievement = mission.AimGoal - count
        if(hasTimer) {
            mission.FinalTime = mission.AimTime - Int(countdown)
        }else {
            mission.FinalTime = mission.AimTime + Int(countdown)
        }
        
        if(DBAdapter.insertNormalCounterMission(mission: mission)) {
             print("Succeed to save statistic data")
        }else {
            print("Failed to save statistic data")
        }
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
        
        let _id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: _id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        count = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        progressBar.setProgress(0, animated: false)
        
        goalLabel.text = String(count)
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
