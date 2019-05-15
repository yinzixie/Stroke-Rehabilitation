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
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchTimer(timeInterval: 3, repeatCount: 2) { (timer, count) in
           self.countLabel.text = String("count")
          //self.view=UIView(named: "0.png")
            //使用img来实现动画
         let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1200, height: 800) )
            imageView.image = UIImage(named: "1.jpg")
            // 设置 ImageView 背景颜色
            imageView.backgroundColor = UIColor.black
            
            // 设置 ImageView 动画效果
            var imageArr: Array<UIImage?> = []
            //for i in 0 ... 2{
                let image: UIImage? = UIImage(named: "Slide1.JPG")
                imageArr.append(image)
            
                 let image2: UIImage? = UIImage(named: "Slide2.JPG")
                 imageArr.append(image2)
            
            let image3: UIImage? = UIImage(named: "Slide3.JPG")
            imageArr.append(image3)
            
            let image4: UIImage? = UIImage(named: "Slide4.JPG")
            imageArr.append(image4)
            
            let image5: UIImage? = UIImage(named: "Slide5.JPG")
            imageArr.append(image5)
            
            
          
            // 设置 ImageView 动画数组
            imageView.animationImages = imageArr as? [UIImage]
            // 设置 ImageView 播放次数
            imageView.animationRepeatCount = 1
            // 设置播放一轮的时间
            imageView.animationDuration = 1.5
            // 开始播放动画
            imageView.startAnimating()
            
            self.view.addSubview(imageView)
            
            
            
            
            
            ////////////////
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
