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
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var givenNameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var levelDescriptionTextField: UITextField!
    
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
    
   
    //click button cretate new account
    @IBAction func createAccountButton(_ sender: Any) {

        let genderValue = genderData[genderPicker.selectedRow(inComponent: 0)]
        let id = idTextField.text
        let age = ageTextField.text
        let firstname = firstNameTextField.text
        let givenname = givenNameTextField.text
        let levelDescription = levelDescriptionTextField.text
        
        guard (id != "") else{
            Alert.warningAlert(message: "Please input id!", view: self)
            return
        }
        guard (firstname != "") else{
             Alert.warningAlert(message: "Please input first name!", view: self)
            return
        }
        guard (givenname != "") else{
             Alert.warningAlert(message: "Please input given name!", view: self)
            return
        }
        guard (age != "" ) else{
            Alert.warningAlert(message: "Please input age!", view: self)
            return
        }
        
        //determin if age is a interger
        let scan: Scanner = Scanner(string: age ?? "0")
        var val:Int = 0
        guard (scan.scanInt(&val) && scan.isAtEnd) else{
             Alert.warningAlert(message: "Please input integer for age!", view: self)
            return
        }
       
        let patient:Patient = Patient(id:id!)
        patient.setPatientDetails(firstname:firstname!,givenname:givenname!,sex:genderValue,age:Int(age ?? "0")!,levelDescription: levelDescription)
       
        guard DBConectionAndDataController.addPatient(patient:patient) else {
            Alert.warningAlert(message: "Create Failed! Usually caused by repeated id", view: self)
            return
        }
       
        self.dismiss(animated: true, completion: nil)
        //jump to admin page through segue"createAccountSegue"
        //self.performSegue(withIdentifier:"createAccountSegue", sender: self)
    
       // Alert.messageAlert(message: "Succeed!", view: self)
        //resetAllInput()
    }
    
    func resetAllInput(){
        //reset
        idTextField.text = ""
        ageTextField.text = ""
        firstNameTextField.text = ""
        givenNameTextField.text = ""
        levelDescriptionTextField.text = ""
    }
    
    @IBAction func backToAdminPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
