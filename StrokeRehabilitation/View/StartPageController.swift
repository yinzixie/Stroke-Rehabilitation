//
//  StartPageController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class StartPageController: UIViewController {
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    @IBOutlet var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
