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

    @IBOutlet weak var totalRepsLabel: UILabel!
    @IBOutlet weak var totalExerciseTimeLabel: UILabel!
    @IBOutlet weak var averageRepsLabel: UILabel!
    
    
    var reLoginUser:Patient?
    var noCloseButtonApperance = SCLAlertView.SCLAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //..........//
        noCloseButtonApperance = SCLAlertView.SCLAppearance(
            kWindowWidth: self.view.frame.width*0.6,
            kButtonHeight: 50,
            kTitleFont: UIFont(name: "HelveticaNeue", size: 40)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 34)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 34)!,
            showCloseButton: false
        )
        
        //regist DBAdaper delegate
        DBAdapter.tellUserListTableAddAccount = self
        //remove seperation from cell which doesn't contain data
        userListTable.tableFooterView = UIView.init(frame: CGRect.zero)
        userListTable.layer.borderWidth = 0.5
        userListTable.layer.borderColor = UIColor.lightGray.cgColor
        //set label text
        helloLabel.text = "Hello " + DBAdapter.logPatient.Name
        setMilestone()
    }
    
    func setMilestone() {
        var totalReps = 0
        var totalTime = 0
        var activityDay = 0
        var day_last = ""
        
        for mission in DBAdapter.logPatient.HistoryNormalCounterMissionList {
            let day = TimeInfo.timeStampToString(String(mission.StartTime))
            if (day != day_last) {
                activityDay += 1
            }
            totalReps += mission.FinalAchievement
            totalTime += mission.FinalTime - mission.StartTime
            day_last = day
        }
        totalRepsLabel.text = String(totalReps)
        totalExerciseTimeLabel.text = String(format:"%0.2f",Float(totalTime)/Float(3600))
        if(activityDay > 0) {
             averageRepsLabel.text = String(totalReps/activityDay)
        }else {
              averageRepsLabel.text = "0"
        }
    }
    
    func login(patient:Patient) {
        DBAdapter.refreshlogPatient(patient:patient)
        //set label text
        helloLabel.text = "Hello " + DBAdapter.logPatient.Name
        setMilestone()
        //reload userlist
        userListTable.beginUpdates()
        userListTable.reloadData()
        userListTable.endUpdates()
        print("Login as " + DBAdapter.logPatient.ID)
    }
    
    @IBAction func loginAs(_ sender: Any) {
        login(patient:reLoginUser!)
    }
    
    @IBAction func backPreviousPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if segue.identifier == "popOverStatisticOverViewPage"
        {
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 200, height: 300)
            
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
               
                controller?.delegate = self as? UIPopoverPresentationControllerDelegate
                //you could set the following in your storyboard
                controller?.sourceView = self.view
                controller?.sourceRect = CGRect(x:self.view.bounds.midX, y: self.view.bounds.midY,width: 315,height: 230)
                controller?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }*/
    }
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
            let defaults = UserDefaults.standard
            let isProtection = defaults.bool(forKey:UserDefaultKeys.DeleteProtection)
            
            if(isProtection) {
                //pop up operation denied message
                _ = SCLAlertView().showWarning("Operation Denied", subTitle: "Your account is under protection, turn off Delete Protection if you want delete user")
            }else {
                //判断是否为当前登陆账号
                if(DBAdapter.patientList[indexPath.row].ID == DBAdapter.logPatient.ID) {
                    //pop up operation denied message
                   _ = SCLAlertView().showWarning("Operation Denied", subTitle: "Please Log out to delete this account")
                }else {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Proceed"){
                        //delete user
                        if(DBAdapter.deletePatient(patient: DBAdapter.patientList[indexPath.row])) {
                            self.userListTable.deleteRows(at: [indexPath], with: .automatic)
                            print("Succeed delete user")
                            self.reLoginUser = DBAdapter.patientList[indexPath.row-1]
                            self.loginAsButton.setTitle("Login as " + self.reLoginUser!.Name + " (" + self.reLoginUser!.ID + ")", for: .normal)
                             _ = SCLAlertView().showSuccess("Congraduation", subTitle: "Succeed delete user")
                        }else {
                            //pop up message if failed to delete new user
                            print("Failed to delete user")
                            _ = SCLAlertView().showError("ERROR", subTitle:"You have met an error which really confusing the system, please try again", closeButtonTitle:"OK")
                        }
                    }
                    alertView.addButton("Cancle"){
                        
                    }
                    alertView.showWarning("Warning", subTitle: "This action cannot be reversed")
                }
            }
        }
        
        action.image = UIImage(named:"delete@250*250")?.resizeImage(60, opaque: false)
        action.backgroundColor = .red
        return action
    }
    
    @objc func addNewUser(_ sender:UIButton) {
        print("Start create a new user")
        
        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 40,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let nameText = alert.addTextField("Enter your name")
        let idText = alert.addTextField("Enter your id(unique)")
        
        _ = alert.addButton("Create") {
            print("Name value: \(nameText.text ?? "NA")")
            print("ID value: \(idText.text ?? "NA")")
            guard let newUserName = nameText.text else {
                _ = SCLAlertView().showWarning("Warning", subTitle: "Name and ID can't be empty")
                return
            }
            guard let newUserID = idText.text else {
                _ = SCLAlertView().showWarning("Warning", subTitle: "Name and ID can't be empty")
                return
            }
            //check name and id 是否为空
            if(newUserID != "" && newUserName != "") {
                
                //检查id是否重复
                if(DBAdapter.isUserIDExist(id: newUserID)) {
                    _ = SCLAlertView().showWarning("Warning", subTitle: "ID ")
                }else {
                    let newPatient = Patient()
                    newPatient.ID = newUserID
                    newPatient.Name = newUserName
                    if(DBAdapter.addPatient(patient: newPatient)) {
                        print("Succeed add new user")
                        
                        self.login(patient: newPatient)
                        
                        let alert = SCLAlertView()
                        _ = alert.showSuccess("Congratulations", subTitle: "Succeed add new user")
                    }else {
                        //pop up message if failed to add new user
                        print("Failed add new user")
                        _ = SCLAlertView().showError("ERROR", subTitle:"You have met an error which really confusing the system, please try again", closeButtonTitle:"OK")
                    }
                }
            }else {
                 _ = SCLAlertView().showWarning("Warning", subTitle: "Name and idd can't be empty")
            }
        }
        _ = alert.addButton("Cancle") {}
        _ = alert.showEdit("Create New User", subTitle:"Type name and ID for new user")
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
        let name = reLoginUser?.Name ?? "NULL"
        loginAsButton.setTitle("Login as " + name + " (" + id + ")", for: .normal)
    }
}
