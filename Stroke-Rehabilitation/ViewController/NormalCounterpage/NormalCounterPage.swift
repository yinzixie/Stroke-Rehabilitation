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
    @IBOutlet weak var leftSideBackgroundView: UIView!
    @IBOutlet weak var centreView: SpringView!
    @IBOutlet weak var orderCountDown: CountdownLabel!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var hintLoginNameLabel: UILabel!
    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var triggerButton: UIButton!
    
    //共三组渐变色
    let colorsSet = [
        [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor],
        [UIColor.yellow.cgColor, UIColor.orange.cgColor,UIColor.white.cgColor],
        [UIColor.cyan.cgColor, UIColor.green.cgColor,UIColor.white.cgColor],
        [UIColor.magenta.cgColor, UIColor.blue.cgColor,UIColor.white.cgColor],
    ]
    
    //当前渐变色索引
    var currentColorIndex = 0
    
    //渐变层
    var gradientLayer:CAGradientLayer!
    
    
    var timeNumber = 0
    
    var count:Int = 0 //value to be displayed on the counter
    var armed:Bool = false //used for checking if the counter has been armed
    var audioPlayer = AudioEffectController()
    
    var peripheralManager: CBPeripheralManager?
    //var peripheral: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super_init()
        // Do any additional setup after loading the view.
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
        
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
        gradientLayer.colors = colorsSet[0]
        //每种颜色所在的位置
        gradientLayer.locations = [0.0,0.3,0.6]
        //设置渲染的起始结束位置（横向渐变）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame//self.leftSideBackgroundView.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        ////////////////
        
        
        
        if(DBAdapter.logPatient?.ID == UserDefaultKeys.VisitorID){
            print("Entering as a vistor...")
        }else {
            print("Entering as patient with ID: " + DBAdapter.logPatient!.ID)
        }
    }
    
    func super_init() {
        DBAdapter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         hintLoginNameLabel.text = DBAdapter.logPatient.Name
        //setTimer()
        centreView.animate()
    }
    
    override func viewDidLayoutSubviews() {
        //gradientLayer.frame = self.leftSideBackgroundView.frame
    }
    
    @IBAction func bluetoothSettings(_ sender: Any) {
        performSegue(withIdentifier: "bluetoothSegue", sender: self)
    }
    
    func setTimer() {
        // 0 is the start time to increase
        let time: TimeInterval = TimeInterval(0)
        
        orderCountDown.setCountDownTime(minutes: time)
        
        orderCountDown.timeFormat = "mm:ss"
        
        orderCountDown.animationType = .Evaporate
        
        // set a time interval to repeat every second and add time to it
        // it will automatically animate
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.addTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func pressArmButton() {
        self.audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        self.arm()
        changeBackgroundColor(isFromLeft:true)
    }
    
    @objc func releaseArmButton() {
        removeBackgroundColor()
    }
    
    @objc func pressTriggerButton() {
        self.audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        self.trigger()
        changeBackgroundColor(isFromLeft:false)
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
    
    
    
    func reset() -> Void
    {
        count = 0
        counterLabel.text = String(count)
    }
    
    
   /* @IBAction func armButtonPress(_ sender: UIButton) {
        //links our arm button and tells it to run the arm function when pressed
        
        audioPlayer.playSound(fileName: "First_Tone", fileType: "mp3")
        arm()
    }
    
    @IBAction func triggerButtonPress(_ sender: UIButton) {
        //links our trigger button and tells it to run the trigger function when presed
        audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
        trigger()
    }*/
    
    @IBAction func resetButtonPress(_ sender: UIButton) {
        reset()
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
        let nextIndex = Int(arc4random() % (3) + 1)
        //print(nextIndex)
       // var nextIndex = currentColorIndex + 1
       // if nextIndex >= colorsSet.count {
        //    nextIndex = 0
       // }
        //添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 1.0
        colorChangeAnimation.fromValue = colorsSet[currentColorIndex]
        colorChangeAnimation.toValue = colorsSet[nextIndex]
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        //动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
        
        //动画播放后改变当前索引值
        currentColorIndex = nextIndex
    }
    
    func removeBackgroundColor() {
        //下一组渐变色索引
        let nextIndex = 0
        
        //添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.fromValue = colorsSet[currentColorIndex]
        colorChangeAnimation.toValue = colorsSet[nextIndex]
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        //动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
        
        //动画播放后改变当前索引值
        currentColorIndex = nextIndex
    }
    
}

extension NormalCounterPage:CBPeripheralManagerDelegate {
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let rawValue = BLEAdapter.characteristicASCIIValue as String
            if(BLEAdapter.checkValue(value: rawValue)) {
                if(rawValue.split(separator: ":")[0] == BLEAdapter.ARM_ID) {
                    if(rawValue.split(separator: ":")[0] == BLEAdapter.PRESS_KEY) {
                        self.armButton.sendActions(for: UIControl.Event.touchDown)
                    }else {
                        self.armButton.sendActions(for: UIControl.Event.touchUpInside)
                    }
                }else if(rawValue.split(separator: ":")[0] == BLEAdapter.TRIGGER_ID && rawValue.split(separator: ":")[1] == BLEAdapter.RELEASE_KEY) {
                    self.audioPlayer.playSound(fileName: "Second_Tone", fileType: "mp3")
                    self.trigger()
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
