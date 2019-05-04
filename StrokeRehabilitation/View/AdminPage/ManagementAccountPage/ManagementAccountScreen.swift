//
//  ManagementAccountScreen.swift
//  StrokeRehabilitation
//
//  Created by yinzixie on 29/4/19.
//  Copyright © 2019 Project. All rights reserved.
//

import UIKit


class ManagementAccountScreen: UIViewController,TellAccountTableAddAccount {
    

    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static var rowsCount = 0
    }
    
    var cellHeights: [CGFloat] = []
    
    @IBOutlet var accountTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Init ManageAccount page")
        DBConectionAndDataController.tellAccountTableAddAccount = self
        Const.rowsCount = DBConectionAndDataController.patientList.count
        setUpTableApperance()
    }
    
    func addAccount() {
        Const.rowsCount = DBConectionAndDataController.patientList.count
        setUpTableApperance()
        accountTable.reloadData()
    }
    
    @IBAction func backToAdminPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       /* if segue.identifier == "fromAdminGoToCreateNewAccountScreenSegue" {
            let createNewAccountPage = segue.destination as! CreateNewAccountController
            
        }*/
        
        
    }
    

}

extension ManagementAccountScreen: UITableViewDelegate,UITableViewDataSource {
    
    private func setUpTableApperance() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        accountTable.estimatedRowHeight = Const.closeCellHeight
        accountTable.rowHeight = UITableView.automaticDimension
        //accountTable.backgroundColor = UIColor.lightGray//(patternImage: #imageLiteral(resourceName: "background"))
      /*  if #available(iOS 10.0, *) {
           accountTable.refreshControl = UIRefreshControl()
            accountTable.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }*/
    }
    
   /* @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.accountTable.refreshControl?.endRefreshing()
            }
            self?.accountTable.reloadData()
        })
    }*/
    
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return DBConectionAndDataController.patientList.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as AccountCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCellForAccount", for: indexPath) as! AccountCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        // Configure the cell...
        if let AccountCell = cell as? AccountCell
        {
            AccountCell.patient = DBConectionAndDataController.patientList[indexPath.row]
            AccountCell.parentView = self
            AccountCell.sortNumberLabel.text = String(indexPath.row + 1)
            AccountCell.setAccountCell(patient: DBConectionAndDataController.patientList[indexPath.row])
            //add button event and tag
            AccountCell.deleteButton.tag = indexPath.row
            AccountCell.deleteButton.addTarget(self, action: #selector(deletePatient), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func deletePatient(_ sender: UIButton) {
        //delete Patient and relevant tables in database
        let alert = UIAlertController(title: "Warning", message: "This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: {
            action in
            let indexPathForSelfTable = IndexPath(row: sender.tag, section: 0)
            
            if(DBConectionAndDataController.deletePatient(patient: DBConectionAndDataController.patientList[sender.tag])) {
                self.accountTable.beginUpdates()
                self.accountTable.deleteRows(at: [indexPathForSelfTable], with: .fade)
                self.accountTable.endUpdates()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
    
}

