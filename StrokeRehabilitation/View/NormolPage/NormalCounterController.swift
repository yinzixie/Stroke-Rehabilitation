//
//  NormalCounterController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 6/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class NormalCounterController: UIViewController,TellNormalCounterScreenUpdate {
   
    @IBOutlet weak var countDisplay: UILabel!
    @IBOutlet var displayTimerLabel: UILabel!
    @IBOutlet var displayGoalLabel: UILabel!
    
    var count:Int = 0
    var armed:Bool = false
    var timer = Timer()
    var timerTime = Float(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DBConectionAndDataController.tellNormalCounterScreenUpdate = self
        setGoalData()
    }
    
    func updateData() {
        setGoalData()
    }
    
    private func setGoalData() {
        displayGoalLabel.text = TimerTime.returnDisplayGoalString(goal: DBConectionAndDataController.logPatient!.NormalCounterGoal)
        displayTimerLabel.text = TimerTime.returnDisplayTimerString(seconds: DBConectionAndDataController.logPatient!.NormalCounterLimitTime)
        timerTime = DBConectionAndDataController.logPatient!.NormalCounterLimitTime
    }
    
    
    func arm() -> Void
    {
        if armed == false
        {
            armed = true
        }
    }
    func counter() -> Void
    {
        if armed == true
        {
            if count >= 0
            {
                count += 1
                countDisplay.text = String(count)
                armed = false
            }
        }
        
        if(count == 1) {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(startCounter), userInfo: nil, repeats: true)
        }
        
    }
    @IBAction func Arm(_ sender: Any) {
        arm()
    }
    @IBAction func Increment(_ sender: Any) {
        counter()
    }
    
     @objc func startCounter() {
        timerTime -= 0.01
        displayTimerLabel.text = String(TimerTime.convertSecondsToTimeString(seconds: timerTime,showDeci: true))
     
        if(timerTime < 0) {
            timer.invalidate()
            displayTimerLabel.text = "00:00:00.00"
        }
     }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromNormalCounterGoToSetGoalSegue" {
            let setGoalPage = segue.destination as! SetGoalForNormalCounterScreen
            setGoalPage.patient = DBConectionAndDataController.logPatient
            
        }
        
        
        
    }
    

}
