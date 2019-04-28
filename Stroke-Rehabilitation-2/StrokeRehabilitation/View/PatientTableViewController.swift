//
//  PatientTableViewController.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 5/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit

class PatientTableViewController: UITableViewController {
    var patients = [Patient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
      
        patients = database.selectAllPatients()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return patients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientTableCellView", for: indexPath)
        // Configure the cell...
        let patient = patients[indexPath.row]
        // Configure the cell...
        if let patientCell = cell as? PatientTableCellView
        {
            patientCell.idLabel.text = patient.ID
            patientCell.firstnameLabel.text = patient.Firstname
            patientCell.givennameLabel.text = patient.Givenname
            patientCell.ageLabel.text = String(patient.Age)
            patientCell.genderLabel.text = patient.Gender
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoPatientDetailSegue"
        {
            guard let detailViewController = segue.destination as? PatientDetailController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMovieCell = sender as? PatientTableCellView else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedpatient = patients[indexPath.row]
            detailViewController.patient = selectedpatient
        }
    }

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

}
