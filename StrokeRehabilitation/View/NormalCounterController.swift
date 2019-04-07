//
//  NormalCounterController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 6/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class NormalCounterController: UIViewController {
    @IBOutlet weak var countDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    var count:Int = 0
    var armed:Bool = false
    func arm() -> Void
    {
        if armed == false
        {
            armed = true
        }
    }
    func counter() -> Void
    {
        if armed == true
        {
            if count >= 0
            {
                count += 1
                countDisplay.text = String(count)
                armed = false
            }
        }
    }
    @IBAction func Arm(_ sender: Any) {
        arm()
    }
    @IBAction func Increment(_ sender: Any) {
        counter()
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
