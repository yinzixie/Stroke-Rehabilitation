//
//  StatisticDetailsPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 26/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class StatisticDetailsPage: UIViewController {
    var displayMissionList:[NormalCounterMission]!
    
    @IBOutlet weak var cardView: SpringView!
    
    @IBOutlet weak var calendarCardView: SpringView!
    @IBOutlet weak var calendarMonththView: UIView!
    @IBOutlet weak var calendarYearView: UIView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var cardViews = [UIView]()
        
        var index = 0
        for mission in displayMissionList {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.cardView(radius: CGFloat(10))
            
            let startTime = mission.StartTime
            let startFromString = "Start from: " + TimeInfo.timeStampToHHMMSS(String(startTime))
            
            let finishedTime = mission.FinalTime
            let finishedAtString = "Finished at: " + TimeInfo.timeStampToHHMMSS(String(finishedTime))
            
            let aimGoalString = "Set Goal: " + String(mission.AimGoal)
            let aimTimeString = "Set Time: " + TimeInfo.secTransToHourMinSec(time: Float(mission.AimTime))
            let finalAchievementString = "Final Reps Completed: " + String(mission.FinalAchievement)
            let finalTimeString = "Final Time: " + TimeInfo.secTransToHourMinSec(time: Float(mission.FinalTime - mission.StartTime))
            
            //let _time = mission.FinalTime - mission.StartTime
            //let _achievement = mission.FinalAchievement
            //let _result = Float(_time)/Float(_achievement)
            //let averageString = "Average: " +  String(format: "%.2f", _result) + "s/press"
            
            let mainLabel = UILabel(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
            mainLabel.text = "#\(index)"
            mainLabel.textColor = UIColor.gray
            mainLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(mainLabel)
            
            let progressView = UICircularProgressRing(frame: CGRect(x: 170, y: 20, width:100,height:100))
            progressView.innerRingWidth = 10
            progressView.innerRingSpacing = -20
            
            if(mission.FinalAchievement >= mission.AimGoal) {
                progressView.innerRingColor = UIColor.green
                progressView.value = 100
            }else {
                progressView.innerRingColor = UIColor.orange
                let pro_v = Float(mission.FinalAchievement)/Float(mission.AimGoal)
                progressView.value = CGFloat(pro_v*100)
            }
            view.addSubview(progressView)
            
            let StartFromLabel = UILabel(frame: CGRect(x: 60, y: 150, width: getLabelWidth(str:startFromString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 20))
            StartFromLabel.textColor = UIColor.black
            StartFromLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(StartFromLabel)
            
            let finishAtLabel = UILabel(frame: CGRect(x: 60, y: 190, width: getLabelWidth(str:finishedAtString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 30))
            finishAtLabel.textColor = UIColor.black
            finishAtLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(finishAtLabel)
            
            let aimGoalLabel = UILabel(frame: CGRect(x: 60, y: 250, width: getLabelWidth(str:aimGoalString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 30))
            aimGoalLabel.textColor = UIColor.black
            aimGoalLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(aimGoalLabel)
            
            let aimTimeLabel = UILabel(frame: CGRect(x: 60, y: 290, width: getLabelWidth(str:aimTimeString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 30))
            aimTimeLabel.textColor = UIColor.black
            aimTimeLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(aimTimeLabel)
            
            let finalAchievementLabel = UILabel(frame: CGRect(x: 60, y: 350, width: getLabelWidth(str:finalAchievementString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 30))
            finalAchievementLabel.textColor = UIColor.black
            finalAchievementLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(finalAchievementLabel)
            
            let finalTimeLabel = UILabel(frame: CGRect(x: 60, y: 390, width: getLabelWidth(str:finalTimeString,font:UIFont.systemFont(ofSize: 24.0),height: 30), height: 30))
            finalTimeLabel.textColor = UIColor.black
            finalTimeLabel.font = UIFont.systemFont(ofSize: 24.0)
            view.addSubview(finalTimeLabel)
            
            StartFromLabel.text = startFromString
            finishAtLabel.text = finishedAtString
            aimGoalLabel.text = aimGoalString
            aimTimeLabel.text = aimTimeString
            finalAchievementLabel.text = finalAchievementString
            finalTimeLabel.text = finalTimeString
            //averageLabel.text = averageString
            
            cardViews.append(view)
            index += 1
        }
       
        cardViews.reverse()
        
        let cardStackView = CardStackView(cards: cardViews, showsPagination: true, maxAngle: 10, randomAngle: true, throwDuration: 0.4)
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(cardStackView)
        let views = ["cardStackView": cardStackView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-80-[cardStackView]-80-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[cardStackView]-100-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        setCalendarCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        calendarCardView.animate()
        cardView.animate()
       
    }
    
    private func setCalendarCard() {
        calendarCardView.cardView(radius: CGFloat(10))
        calendarMonththView.SetMutiBorderRoundingCorners(corner: CGFloat(10), topRight: true, topLeft: true, bottomRight: false, bottomLeft: false)
        calendarYearView.SetMutiBorderRoundingCorners(corner: CGFloat(20), topRight: false, topLeft: false, bottomRight: true, bottomLeft: true)
        calendarYearView.SetBorder(true, left: false, bottom: false, right: false, width: 0.5, color: UIColor.lightGray)
        
        let showDate = Date(timeIntervalSince1970: TimeInterval(displayMissionList[0].StartTime))
        monthLabel.text = TimeInfo.MonthsString[showDate.month_()-1]
        dayLabel.text = String(showDate.day_())
        yearLabel.text = String(showDate.year_())
        weekdayLabel.text = TimeInfo.WeekDaysString[showDate.weekDay()-1]
    }
    
    @IBAction func closePage(_ sender: Any) {
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

extension StatisticDetailsPage{
    func getLabelWidth(str: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = str as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
  
    /// 动态计算Label高度
    func getLabelHegit(str: String, font: UIFont, width: CGFloat)-> CGFloat {
        let statusLabelText: NSString = str as NSString
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
        return strSize.height
    }
}
