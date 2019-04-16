//
//  PatientDetailController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 6/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class PatientDetailController: UITableViewController {
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    var patient:Patient?
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var firstnameLabel: UILabel!
    @IBOutlet var givennameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let displayPatient = patient
        {
            idLabel.text = displayPatient.ID
            firstnameLabel.text = displayPatient.Firstname
            givennameLabel.text = displayPatient.Givenname
            ageLabel.text = String(displayPatient.Age)
            genderLabel.text = displayPatient.Gender
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    ///remove PatientDetailController in navigation controller
    ///移除导航控制器中指定的（单个、多个连续|不连续）控制器
    public func removePatientDetailController() {
        if let tmpControllers = navigationController?.viewControllers {
            var controllers = tmpControllers
            
            for (i, controller) in (controllers.enumerated()).reversed() {
                if controller.isKind(of: PatientDetailController.classForCoder()) {
                    controllers.remove(at: i)
                    navigationController?.viewControllers = controllers
                }
            }
        }
    }
    
    ///remove PatientTableController in navigation controller
    public func removePatientTableController() {
        if let tmpControllers = navigationController?.viewControllers {
            var controllers = tmpControllers
            
            for (i, controller) in (controllers.enumerated()).reversed() {
                if controller.isKind(of: PatientTableViewController.classForCoder()) {
                    controllers.remove(at: i)
                    navigationController?.viewControllers = controllers
                }
            }
        }
    }
   
    
    //delete account and relevant tables, then jump to previes page(delete relevant controller in navigation)
    @IBAction func deleteAccountButton(_ sender: UIButton) {
        //delete tables in database
        let alert = UIAlertController(title: "Warning", message: "This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: {
            action in
            guard self.database.deletePatient(patient: self.patient!) else {
                return
            }
            self.database.deletePatientRelevantTable(patient:self.patient!)
            //remove view controller in navigation controller
            
            
            self.removePatientTableController()
            //jump to admin page through segue"backToPatientTableSegue"
            self.performSegue(withIdentifier:"backToPatientTableSegue", sender: self)
            //after jumping out, then delete this patient detail view controller in navigation controller
            self.removePatientDetailController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
                
    }

        

    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


