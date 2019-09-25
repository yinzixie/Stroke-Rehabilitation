//
//  StatisticOverviewPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 22/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class StatisticOverviewPage: UIViewController{
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var showDetailsButton: UIButton!
    
    @IBOutlet weak var totalTaskLabel: UILabel!
    @IBOutlet weak var taskFailedLabel: UILabel!
    @IBOutlet weak var taskCompletedLabel: UILabel!
    @IBOutlet weak var exerciseTimeLabel: UILabel!
    @IBOutlet weak var totalPressesLabel: UILabel!
    
    @IBOutlet weak var totalTaskImage: UIImageView!
    @IBOutlet weak var taskFailedImage: UIImageView!
    @IBOutlet weak var taskCompletedImage: UIImageView!
    @IBOutlet weak var exerciseTimeImage: UIImageView!
    @IBOutlet weak var totalPressesImage: UIImageView!
    
    var normalCounterMissionListForSelectDay: [NormalCounterMission]?
    var normalCounterMissionListForLastDay: [NormalCounterMission]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        CalendarView.Style.cellShape                = .round//.bevel(8.0)
        CalendarView.Style.cellColorDefault         = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00)
        CalendarView.Style.cellColorToday           = UIColor(red:1.00, green:0.62, blue:0.27, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.62, blue:0.27, alpha:1.00)
        CalendarView.Style.cellSelectedColor        = UIColor(red:1.00, green:0.62, blue:0.27, alpha:1.00)//UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00)
        CalendarView.Style.cellSelectedTextColor    = UIColor.white
        CalendarView.Style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.gray
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.black
        CalendarView.Style.headerBackgroundColor    = UIColor.white
        
        CalendarView.Style.firstWeekday             = .sunday
        
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        
        CalendarView.Style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        CalendarView.Style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        CalendarView.Style.subHeaderFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = false
        
        calendarView.backgroundColor = UIColor.white
        
        backgroundView.cardView(radius: CGFloat(10))
        calendarView.SetMutiBorderRoundingCorners(corner: CGFloat(10), topRight: true, topLeft: true, bottomRight: false, bottomLeft: false)
        
        showDetailsButton.isEnabled = false
        showDetailsButton.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) //light gray
        showDetailsButton.setTitle("No Data", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        
        //var tomorrowComponents = DateComponents()
        //tomorrowComponents.day = 1
       
        //self.calendarView.selectDate(today) //one bug caused by delay of calendar loading
      
        if(normalCounterMissionListForSelectDay == nil) {
            self.calendarView.setDisplayDate(today)
        }
        
    }

    func setStatisticOverViewInformation(){
        if(normalCounterMissionListForSelectDay?.count != 0) {
            let totalTask = normalCounterMissionListForSelectDay!.count
            let lastTotalTask = normalCounterMissionListForLastDay!.count
            let taskCompleted = DBAdapter.numberOfCompletedMission(missionList: normalCounterMissionListForSelectDay!)
            let lastTaskCompleted = DBAdapter.numberOfCompletedMission(missionList: normalCounterMissionListForLastDay!)
            let taskFailed = totalTask - taskCompleted
            let lastTaskFailed = lastTotalTask - lastTaskCompleted
            let exerciseTime = DBAdapter.numberOfTimes(missionList: normalCounterMissionListForSelectDay!) / 60
            let lastExerciseTime = DBAdapter.numberOfTimes(missionList: normalCounterMissionListForLastDay!) / 60
            let totalReps = DBAdapter.numberOfReps(missionList: normalCounterMissionListForSelectDay!)
            let lastTotalReps = DBAdapter.numberOfReps(missionList: normalCounterMissionListForLastDay!)
            
            totalTaskLabel.text = "Total Task: " + String(totalTask)
            taskFailedLabel.text = "Task Failed: " + String(taskFailed)
            taskCompletedLabel.text = "Task Completed: " + String(taskCompleted)
            exerciseTimeLabel.text = "Exercise Time: " + String(format: "%.2f",exerciseTime) + "mins"
            totalPressesLabel.text = "Total Reps: " + String(totalReps) + " presses"
            
            if(totalTask < lastTotalTask) {
                totalTaskImage.image = UIImage(named:"green-decrease-arrow")
            }else {
                totalTaskImage.image = UIImage(named:"red-increase-arrow")
            }
            
            if(taskFailed < lastTaskFailed) {
                taskFailedImage.image = UIImage(named:"green-increase-arrow")
            }else {
                taskFailedImage.image = UIImage(named:"red-increase-arrow")
            }
            
            if(taskCompleted < lastTaskCompleted) {
                taskCompletedImage.image = UIImage(named:"green-decrease-arrow")
            }else {
                taskCompletedImage.image = UIImage(named:"red-increase-arrow")
            }
            
            if(exerciseTime < lastExerciseTime) {
                exerciseTimeImage.image = UIImage(named:"green-decrease-arrow")
            }else {
                exerciseTimeImage.image = UIImage(named:"red-increase-arrow")
            }
            
            if(totalReps < lastTotalReps) {
                totalPressesImage.image = UIImage(named:"green-decrease-arrow")
            }else {
                totalPressesImage.image = UIImage(named:"red-increase-arrow")
            }
        }else {
            totalTaskLabel.text = "Total Task: 0"
            taskFailedLabel.text = "Task Failed: 0"
            taskCompletedLabel.text = "Task Completed: 0"
            exerciseTimeLabel.text = "Exercise Time: 0"
            totalPressesLabel.text = "Total Reps: 0 presses"
            
            totalTaskImage.image = UIImage(named:"green-decrease-arrow")
            taskFailedImage.image = UIImage(named:"green-decrease-arrow")
            taskCompletedImage.image = UIImage(named:"green-decrease-arrow")
            exerciseTimeImage.image = UIImage(named:"green-decrease-arrow")
            totalPressesImage.image = UIImage(named:"green-decrease-arrow")
        }
    }
    
    // MARK : Events
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calendarView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calendarView.goToPreviousMonth()
    }
    
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calendarView.goToNextMonth()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailStatisticPage" {
            print("Going to show statistic details")
            let statiticPage = segue.destination as! StatisticPage
            statiticPage.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            statiticPage.displayMissionList = normalCounterMissionListForSelectDay
            //UIModalTransitionStyleCrossDissolve
        }
    }
}

extension StatisticOverviewPage: CalendarViewDataSource, CalendarViewDelegate{
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        let startDay = TimeInfo.dateStringToDate("2019-3-1")
        
        var dateComponents = DateComponents()
        dateComponents.month = 0
        
        let startDay2019 = self.calendarView.calendar.date(byAdding: dateComponents, to: startDay)!
        
        return startDay2019
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        
        dateComponents.month = 2
        let today = Date()
        
        let twoMonthsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoMonthsFromNow
    }
    
    // MARK : KDCalendarDelegate
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date)")
        var lastIndex = DBAdapter.logPatient.ExerciseLog.firstIndex(of: date) ?? 0
        if(lastIndex != 0) {
            lastIndex -= 1
        }
        normalCounterMissionListForSelectDay = DBAdapter.selectNormalCounterMissionForDay(day: date)
        normalCounterMissionListForLastDay = DBAdapter.selectNormalCounterMissionForDay(day: DBAdapter.logPatient.ExerciseLog[lastIndex])
        
        setStatisticOverViewInformation()
        
        if(normalCounterMissionListForSelectDay?.count == 0) {
            showDetailsButton.isEnabled = false
            showDetailsButton.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) //light gray
            showDetailsButton.setTitle("No Data", for: .normal)
        }else {
            showDetailsButton.isEnabled = true
            showDetailsButton.backgroundColor = UIColor(red:1, green:0.55, blue:0.16, alpha:1.00) //light gray
            showDetailsButton.setTitle("Show Details", for: .normal)
        }
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
        
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        normalCounterMissionListForSelectDay = []
        normalCounterMissionListForLastDay = []
        setStatisticOverViewInformation()
        
        showDetailsButton.isEnabled = false
        showDetailsButton.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00) //light gray
        showDetailsButton.setTitle("No Data", for: .normal)
    }
}
