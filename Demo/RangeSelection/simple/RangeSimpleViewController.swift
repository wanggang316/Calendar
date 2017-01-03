//
//  RangeSimpleViewController.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class RangeSimpleViewController: UIViewController {
    
    enum RangeSelectedState {
        case none
        case start
        case range
    }
    
    var selectionState: RangeSelectedState = .none {
        didSet {
            switch selectionState {
            case .none:
                self.startDate = nil
                self.endDate = nil
                calendarView.reloadData()
            case .start:
                calendarView.reloadData()
            case .range:
                calendarView.reloadData()
            }
        }
    }
    
    var startDate: Date?
    var endDate: Date?
    
    var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 0
        cal.minimumInteritemSpacing = 0
        cal.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        cal.weekViewHeight = 46
        cal.monthHeaderViewHeight = 67
        cal.monthFooterViewHeight = 18
        cal.cellAspectRatio = 92.0 / 102.0
        
        cal.register(RangeSimpleCell.self)
        cal.register(monthHeader: RangeSimpleMonthHeaderView.self)
        
        cal.weekView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        cal.weekView.layer.shadowOpacity = 0.5
        cal.weekView.layer.shadowRadius = 0.5
        cal.weekView.layer.shadowColor = UIColor.init(colorLiteralRed: 230.0 / 255.0, green: 230.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0).cgColor
        return cal
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.calendarView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.view.addSubview(self.calendarView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RangeSimpleViewController: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {
        
//        cell.style = .custom
        
        if let cell = cell as? RangeSimpleCell {
            
            var cellState: RangeSimpleCell.DayCellState = .empty
            
            if let date = date {
                
                cell.date = date
                
                if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) {
                    cellState = .disabled
                } else {
                    switch self.selectionState {

                    case .start:
                        let minSpaceDays = 1 /// 最小间隔天数
                        if date.lt(self.startDate!, granularity: .day) {
                            cellState = .availableDisabled
                        } else if self.startDate!.eq(date, granularity: .day) {
                            cellState = .selectedStart
                        } else if let startDate = self.startDate, date.gt(startDate, granularity: .day) && date.le(startDate.addingTimeInterval(TimeInterval(84600 * (minSpaceDays + 1))), granularity: .day) {
                            cellState = .availableDisabled
                        } else {
                            cellState = .available
                        }
                    case .range:
                        if let startDate = self.startDate, startDate.eq(date, granularity: .day) {
                            cellState = .selectedStart
                        } else if let endDate = self.endDate, endDate.eq(date, granularity: .day) {
                            cellState = .selectedEnd
                        } else if let startDate = self.startDate, let endDate = self.endDate, date.gt(startDate, granularity: .day) && date.lt(endDate, granularity: .day) {
                            cellState = .selectedMiddle
                        } else {
                            cellState = .available
                        }
                    case .none: cellState = .available
                    }
                }
            } else {
                cellState = .empty
            }
            
            cell.state = cellState
        }
    }
    
    func calendarView(_ calendarView: CalendarView, monthHeaderView: MonthHeaderView, forMonth date: Date?) {
        monthHeaderView.style = .custom
    }
    
    func calendarView(_ calendarView: CalendarView, weekdayView: UILabel, forWeekday weekday: Int) {
        weekdayView.font = UIFont.systemFont(ofSize: 13)
        if weekday == 0 || weekday == 6 {
            weekdayView.textColor = UIColor.lightGray
        }
    }
}

extension RangeSimpleViewController: CalendarDelegate {
    
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date?) -> Bool {
        
        if let date = date {
            if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) {
                return false
            }
            
            switch self.selectionState {
            case .start:
                if let startDate = self.startDate, date.lt(startDate, granularity: .day) {
                    return false
                }
                
                let minSpaceDays = 1
                if let startDate = self.startDate, date.gt(startDate, granularity: .day) && date.le(startDate.addingTimeInterval(TimeInterval(84600 * (minSpaceDays + 1))), granularity: .day) {
                    return false
                }
            default: break
            }
            
            return true
        }
        return false
    }
    
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {
        
        if let date = date {
            if self.startDate == nil {
                self.startDate = date
                self.selectionState = .start
            } else if (self.endDate == nil) {
                if let startDate = self.startDate, date.eq(startDate, granularity: .day) {
                    
                    // to proform handler
                    // ...
                    self.selectionState = .none
                    return
                }
                self.endDate = date
                self.selectionState = .range
            } else {
                self.endDate = nil
                self.startDate = date
                self.selectionState = .start
            }
        }
        
        // to proform handler
        // ...
    }
}
