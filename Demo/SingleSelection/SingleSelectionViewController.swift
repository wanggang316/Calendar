//
//  SingleSelectionViewController.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class SingleSelectionViewController: UIViewController {
    
    var selectedDate: Date?
    
    var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 1
        cal.minimumInteritemSpacing = 1
        cal.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        cal.minimumWeekAndDateItemSpacing = 10
        cal.weekViewHeight = 30
        cal.monthFooterViewHeight = 20
        cal.cellAspectRatio = 100.0 / 140.0
        
        cal.register(SingleSelectionDayCell.self)
        cal.register(monthHeader: SingleSelectionMonthHeaderView.self)
//        cal.register(monthFooter: SimpleMonthFooterView.self)
        return cal
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        //        let calendar = Date.gregorianCalendar
        //        let date = Date()
        //        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        //        components.year = 2016
        //        components.month = 9
        //        components.day = 14
        //        let fromDate = calendar.date(from: components)!
        //        self.calendarView.fromDate = fromDate
        //
        //        components.year = 2017
        //        components.month = 4
        //        components.day = 1
        //        let toDate = calendar.date(from: components)!
        //        self.calendarView.toDate = toDate
        
        self.calendarView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.view.addSubview(self.calendarView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SingleSelectionViewController: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {
        
        cell.style = .custom
        
        if let cell = cell as? SingleSelectionDayCell {
            if let date = date {
                if let selectedDate = self.selectedDate, date.eq(selectedDate, granularity: .day) {
                    cell.state = .selected
                } else {
                    cell.state = .normal
                }
            } else {
                cell.state = .empty
            }
        }
    }
    
    func calendarView(_ calendarView: CalendarView, weekdayView: UILabel, forWeekday weekday: Int) {
        weekdayView.font = UIFont.systemFont(ofSize: 13)
        if weekday == 0 || weekday == 6 {
            weekdayView.textColor = UIColor.lightGray
        }
    }
}

extension SingleSelectionViewController: CalendarDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {
        
        self.selectedDate = date
        calendarView.reloadData()
        
    }
}
