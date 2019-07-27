//
//  UserListAndLoginPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 23/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class UserListAndLoginPage: UIViewController {

    @IBOutlet weak var loginAsButton: UIButton!
    @IBOutlet weak var userListTable: UITableView!
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var hintLoginAsLabel: UILabel!
    
    var reLoginUser:Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //regist DBAdaper delegate
        DBAdapter.tellUserListTableAddAccount = self
        //remove seperation from cell which doesn't contain data
        userListTable.tableFooterView = UIView.init(frame: CGRect.zero)
        userListTable.layer.borderWidth = 0.5
        userListTable.layer.borderColor = UIColor.lightGray.cgColor
        //set label text
        helloLabel.text = "Hello " + DBAdapter.logPatient.Name
        hintLoginAsLabel.text = "You are now login as " + DBAdapter.logPatient.ID
    }
    
    @IBAction func loginAs(_ sender: Any) {
        DBAdapter.refreshlogPatient(patient:reLoginUser!)
        //set label text
        helloLabel.text = "Hello " + DBAdapter.logPatient.Name
        hintLoginAsLabel.text = "You are now login as " + DBAdapter.logPatient.ID
        //reload userlist
        userListTable.beginUpdates()
        userListTable.reloadData()
        userListTable.endUpdates()
        print("Login as " + DBAdapter.logPatient.ID)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backPreviousPage(_ sender: Any) {
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

extension UserListAndLoginPage:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DBAdapter.patientList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == DBAdapter.patientList.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewUserCell", for: indexPath) as! AddNewUserCell
            cell.addNewUserButton.addTarget(self, action: #selector(addNewUser), for: .touchUpInside)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
            
            // Configure the cell...
            if let UserCell = cell as? UserListCell
            {
                UserCell.tellLoginPageSelectUser = self
                UserCell.IDLabel.text = DBAdapter.patientList[indexPath.row].ID
                UserCell.nameLabel.text = DBAdapter.patientList[indexPath.row].Name
                if(DBAdapter.patientList[indexPath.row].ID != UserDefaultKeys.VisitorID) {
                    UserCell.hintLabel.text = "<<< swipe to delete"
                }
                if(DBAdapter.patientList[indexPath.row].ID != DBAdapter.logPatient.ID) {
                     UserCell.selectedHintImage.image = UIImage(named:"yellow-arrow")
                }else {
                     UserCell.selectedHintImage.image = UIImage(named:"green-arrow")
                }
                
                
            }
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == 0 || indexPath.row == DBAdapter.patientList.count) {
            return false
        }
        return true
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        //let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])//,edit])
    }
    
    
    func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style:.normal, title: "Delete") {(action, view, completion) in
            
            //弹出确认窗口
            let alert = UIAlertController(title: "Warning", message: "This action cannot be reversed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: {
                action in
                //do something
                if(DBAdapter.deletePatient(patient: DBAdapter.patientList[indexPath.row])) {
                    self.userListTable.deleteRows(at: [indexPath], with: .automatic)
                    print("Succeed delete user")
                }else {
                    //pop up message if failed to add new user
                    let failedAlert = UIAlertController(title: "Delete user", message: "Failed to delete user", preferredStyle: .alert)
                    failedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                        //
                    }))
                    self.present(failedAlert, animated: true, completion: nil)
                    print("Failed to delete user")
                }
                completion(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        action.image = UIImage(named:"delete@250*250")?.resizeImage(60, opaque: false)
        action.backgroundColor = .red
        return action
    }
    
    @objc func addNewUser(_ sender:UIButton) {
        print("Strat create a new user")
        //1. Create the alert controller.
        let addNewUserAlert = UIAlertController(title: "Add new user", message: "Type user's ID and Name(must be unique)", preferredStyle: .alert)
        
        //2. Add the text field.
        addNewUserAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "ID:can't be empty!"})
        addNewUserAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Name:can't be empty!"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        addNewUserAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak addNewUserAlert] (action) -> Void in
            //let textField = addNewMoodAlert?.textFields![0] as! UITextField
            //print("Text field: \(textField.text)")
            
            let newUserID = addNewUserAlert?.textFields![0].text!
            let newUserName = addNewUserAlert?.textFields![1].text!
            
            if(newUserID != "" && newUserName != "") {
                //check weather the id is repeated. if no, continue
                if (DBAdapter.isUserIDExist(id: newUserID!)) {
                    //pop up alert
                    let repeatedAlert = UIAlertController(title: "Warrning", message: "This ID is already existed", preferredStyle: .alert)
                    repeatedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        //print("Repeated name")
                    }))
                    self.present(repeatedAlert, animated: true, completion: nil)
                }else {
                    let newPatient = Patient()
                    newPatient.ID = newUserID!
                    newPatient.Name = newUserName!
                    if(DBAdapter.addPatient(patient: newPatient)) {
                        print("Succeed add new user")
                    }else {
                        //pop up message if failed to add new user
                        let failedAlert = UIAlertController(title: "Add new user", message: "Failed to add new user", preferredStyle: .alert)
                        failedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                            //
                        }))
                        self.present(failedAlert, animated: true, completion: nil)
                        print("Failed add new user")
                    }
                }
            }else {
                let notificationAlert = UIAlertController(title: "Add new user", message: "Please fill the blank", preferredStyle: .alert)
                notificationAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                    //
                }))
                self.present(notificationAlert, animated: true, completion: nil)
                print("User didn't fill the information correctly")
            }
        }))
        
        //cancel button
        addNewUserAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("User canceled add a new user")
        }))
        
        // 4. Present the alert.
        self.present(addNewUserAlert, animated: true, completion: nil)
    }
    
    
}

extension UserListAndLoginPage:TellUserListTableAddAccount {
    func addAccount() {
        let indexPath = IndexPath(row:DBAdapter.patientList.count-1,section: 0)
        
        //refresh table
        userListTable.beginUpdates()
        userListTable.insertRows(at: [indexPath], with: .fade)
        //userListTable.reloadData()
        userListTable.endUpdates()
    }
}

extension UserListAndLoginPage:TellLoginPageSelectUser {
    func selectUser(id: String) {
        reLoginUser = DBAdapter.selectPatientByID(id: id)
        loginAsButton.setTitle("ReLogin as " + id, for: .normal)
    }
    
    
    
}
