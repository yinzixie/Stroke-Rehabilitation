//
//  StatisticOverviewPage.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 22/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import UIKit

class StatisticOverviewPage: UIViewController, CalendarViewDataSource, CalendarViewDelegate{
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var showDetailsButton: UIButton!
    
    var normalCounterMissionListForOneDay: [NormalCounterMission]?
    
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
        
        backgroundView.cardView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        //let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        
        self.calendarView.selectDate(today)
        self.calendarView.setDisplayDate(today)
    }
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetailStatisticPage" {
                print("Going to show statistic details")
                let statiticPage = segue.destination as! StatisticPage
                statiticPage.displayMissionList = normalCounterMissionListForOneDay
         }
    }
    
    // MARK : KDCalendarDelegate
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date)")
        normalCounterMissionListForOneDay = DBAdapter.selectNormalCounterMissionForDay(day: date)
        if(normalCounterMissionListForOneDay?.count == 0) {
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
}
