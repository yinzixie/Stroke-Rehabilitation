//
//  GoalCounterSettingPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 21/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

protocol TellGoalCounterPageUpdate {
    func updateMission()
}

class GoalCounterSettingPage: UIViewController {

    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var hideGoalAreaSwitch: UISwitch!
    @IBOutlet weak var hideTimerAreaSwitch: UISwitch!
    
    @IBOutlet weak var goalSettingStackView: UIStackView!
    
    @IBOutlet weak var goalSettingArea: UIView!
    @IBOutlet weak var timerSettingArea: UIView!
    
    var tellGoalCounterPageUpdate:TellGoalCounterPageUpdate?
    var goal = 0// Sets the goal label as an integer
 
    var timeMins = TimeInterval(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //get preset data
        goal = DBAdapter.logPatient!.NormalCounterGoal
        timeMins = TimeInterval(DBAdapter.logPatient!.NormalCounterLimitTime)
        goalLabel.text = String(goal)
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
        
        //if goal/time equals 0 means no goal/time limitation and hide the corresponding area
        if(goal == 0) {
            hideGoalAreaSwitch.setOn(false, animated: false)
            goalSettingArea.isHidden = true
        }
        if(timeMins == TimeInterval(0)) {
            hideTimerAreaSwitch.setOn(false, animated: false)
            timerSettingArea.isHidden = true
        }
    }
    
    @IBAction func hideGoalArea(_ sender: Any) {
        goalSettingArea.isHidden = !(hideGoalAreaSwitch.isOn)
        if(!(hideGoalAreaSwitch.isOn)) {
            goal = 0
        }
    }
    @IBAction func hideTimeArea(_ sender: Any) {
        timerSettingArea.isHidden = !(hideTimerAreaSwitch.isOn)
        if(!(hideTimerAreaSwitch.isOn)) {
            timeMins = TimeInterval(0)
        }
    }
    
    /////////////////////////////////////////////
    //////////////////////////////////////////////
    //for goal
    
    @IBAction func negateFive(_ sender: Any) {
        if goal > 0
        {
            goal = goal - 5
            if goal < 0
            {
                goal = 0
            }
            goalLabel.text = String(goal)
        }
        
    }
    @IBAction func negateTen(_ sender: Any) {
        if goal > 0
        {
            goal = goal - 10
            if goal < 0
            {
                goal = 0
            }
            goalLabel.text = String(goal)
        }
    }
    @IBAction func negateFifteen(_ sender: Any) {
        if goal > 0
        {
            goal = goal - 15
            if goal < 0
            {
                goal = 0
            }
            goalLabel.text = String(goal)
        }
    }
    @IBAction func negateTwenty(_ sender: Any) {
        if goal > 0
        {
            goal = goal - 20
            if goal < 0
            {
                goal = 0
            }
            goalLabel.text = String(goal)
        }
    }
    @IBAction func goalReset(_ sender: Any) {
        goal = 0
        goalLabel.text = String(goal)
    }
    @IBAction func incrementFive(_ sender: Any) {
        goal = goal + 5
        goalLabel.text = String(goal)
    }
    @IBAction func incrementTen(_ sender: Any) {
        goal = goal + 10
        goalLabel.text = String(goal)
    }
    @IBAction func incrementFifteen(_ sender: Any) {
        goal = goal + 15
        goalLabel.text = String(goal)
    }
    @IBAction func incrementTwenty(_ sender: Any) {
        goal = goal + 20
        goalLabel.text = String(goal)
        print(goal)
    }

    //////////////////////////////////////////////
    //////////////////////////////////////////////
    //for time
    
    @IBAction func resetTimer(_ sender: Any) {
        timeMins = 0.0
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    @IBAction func plusTenSecs(_ sender: Any) {
        timeMins += 10
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    @IBAction func plusOneMins(_ sender: Any) {
        timeMins = timeMins + 60
        
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    @IBAction func plusTenMins(_ sender: Any) {
        timeMins = timeMins + 600
        
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
        
    }
    @IBAction func minusTenSecs(_ sender: Any) {
        timeMins -= 10
        if timeMins < 0
        {
            timeMins = 0
        }
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    @IBAction func minusOneMins(_ sender: Any) {
        timeMins = timeMins - 60
        if timeMins < 0
        {
            timeMins = 0
        }
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    @IBAction func minusTenMins(_ sender: Any) {
        timeMins = timeMins - 600
        if timeMins < 0
        {
            timeMins = 0
        }
        timerLabel.text = TimerFormattor.formatter.string(from: timeMins)
    }
    /////////////////////////////////////////////
    //////////////////////////////////////////////
    

    @IBAction func finishSetGoal(_ sender: Any) {
        DBAdapter.logPatient.setPatientPresetGoal(normalGoal:goal, normalTime:Int(timeMins))
        DBAdapter.updatePatientNormalCounterPresetGoal(patient: DBAdapter.logPatient)
        tellGoalCounterPageUpdate?.updateMission()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
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
