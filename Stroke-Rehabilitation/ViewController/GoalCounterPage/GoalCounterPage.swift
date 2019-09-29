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
    var darkMode = true
    
    @IBOutlet weak var centreView: SpringView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var goalLabel: UILabel!

    @IBOutlet weak var timerLabel: CountdownLabel!
    
    @IBOutlet weak var progressCircular: UICircularProgressRing!
    
    @IBOutlet weak var hintLoginNameLabel: UILabel!
    @IBOutlet weak var armButton: SpringButton!
    @IBOutlet weak var triggerButton: SpringButton!
    
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
    
    var noCloseButtonWithAnimationApperance = SCLAlertView.SCLAppearance()
    var noCloseButtonApperance = SCLAlertView.SCLAppearance()
    
    var colors = [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor]
    var whiteColors = [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor]
    //渐变层
    var gradientLayer:CAGradientLayer!
    var timeNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set button
        armButton.isHighlighted = false
        armButton.addTarget(self, action: #selector(pressArmButton), for: .touchDown)
        armButton.addTarget(self, action: #selector(releaseArmButton), for: .touchUpInside)
        
        triggerButton.isHighlighted = false
        triggerButton.addTarget(self, action: #selector(pressTriggerButton), for: .touchDown)
        triggerButton.addTarget(self, action: #selector(releaseTriggerButton), for: .touchUpInside)
        
        //..........//
        cardView.cardView(radius: CGFloat(5))
        //..........//
        noCloseButtonWithAnimationApperance = SCLAlertView.SCLAppearance(
            kWindowWidth: self.view.frame.width*0.6,
            kButtonHeight: 50,
            kTitleFont: UIFont(name: "HelveticaNeue", size: 40)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 34)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 34)!,
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
        
        noCloseButtonApperance = SCLAlertView.SCLAppearance(
            kWindowWidth: self.view.frame.width*0.6,
            kButtonHeight: 50,
            kTitleFont: UIFont(name: "HelveticaNeue", size: 40)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 34)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 34)!,
            showCloseButton: false
        )
        
        ////创建CAGradientLayer对象
        gradientLayer = CAGradientLayer()
        //设置初始渐变色
        gradientLayer.colors = whiteColors
        //每种颜色所在的位置
        gradientLayer.locations = [0.0,0.3,0.6]
        //设置渲染的起始结束位置（横向渐变）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Do any additional setup after loading the view.
        
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        
        //get preset mission
        let mission_id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: mission_id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        goalLabel.text = String(displayCount)
        
        timerLabel.timeFormat = "hh:mm:ss"
        timerLabel.animationType = .Evaporate
        timerLabel.setCountDownTime(minutes: TimeInterval(countdown))
        //timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        
        if(mission.AimGoal > 0 && mission.AimTime > 0) {
            hasGoal = true
            hasTimer = true
            print("Count Down version with goal")
        }else if(mission.AimTime > 0) {
            hasTimer = true
            print("Count Down version without Reps goal")
        }else if(mission.AimGoal > 0) {
            hasGoal = true
            print("Timer version with goal")
        }else {
            print("Timer version without Reps goal")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        //set mission
        updateMission()
        
        //animation
        centreView.animation = "squeezeDown"
        centreView.animateFrom = true
        
        triggerButton.animation = "squeezeLeft"
        triggerButton.animateFrom = true
        
        armButton.animation = "squeezeRight"
        armButton.animateFrom = true
        
        armButton.animate()
        triggerButton.animate()
        
        centreView.animateNext {
            UIView.animate(withDuration: 1, delay: 0,
                           options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                           animations: {
                            self.cardView.alpha = 0
            }, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = self.view.frame
    }
    
    func runTimer() //runs the specified function (updateTimer) once every timeInterval (1 second)
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GoalCounterPage.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // reset timer
    func resetTimer() {
        timer.invalidate() //destroy timer
        timer = Timer()
    }
    
    @objc func updateTimer()//decrements the timer every second and refreshes the label
    {
        if(hasTimer) {
            countdown -= 1
            if(countdown <= 0) {
                timerLabel.text = "00:00:00"
            }else {
                 timerLabel.setCountDownTime(minutes: TimeInterval(countdown))
            }
            //timerLabel.text = TimerFormattor.formatter.string(from: countdown)
            
            //time is up before user finish all task
            if countdown == 0
            {
                missionFinshed()
                let alertView = SCLAlertView(appearance: noCloseButtonWithAnimationApperance)
                let timer_temp = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 5, timeoutAction: {})
                alertView.showNotice("Time Out", subTitle: "Task finished, well done, why not try it again?",timeout:timer_temp)
            }
        }else {
            countdown += 1
            //timerLabel.text = TimerFormattor.formatter.string(from: countdown)
            timerLabel.setCountDownTime(minutes: TimeInterval(countdown))
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
                progressCircular.startProgress(to: CGFloat(Float(mission.AimGoal - displayCount)*100/Float(mission.AimGoal)), duration: 1)
                
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
                
                let alertView = SCLAlertView(appearance: noCloseButtonApperance)
                let timer_temp = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 5, timeoutAction: {})
                alertView.showSuccess("Congratulations", subTitle: "You have completed your target reps", timeout: timer_temp)
            }
        }
    }
   
    @objc func pressArmButton() {
        self.audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        self.arm()
        
        changeBackgroundColor(isFromLeft:true)
        
        let armButton = Button(id: UserDefaultKeys.ArmButton)
        let armButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: armButton, timeinterval: TimeInfo.getStamp())
        mission.ButtonTriggerEventList.append(armButtonTriigerEvent)
    }
    
    @objc func releaseArmButton() {
        removeBackgroundColor()
    }
    
    @objc func pressTriggerButton() {
        self.audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        self.trigger()
        changeBackgroundColor(isFromLeft:false)
        
        let triggerButton = Button(id: UserDefaultKeys.TriggerButton)
        let triggerButtonTriigerEvent = ButtonTriggerEvent(missionID: mission.MissionID, patientID: DBAdapter.logPatient.ID, button: triggerButton, timeinterval: TimeInfo.getStamp())
        mission.ButtonTriggerEventList.append(triggerButtonTriigerEvent)
    }
    
    @objc func releaseTriggerButton() {
        removeBackgroundColor()
    }
    
    @IBAction func endMissionButtonTrigger(_ sender: Any) {
        //judge wether is in mission
        if(missionInProcess) {
            //pop up alert
            let alertView = SCLAlertView(appearance: noCloseButtonWithAnimationApperance)
            alertView.addButton("YES"){
                self.missionFinshed()
            }
            alertView.addButton("NO"){
            
            }
            alertView.showNotice("Notice", subTitle: "Finish this task right now?")
        }else {
            self.missionFinshed()
        }
    }
   
    func missionStart() {
        runTimer()
        missionInProcess = true
        mission.StartTime = TimeInfo.getStamp()
        userButton.isEnabled = false
        backButton.isEnabled = false
    }
    
    func missionFinshed(){
        resetTimer()
        missionInProcess = false
        firstArm = true
        armed = false
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        goalLabel.text = String(displayCount)
        //timerLabel.setCountDownTime(minutes: TimeInterval(countdown))
        //timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        userButton.isEnabled = true
        backButton.isEnabled = true
        
        //make sure user exactly did some press
        if(realCount > 0) {
            mission.FinalTime = TimeInfo.getStamp()
            mission.FinalAchievement = realCount
           
            if(DBAdapter.insertNormalCounterMission(mission: mission)) {
                DBAdapter.refreshlogPatientData()
                print("Succeed to save statistic data")
                
                let alertView = SCLAlertView(appearance: noCloseButtonApperance)
                let timer_temp = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 2, timeoutAction: {})
                alertView.showSuccess("Congratulations", subTitle: "Succeed save data", timeout: timer_temp)
              
            }else {
                print("Failed to save statistic data")
            
                let alertView = SCLAlertView(appearance: noCloseButtonApperance)
                let timer_temp = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 2, timeoutAction: {})
                alertView.showError("Error", subTitle: "Unknow error.Failed saving data", timeout: timer_temp)
            }
        }else {
            print("No data need to be stored")
        }
        updateMission()
    }
    
    @IBAction func backPreviousPage(_ sender: Any) {
        centreView.animation = "fadeInDown"
        centreView.animateFrom = false
        
        triggerButton.animation = "squeezeLeft"
        triggerButton.animateFrom = false
        
        armButton.animation = "squeezeRight"
        armButton.animateFrom = false
        
        UIView.animate(withDuration: 1, delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.cardView.alpha = 1
        }, completion: { (finished: Bool) in
            self.triggerButton.animateTo()
            self.armButton.animateTo()
            self.centreView.animateToNext(completion: {
                self.dismiss(animated: false, completion: nil)
            })
        }
        )
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
        resetTimer()
        missionInProcess = false
        realCount = 0
        let _id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: _id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = DBAdapter.logPatient.NormalCounterGoal
        mission.AimTime = DBAdapter.logPatient.NormalCounterLimitTime
        
        displayCount = mission.AimGoal
        countdown = TimeInterval(mission.AimTime)
        
        progressCircular.resetProgress()
        
        goalLabel.text = String(displayCount)
        //timerLabel.text = TimerFormattor.formatter.string(from: countdown)
        timerLabel.setCountDownTime(minutes: TimeInterval(countdown))
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

extension GoalCounterPage:CBPeripheralManagerDelegate {
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let rawValue = BLEAdapter.characteristicASCIIValue as String
            if(BLEAdapter.checkValue(value: rawValue)) {
                if(rawValue.split(separator: ":")[0] == BLEAdapter.ARM_ID) {
                    if(rawValue.split(separator: ":")[1] == BLEAdapter.PRESS_KEY) {
                        self.armButton.sendActions(for: UIControl.Event.touchDown)
                    }else {
                        self.armButton.sendActions(for: UIControl.Event.touchUpInside)
                    }
                }else if(rawValue.split(separator: ":")[0] == BLEAdapter.TRIGGER_ID) {
                    if(rawValue.split(separator: ":")[1] == BLEAdapter.PRESS_KEY) {
                        self.triggerButton.sendActions(for: UIControl.Event.touchDown)
                    }else {
                        self.triggerButton.sendActions(for: UIControl.Event.touchUpInside)
                    }
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

extension GoalCounterPage:CAAnimationDelegate{
    func changeBackgroundColor(isFromLeft:Bool){
        if(isFromLeft) {
            //设置渲染的起始结束位置（横向渐变）
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }else {
            self.gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
        //下一组渐变色索引
        let firstColorIndex = Int(arc4random() % (8))
        var secondColorIndex = Int(arc4random() % (8))
        while(secondColorIndex == firstColorIndex) {
            secondColorIndex = Int(arc4random() % (8))
        }
        colors = [ColorEffectController.gradientColors[firstColorIndex],ColorEffectController.gradientColors[secondColorIndex],UIColor.white.cgColor]
        //添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 1.0
        colorChangeAnimation.fromValue = whiteColors
        colorChangeAnimation.toValue = colors
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        //动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    
    func removeBackgroundColor() {
        //添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.fromValue = colors
        colorChangeAnimation.toValue = whiteColors
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        //动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    
}

extension GoalCounterPage {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
    
    @objc func minimizeView(_ sender: AnyObject) {
        SpringAnimation.spring(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.935, y: 0.935)
        })
       setNeedsStatusBarAppearanceUpdate() //setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    }
    
    @objc func maximizeView(_ sender: AnyObject) {
        SpringAnimation.spring(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        setNeedsStatusBarAppearanceUpdate()
        //UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
}
