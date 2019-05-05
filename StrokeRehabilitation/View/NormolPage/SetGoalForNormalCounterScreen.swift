//
//  SetGoalForNormalCounterScreen.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 1/5/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class SetGoalForNormalCounterScreen: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
   
    var patient:Patient!
    
    var timer = Timer()
    
    var timerTime = Float(300) //seconds
    var goal = 0
    
    var hour = 0
    var minute = 0
    var second = 0
    
    
    var hourArray = [Int](0...24)
    var secondArray = [Int](0...59)
    
    
    @IBOutlet var timerPicker: UIPickerView!
    @IBOutlet var displayTimerLabel: UILabel!
    
    @IBOutlet var displayGoalLabel: UILabel!
    
    @IBOutlet var goalSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayTimerLabel.text = TimerTime.convertSecondsToTimeString(seconds: Float(patient.NormalCounterLimitTime), showDeci: false)
        
        
        if(patient.NormalCounterGoal != 0) {
            displayGoalLabel.text = String(patient.NormalCounterGoal)
            goalSlider.setValue(Float(patient.NormalCounterGoal), animated: true)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return 25
        }else if(component == 1){
            return 1
        }else if(component == 2) {
            return 60
        }else if(component == 3) {
            return 1
        }else if(component == 4) {
            return 60
        }else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return String(hourArray[row])
        }else if(component == 1) {
            return "hour"
        }else if(component == 2) {
            return String(secondArray[row])
        }else if(component == 3) {
            return "min"
        }else if(component == 4) {
            return String(secondArray[row])
        }else {
            return "sec"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(component == 0){
            hour = row
        }else if(component == 2) {
            minute = row
        }else if(component == 4) {
            second = row
        }
        timerTime = Float(hour*60*60 + minute*60 + second)
        displayTimerLabel.text = TimerTime.convertSecondsToTimeString(seconds: timerTime,showDeci: false)
        patient.NormalCounterLimitTime = timerTime
    }
    
    
    @IBAction func setTime(_ sender: UISlider) {
        goal = Int(sender.value)
        
        displayGoalLabel.text = TimerTime.returnDisplayGoalString(goal: goal)
        
        patient.NormalCounterGoal = goal
    }
    
    @IBAction func cancle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGoal(_ sender: Any) {
        DBConectionAndDataController.updatePatientNormalCounterPresetGoal(patient: patient)
      
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
