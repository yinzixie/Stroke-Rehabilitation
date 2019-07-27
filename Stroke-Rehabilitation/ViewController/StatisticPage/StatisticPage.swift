//
//  StatisticPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 25/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class StatisticPage: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var missionListTable: UITableView!
    @IBOutlet weak var aimGoalLabel: UILabel!
    @IBOutlet weak var aimTimeLabel: UILabel!
    @IBOutlet weak var finalAchievementLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    
    var displayMission:NormalCounterMission!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //remove seperation from cell which doesn't contain data
        missionListTable.tableFooterView = UIView.init(frame: CGRect.zero)
        missionListTable.layer.borderWidth = 0.5
        missionListTable.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.text = DBAdapter.logPatient.Name + "'s Missions History"
    }
    
    private func setDetailsInformation() {
        let aimGoalString = "Aim Goal: " + String(displayMission.AimGoal)
        let aimTimeString = "Am Time: " + TimeInfo.secTransToHourMinSec(time: Float(displayMission!.AimTime))
        let finalAchievementString = "Final Achievement: " + String(displayMission.FinalAchievement)
        let finalTimeString = "Final Time: " + TimeInfo.secTransToHourMinSec(time: Float(displayMission.FinalTime - displayMission.StartTime))
        
        let _time = displayMission.FinalTime - displayMission.StartTime
        let _achievement = displayMission.FinalAchievement
        let _result = Float(_time)/Float(_achievement)
        let averageString = "Average: " +  String(format: "%.2f", _result) + "s/press"
        
        aimGoalLabel.text = aimGoalString
        aimTimeLabel.text = aimTimeString
        finalAchievementLabel.text = finalAchievementString
        finalTimeLabel.text = finalTimeString
        averageLabel.text = averageString
    }

    @IBAction func back(_ sender: Any) {
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

extension StatisticPage:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBAdapter.logPatient.HistoryNormalCounterMissionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissionListCell", for: indexPath) as! MissionListCell
            // Configure the cell...
        cell.delegateForStatisticPage = self
            cell.mission = DBAdapter.logPatient.HistoryNormalCounterMissionList[indexPath.row]
            cell.setLabels()
            return cell
    }
}

extension StatisticPage:TellStatisticPageShowMission {
    func missionChanged(mission: NormalCounterMission) {
        displayMission = mission
        setDetailsInformation()
    }
}
