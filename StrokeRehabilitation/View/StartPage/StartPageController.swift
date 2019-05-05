//
//  StartPageController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class StartPageController: UIViewController {
    
    @IBOutlet var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DBConectionAndDataController()
       
    }
    
    //pop up alert if parameter was right
    func parameterAlert(message:String){
        let alert = UIAlertController(
            title:"Warnning",
            message:message,
            preferredStyle:UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(
            title:"OK",
            style:UIAlertAction.Style.cancel,
            handler:nil
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///remove PatientTableController in navigation controller
 /*   public func removeController() {
        if let tmpControllers = navigationController?.viewControllers {
            var controllers = tmpControllers
            
            for (i, controller) in (controllers.enumerated()).reversed() {
                if controller.isKind(of: StartPageController.classForCoder()) {
                    controllers.remove(at: i)
                    navigationController?.viewControllers = controllers
                }
            }
        }
    }*/
    
   /* @IBAction func goToAdminPage(_ sender: Any) {
        //jump through fromHomeGoToAdminPageSegue
        self.performSegue(withIdentifier:"fromHomeGoToAdminPageSegue", sender: self)
    }*/
    
    @IBAction func LoginButton(_ sender: Any) {
        let id = idTextField.text
        
        
        if(DBConectionAndDataController.selectPatientByID(id:id!) == nil) {
            parameterAlert(message:"Wrong ID!")
        }else {
            //removeController() //may be put this at bottom later
            
            //jump to segue"loginSegue"
            self.performSegue(withIdentifier:"loginSegue", sender: self)
           // removeController()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loginSegue" {
           //let normalCounterPage = segue.destination as! NormalCounterController
            //normalCounterPage.patient = DBConectionAndDataController.logPatient
        }
    }
    

}
