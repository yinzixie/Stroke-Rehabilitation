//
//  StatisticPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 25/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class StatisticPage: UIViewController {
    @IBOutlet weak var calendarPageView: UIView!
    @IBOutlet weak var calendarMonththView: UIView!
    @IBOutlet weak var calendarYearView: UIView!

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var missionListTable: UITableView!
    @IBOutlet weak var aimGoalLabel: UILabel!
    @IBOutlet weak var aimTimeLabel: UILabel!
    @IBOutlet weak var finalAchievementLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var displayMissionList:[NormalCounterMission]!
    var displayMission:NormalCounterMission!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendarCard()
        missionListTable.backgroundColor = UIColor.clear
        //missionListTable.backgroundView?.backgroundColor = UIColor.clear
        //remove seperation from cell which doesn't contain data
        missionListTable.tableFooterView = UIView.init(frame: CGRect.zero)
        //missionListTable.layer.borderWidth = 0.5
      //  missionListTable.layer.borderColor = UIColor.lightGray.cgColor
        //titleLabel.text = DBAdapter.logPatient.Name + "'s Session History"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setCalendarCard() {
        calendarPageView.cardView(radius: CGFloat(10))
        calendarMonththView.SetMutiBorderRoundingCorners(corner: CGFloat(10), topRight: true, topLeft: true, bottomRight: false, bottomLeft: false)
        calendarYearView.SetMutiBorderRoundingCorners(corner: CGFloat(20), topRight: false, topLeft: false, bottomRight: true, bottomLeft: true)
       calendarYearView.SetBorder(true, left: false, bottom: false, right: false, width: 0.5, color: UIColor.lightGray)
        
        let showDate = Date(timeIntervalSince1970: TimeInterval(displayMissionList[0].StartTime))
        monthLabel.text = TimeInfo.MonthsString[showDate.month_()-1]
        dayLabel.text = String(showDate.day_())
        yearLabel.text = String(showDate.year_())
        weekdayLabel.text = TimeInfo.WeekDaysString[showDate.weekDay()-1]
    }
    
    private func setDetailsInformation() {
        let aimGoalString = "Set Goal: " + String(displayMission.AimGoal)
        let aimTimeString = "Set Time: " + TimeInfo.secTransToHourMinSec(time: Float(displayMission!.AimTime))
        let finalAchievementString = "Final Reps Completed: " + String(displayMission.FinalAchievement)
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
        return displayMissionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MissionListCell", for: indexPath) as! MissionListCell
            // Configure the cell...
            cell.backgroundColor = UIColor.clear
            cell.delegateForStatisticPage = self
            cell.mission = displayMissionList[indexPath.row]
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
