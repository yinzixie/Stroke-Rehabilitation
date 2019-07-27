//
//  MissionListCell.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 25/7/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

protocol TellStatisticPageShowMission {
    func missionChanged(mission:NormalCounterMission)
}

class MissionListCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var startedFromLabel: UILabel!
    @IBOutlet weak var finishedAtLabel: UILabel!
    
    var delegateForStatisticPage:TellStatisticPageShowMission?
    var mission:NormalCounterMission?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setLabels() {
        let startTime = mission?.StartTime
        let startTimeString = TimeInfo.timeStampToStringDetail(String(startTime!))
        let startTimeDate:Date = TimeInfo.timeStringToDate(startTimeString)
        
        var dateString = String(startTimeDate.day_())
        if(startTimeDate.day_() < 10) {
            dateString = "0" + String(startTimeDate.day_())
        }
        let monthString = TimeInfo.MonthsString[startTimeDate.month_() - 1]
        let yearString = String(startTimeDate.year_())
        let stratedFromString = "Started from: " + TimeInfo.timeStampToHHMMSS(String(startTime!))

        let finishedTime = mission?.FinalTime
        //let finishedTimeString = TimeInfo.timeStampToStringDetail(String(finishedTime!))
        //let finishedTimeDate:Date = TimeInfo.timeStringToDate(finishedTimeString)
        let finishedAtString = "Finished at: " + TimeInfo.timeStampToHHMMSS(String(finishedTime!))

        dateLabel.text = dateString
        monthLabel.text = monthString
        yearLabel.text = yearString
        startedFromLabel.text = stratedFromString
        finishedAtLabel.text = finishedAtString
    }
        
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        delegateForStatisticPage?.missionChanged(mission: mission!)
    }

}
