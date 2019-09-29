//
//  NormalCounterPage.swift
//  Stroke-Rehabilitation
//
//  Created by Reuben Chaffer on 3/5/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class NormalCounterPage: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var topView: SpringView!
    @IBOutlet weak var cardViewInTopView: UIView!
    
    @IBOutlet weak var bleButton: UIButton!
    
    @IBOutlet weak var centreView: SpringView!
    @IBOutlet weak var cardViewInCentreView: UIView!
    
    @IBOutlet weak var orderCountDown: CountdownLabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var hintLoginNameLabel: UILabel!
    @IBOutlet weak var armButton: SpringButton!
    @IBOutlet weak var triggerButton: SpringButton!
    @IBOutlet weak var endTaskButton: SpringButton!
    
    var mission:NormalCounterMission!
    var missionInProcess = false
    
    var timer = Timer()
    
    var firstPress = true

    var colors = [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor]
    var whiteColors = [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor]
    //渐变层
    var gradientLayer:CAGradientLayer!
    var timeNumber = 0
    
    var count:Int = 0 //value to be displayed on the counter
    var armed:Bool = false //used for checking if the counter has been armed
    var audioPlayer = AudioEffectController()
    
    var peripheralManager: CBPeripheralManager?
    
    var noCloseButtonWithAnimationApperance = SCLAlertView.SCLAppearance()
    var noCloseButtonApperance = SCLAlertView.SCLAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super_init()
        // Do any additional setup after loading the view.
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
        //set mission
        updateMission()
        //
        AppDelegate.normalCounterPage = self
        
        cardViewInTopView.cardView(radius: CGFloat(5))
        cardViewInCentreView.cardView(radius: CGFloat(5))
        //set label text
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        //set button style
        armButton.isHighlighted = false
        armButton.addTarget(self, action: #selector(pressArmButton), for: .touchDown)
        //set trigger event go to create journal screen when realse button
        armButton.addTarget(self, action: #selector(releaseArmButton), for: .touchUpInside)
        
        triggerButton.isHighlighted = false
        triggerButton.addTarget(self, action: #selector(pressTriggerButton), for: .touchDown)
        //set trigger event go to create journal screen when realse button
        triggerButton.addTarget(self, action: #selector(releaseTriggerButton), for: .touchUpInside)
        
        ////////////////
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
        ////////////////

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
        
        
        
        if(DBAdapter.logPatient?.ID == UserDefaultKeys.VisitorID){
            print("Entering as a vistor...")
        }else {
            print("Entering as patient with ID: " + DBAdapter.logPatient!.ID)
        }
    }
    
    func super_init() {
        _ = DBAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hintLoginNameLabel.text = DBAdapter.logPatient.Name
        enterPageAnimation()
    }
    
    override func viewDidLayoutSubviews() {
         gradientLayer.frame = self.view.frame
    }
    
    @IBAction func bluetoothSettings(_ sender: Any) {
        AppDelegate.BLEPage!.modalPresentationStyle = .popover
        AppDelegate.BLEPage!.popoverPresentationController?.delegate = self
        AppDelegate.BLEPage!.popoverPresentationController?.sourceView = bleButton
        AppDelegate.BLEPage!.popoverPresentationController?.sourceRect = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: UIScreen.main.bounds.size
        )
        self.present(AppDelegate.BLEPage!, animated: true, completion: nil)
        //leavePageAnimation(function:self.present(AppDelegate.BLEPage!, animated: true, completion: nil))
    }
    
    func setTimer() {
        // 0 is the start time to increase
        orderCountDown.timeFormat = "hh:mm:ss"
        orderCountDown.animationType = .Evaporate
        orderCountDown.text = "00:00:00"
        
        // set a time interval to repeat every second and add time to it
        // it will automatically animate
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.addTime), userInfo: nil, repeats: true)
    }
    
    @objc func pressArmButton() {
        if(firstPress) {
            firstPress = false
            missionStart()
        }
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
    
    @objc func addTime(){
        timeNumber += 1
        let time: TimeInterval = TimeInterval(timeNumber)
        orderCountDown.setCountDownTime(minutes: time)
    }
    
    /*
     The arm function is used to arm the counter, making it ready to trigger.
     */
    func arm() -> Void
    {
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
            if count >= 0
            {
                count += 1 //increase the value of count
                counterLabel.text = String(count) //change the label that displays the counter value
                armed = false //de-arms the counter so its can be armed again
                print(count)
            }
        }
        
    }
    
    @IBAction func endTask(_ sender: UIButton) {
       
        let alertView = SCLAlertView(appearance: noCloseButtonWithAnimationApperance)
        alertView.addButton("YES"){
            self.missionEnd()
        }
        alertView.addButton("NO"){
            
        }
        alertView.showNotice("Notice", subTitle: "Finish this task right now?")
        
    }
    
    @IBAction func goToUserPage(_ sender: Any) {
        leavePageAnimation(identifier:"fromNormalCounterPageGoToUserPage")
    }
    
    @IBAction func goToGoalCounterPage(_ sender: Any) {
        self.missionEnd()
        leavePageAnimation(identifier:"goToGoalCounterPage" )
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "goToGoalCounterPage") {
             //self.missionEnd()
        }
        if(segue.identifier == "goToBluetoothPage") {
            //let bluetoothPage = segue.destination as! BLEConnectionPage
        }
    }

}

extension NormalCounterPage {
    func  updateMission() {
        let _id = DBAdapter.logPatient.ID + "-" + String(TimeInfo.getStamp())
        mission = NormalCounterMission(missionID: _id, patientID: DBAdapter.logPatient.ID)
        mission.AimGoal = 0
        mission.AimTime = 0
    }
    
    func missionStart() {
        setTimer()
        missionInProcess = true
        mission.StartTime = TimeInfo.getStamp()
    }
    
    func missionEnd() {
        timer.invalidate()
        timeNumber = 0
        missionInProcess = false
    
        //make sure user exactly did some press
        if(count != 0) {
            mission.FinalTime = TimeInfo.getStamp()
            mission.FinalAchievement = count
            
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
        
        firstPress = true
        armed = false
        
        orderCountDown.text = "00:00:00"
        count = 0
        counterLabel.text = String(count)
    }
}

extension NormalCounterPage {
    func enterPageAnimation() {
        topView.animation = "slideDown"
        topView.animateFrom = true
        
        centreView.animation = "slideDown"
        centreView.animateFrom = true
        
        triggerButton.animation = "slideLeft"
        triggerButton.animateFrom = true
        
        armButton.animation = "slideRight"
        armButton.animateFrom = true
        
        endTaskButton.animation = "slideUp"
        endTaskButton.animateFrom = true
        
        endTaskButton.animate()
        armButton.animate()
        triggerButton.animate()
        topView.animate()
        centreView.animateNext {
            UIView.animate(withDuration: 1, delay: 0,
                           options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                           animations: {
                            self.cardViewInTopView.alpha = 0
                            self.cardViewInCentreView.alpha = 0
            }, completion: nil)
        }
    }
    
    func leavePageAnimation(identifier:String) {
        topView.animation = "slideDown"
        topView.animateFrom = false
        
        centreView.animation = "fadeInDown"
        centreView.animateFrom = false
        
        triggerButton.animation = "slideLeft"
        triggerButton.animateFrom = false
        
        armButton.animation = "slideRight"
        armButton.animateFrom = false
        
        endTaskButton.animation = "slideUp"
        endTaskButton.animateFrom = false
        
        UIView.animate(withDuration: 0.4, delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
                        self.cardViewInTopView.alpha = 1
                        self.cardViewInCentreView.alpha = 1
        }, completion: { (finished: Bool) in
            self.endTaskButton.animateTo()
            self.triggerButton.animateTo()
            self.armButton.animateTo()
            self.topView.animateTo()
            self.centreView.animateToNext(completion: {
                self.performSegue(withIdentifier: identifier, sender: self)
            })
        }
        )
    }
}

extension NormalCounterPage:CAAnimationDelegate{
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

extension NormalCounterPage:CBPeripheralManagerDelegate {
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

extension NormalCounterPage:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
