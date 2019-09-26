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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
