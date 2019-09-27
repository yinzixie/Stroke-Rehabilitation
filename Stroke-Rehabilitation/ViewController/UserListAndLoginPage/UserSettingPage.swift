//
//  UserSettingPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 26/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class UserSettingPage: UIViewController {

    @IBOutlet weak var deleteProtectionSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let isProtection = defaults.bool(forKey:UserDefaultKeys.DeleteProtection)
        deleteProtectionSwitch.setOn(isProtection, animated: true)
    }
    
    @IBAction func switchTrigger(_ sender: Any) {
        if(deleteProtectionSwitch.isOn) {
            print("Trun on Delete Protection")
        }else {
            print("Trun off Delete Protection ")
        }
        //set
        let defaults = UserDefaults.standard
        defaults.setValue(deleteProtectionSwitch.isOn, forKey: UserDefaultKeys.DeleteProtection)
    }
    
    
    @IBAction func exportData(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
            
        let alert = SCLAlertView(appearance: appearance).showWait("Transform", subTitle: "Processing...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)

        let missionListFileName = DBAdapter.logPatient.ID + "_Mission_List.csv"
        let buttonTriggerEventFileName = DBAdapter.logPatient.ID + "_Button_Events.csv"
       
        guard let missionPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(missionListFileName) else { return  }
        guard let buttonPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(buttonTriggerEventFileName) else { return  }
        
        var csvMissionText = "MissionID,StartFrom,FinishAt,AimGoal,AimTime,Achievement,FinishTime\n"
        var csvButtonText = "MissionID,EventID,ButtonID,TriggerTime\n"
        
        alert.setSubTitle("Progress: 10%")
        
        for mission in DBAdapter.logPatient.HistoryNormalCounterMissionList {
            let newLine = "\(mission.MissionID),\(mission.StartTime),\(mission.FinalTime),\(mission.AimGoal),\(mission.AimTime),\(mission.FinalAchievement),\(mission.FinalTime - mission.StartTime)\n"
            csvMissionText.append(newLine)
            
            for event in mission.ButtonTriggerEventList {
                let newL = "\(event.MissionID),\(event.EventID),\(event.Button),\(event.TriggerTime)\n"
                csvButtonText.append(newL)
            }
        }
        
        alert.setSubTitle("Progress: 90%")
        
        do {
            try csvMissionText.write(to: missionPath, atomically: true, encoding: String.Encoding.utf8)
            try csvButtonText.write(to: buttonPath, atomically: true, encoding: String.Encoding.utf8)
            
            alert.setSubTitle("Progress: 100%")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.close()
            }
           
            let vc = UIActivityViewController(activityItems: [missionPath,buttonPath], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
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
