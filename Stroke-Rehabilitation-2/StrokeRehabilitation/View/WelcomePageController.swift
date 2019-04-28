//
//  WelcomePageControllerViewController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 6/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class WelcomePageController: UIViewController {

    @IBOutlet var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchTimer(timeInterval: 1, repeatCount: 2) { (timer, count) in
           self.countLabel.text = String(count)
            if(count == 0) {
                //jump to admin page through segue"gotoHomepageSegue"
                self.performSegue(withIdentifier:"gotoHomepageSegue", sender: self)
                self.removeController()
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    ///remove PatientTableController in navigation controller
    public func removeController() {
        if let tmpControllers = navigationController?.viewControllers {
            var controllers = tmpControllers
            
            for (i, controller) in (controllers.enumerated()).reversed() {
                if controller.isKind(of: WelcomePageController.classForCoder()) {
                    controllers.remove(at: i)
                    navigationController?.viewControllers = controllers
                }
            }
        }
    }
    
    /// GCD定时器倒计时⏳
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    // ---------------------
    //作者：zxw_1141189194
    //来源：CSDN
    //原文：https://blog.csdn.net/zxw_xzr/article/details/78317936
    public func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
    {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
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
