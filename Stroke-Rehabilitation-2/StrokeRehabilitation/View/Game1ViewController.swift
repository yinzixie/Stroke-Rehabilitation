//
//  Game1ViewController.swift
//  StrokeRehabilitation
//
//  Created by Xiaoran Du on 2019/4/28.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit
import AudioToolbox
class Game1ViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var countDisplay: UILabel!
    
    @IBOutlet weak var textf: UITextField!
    
    @IBOutlet weak var numtextf: UITextField!
    var currentstr : NSString = ""
    var currentnum = 20;
    override func viewDidLoad() {
        super.viewDidLoad()

         setkeybord()
        // Do any additional setup after loading the view.
    }
    
    var count:Int = 0
    var armed:Bool = false

    @IBAction func arm(_ sender: Any) {
        
        if armed == false
        {
            armed = true
        }

    }
    @IBAction func counter(_ sender: Any) {
        if armed == true
        {
            if count >= 0
            {
                count -= 1
                countDisplay.text = String(count)
                armed = false
            }
        }
    }
    
    
    func sub() -> Void
    {
        
        if count >= 0
        {
            count -= 1
            countDisplay.text = String(count)
        }
        
    }

    @objc func textFieldTextChange(textfs:UITextField){
        print(textf.text ?? "")
       
        if textfs == self.textf {
            
            let nostr : NSString = textfs.text!  as NSString
            if nostr.length > currentstr.length {
                print("increase")
                let str = nostr.replacingOccurrences(of: currentstr as String, with: "")
                print(str)
                
                if  isPurnInt(string: str) {
                    print("keyboard")
                     playAction()
                     sub()
                    
                }
                
            }
            currentstr = textfs.text!  as NSString
        }else{
            let numstr:NSString = textfs.text! as NSString
            count = numstr.integerValue
            countDisplay.text = String(count)
            if count > 0 {
                numtextf.resignFirstResponder()
                textf.becomeFirstResponder()
            }
        }
       
        
    }
    
    
    func isPurnInt(string: String) -> Bool {
        
        let numstr:NSString = string as NSString
        let num = numstr.integerValue
        if  currentnum == 1 && num == 2{
            return true
        }else{
            currentnum = num
           return false
        }
        
        
        
        
//        let scan: Scanner = Scanner(string: string)
//
//        var val:Int = 0
//
//        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numtextf.resignFirstResponder()
        textf.becomeFirstResponder()
        return true
    }
    
    
    func playAction(){
        var systemSoundID:SystemSoundID = 0;
        
        let path = Bundle.main.path(forResource: "11442", ofType: "wav")
        AudioServicesCreateSystemSoundID(NSURL.fileURL(withPath: path!) as CFURL, &systemSoundID)
        AudioServicesPlayAlertSound(SystemSoundID(systemSoundID))
        
    }
    func setkeybord(){
        textf.delegate = self
        textf.returnKeyType = UIReturnKeyType.done
        textf.addTarget(self, action: #selector(textFieldTextChange(textfs:)), for:  UIControl.Event.editingChanged)
        numtextf.addTarget(self, action: #selector(textFieldTextChange(textfs:)), for:  UIControl.Event.editingChanged)
        
        numtextf.delegate = self
        numtextf.returnKeyType = UIReturnKeyType.done
        
        textf.isHidden = true
//        textf.becomeFirstResponder()
//        textf.resignFirstResponder()
    }
    override func becomeFirstResponder() -> Bool {
        
        super.becomeFirstResponder()
        return textf.becomeFirstResponder()
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
