//
//  CreateNewAccountController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class CreateNewAccountController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
     var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var givenNameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var genderPicker: UIPickerView!
    
    //gender piker data source
    var genderData = ["Man","Woman","neutral"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pop up number pad for age text field
        ageTextField.keyboardType = .numberPad
        
        //dataSource
        genderPicker.dataSource = self
        //delegate
        genderPicker.delegate = self
        //backgroud colour
        //uiPickerView.backgroundColor = UIColor.green
        
    }
    
    //colume
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[Int(row)]
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
    
    //click button cretate new account
    @IBAction func createAccountButton(_ sender: Any) {

        let genderValue = genderData[genderPicker.selectedRow(inComponent: 0)]
        let id = idTextField.text
        let age = ageTextField.text
        let firstname = firstNameTextField.text
        let givenname = givenNameTextField.text
        
        guard (id != "") else{
            parameterAlert(message: "Please input id!")
            return
        }
        guard (firstname != "") else{
            parameterAlert(message: "Please input first name!")
            return
        }
        guard (givenname != "") else{
            parameterAlert(message: "Please input given name!")
            return
        }
        guard (age != "" ) else{
            self.parameterAlert(message: "Please input age!")
            return
        }
        
        //determin if age is a interger
        let scan: Scanner = Scanner(string: age ?? "0")
        var val:Int = 0
        guard (scan.scanInt(&val) && scan.isAtEnd) else{
            self.parameterAlert(message: "Please input integer for age!")
            return
        }
       
        let patient:Patient = Patient(id:id!,firstname:firstname!,givenname:givenname!,sex:genderValue,age:Int(age ?? "0")!)
        
        
        guard database.insertPatient(patient:patient) else {
            parameterAlert(message: "Create Failed!Usually caused by repeated id")
            return
        }
        
        
        //jump to admin page through segue"createAccountSegue"
        //self.performSegue(withIdentifier:"createAccountSegue", sender: self)
    
        //pop up a succees message 
        let message = UIAlertController(
            title:"Message",
            message:"Succeed create account",
            preferredStyle:UIAlertController.Style.alert
        )
        message.addAction(UIAlertAction(
            title:"OK",
            style:UIAlertAction.Style.cancel,
            handler:nil
        ))
        self.present(message, animated: true, completion: nil)
        
        //reset
        idTextField.text = ""
        ageTextField.text = ""
        firstNameTextField.text = ""
        givenNameTextField.text = ""
        
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
