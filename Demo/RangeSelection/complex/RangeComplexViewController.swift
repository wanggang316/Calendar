//
//  RangeComplexViewController.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class RangeComplexViewController: UIViewController {
    
    enum RangeSelectedState {
        case none
        case start
        case range
    }
    
    var selectionState: RangeSelectedState = .none {
        didSet {
            switch selectionState {
            case .none:
                self.title = "选择起始日期(至少\(self.minNights)天)"
                self.nearestUnavailableDate = nil
                self.reset()
                return
            case .start:
                self.endDate = nil
                self.tempUnavailableDates.removeAll()
                self.nearestUnavailableDate = nil
                
                self.calendarView.reloadData()
                
                for i in 1..<self.minNights {
                    let theDate = self.startDate!.addingTimeInterval(TimeInterval(i * 24 * 60 * 60))
                    if let priceDate = self.priceDate(for: theDate), !priceDate.available {
                        print("----> !!! HUD 最小入住\(self.minNights)天 duration 0.8 second")
                        // then reset
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.reset()
                        }
                        return
                    }
                }
                
                // selectedDate + minNights > toDate
                if let startDate = self.startDate, let endDate = self.endDate,
                    startDate.addingTimeInterval(TimeInterval(self.minNights * 24 * 60 * 60)).gt(endDate, granularity: .day) {
                    
                    print("!!! HUD 最小入住\(self.minNights)天 duration 0.8 second")
                    // then reset
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.reset()
                    }
                    return
                }
                
                self.title = "选择退房日期"
                
                // - set the day between and `startDate` and `minNights` unavaible.
                for i in 1..<self.minNights {
                    let theDate = self.startDate!.addingTimeInterval(TimeInterval(i * 24 * 60 * 60))
                    self.tempUnavailableDates.update(with: theDate)
                }
                
                self.nearestUnavailableDate = self.nearestUnavailableDate(for: self.startDate!)
                self.calendarView.reloadData()
                
            case .range:
                self.calendarView.reloadData()
                self.title = "选择起始日期(至少\(self.minNights)天)"
            }
        }
    }
    
    var startDate: Date?
    var endDate: Date?
    
    var priceDates: PriceDates? {
        didSet {
            if let priceDates = priceDates {
                self.calendarView.fromDate = priceDates.startDate
                self.calendarView.toDate = priceDates.endDate
                self.calendarView.reloadData()
            }
        }
    }
    var minNights: Int = 2
    
    /// The just checkout day
    var nearestUnavailableDate: Date?
    /// The avaible day which used to be unavailabled days after `startDate`
    var tempUnavailableDates: Set<Date> = Set<Date>()
    
    var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 0
        cal.minimumInteritemSpacing = 0
        cal.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        cal.weekViewHeight = 46
        cal.monthHeaderViewHeight = 71
        cal.monthFooterViewHeight = 19
        cal.cellAspectRatio = 92.0 / 102.0
        
        cal.register(RangeComplexCell.self)
        cal.register(monthHeader: RangeComplexMonthHeaderView.self)
        
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
    
    // MARK: -
    func priceDate(for date: Date) -> PriceDate? {
        
        guard let priceDates = self.priceDates, let dates = priceDates.dates else { return nil }
        
        let pd = PriceDate(date: date, available: false, price: 0)
        if let index = dates.index(of: pd) {
            return dates[index]
        }
        return nil
    }
    
    func reset() {
        self.startDate = nil
        self.endDate = nil
        self.calendarView.reloadData()
    }
    
    func nearestUnavailableDate(for startDate: Date) -> Date? {
        let nextDate = startDate.addingTimeInterval(86400)
        if let priceDate = self.priceDate(for: nextDate) {
            if !priceDate.available {
                return nextDate
            } else {
                return self.nearestUnavailableDate(for: nextDate)
            }
        } else {
            return nextDate
        }
    }
    
}

extension RangeComplexViewController: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {
        
        //        cell.style = .custom
        
        if let cell = cell as? RangeComplexCell {
            
            var cellState: RangeComplexCell.DayCellState = .empty
            var price: Float? = nil
            
            if let date = date {
                
                cell.date = date
                
                if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) {
                    cellState = .disabled
                } else {
                    
                    /// the nearest unavailable date (The just checkout day)
                    
                    let priceDate = self.priceDate(for: date)
                    if (priceDate != nil) || ((self.nearestUnavailableDate != nil) && date.eq(self.nearestUnavailableDate!, granularity: .day))  {
                        
                        price = priceDate?.price
                        let available = priceDate?.available ?? false
                        
                        switch self.selectionState {
                        case .start:
                            if let startDate = self.startDate, date.lt(startDate, granularity: .day),
                                date.ge(calendarView.fromDate, granularity: .day) {
                                if available {
                                    cellState = .availableDisabled
                                } else {
                                    cellState = .unavailable
                                }
                            } else if let startDate = self.startDate, date.eq(startDate, granularity: .day) {
                                cellState = .selectedStart
                            } else if self.tempUnavailableDates.contains(date) {
                                cellState = .availableDisabled
                            } else if let nearestUnavailableDate = self.nearestUnavailableDate, date.eq(nearestUnavailableDate, granularity: .day) {
                                cellState = .tempEnd
                            } else if let nearestUnavailableDate = self.nearestUnavailableDate, date.gt(nearestUnavailableDate, granularity: .day),
                                date.le(calendarView.toDate, granularity: .day) {
                                if available {
                                    cellState = .availableDisabled
                                } else {
                                    cellState = .unavailable
                                }
                            } else {
                                if available {
                                    cellState = .available
                                } else {
                                    cellState = .unavailable
                                }
                            }
                        case .range:
                            if let startDate = self.startDate, date.eq(startDate, granularity: .day) {
                                cellState = .selectedStart
                            } else if let endDate = self.endDate, date.eq(endDate, granularity: .day) {
                                cellState = .selectedEnd
                            } else if let startDate = self.startDate, date.gt(startDate, granularity: .day),
                                let endDate = self.endDate, date.lt(endDate, granularity: .day) {
                                cellState = .selectedMiddle
                            } else {
                                if available {
                                    cellState = .available
                                } else {
                                    cellState = .unavailable
                                }
                            }
                        default:
                            if available {
                                cellState = .available
                            } else {
                                cellState = .unavailable
                            }
                        }
                    } else {
                        cellState = .disabled
                    }
                    
                }
            } else {
                cellState = .empty
            }
            
            cell.price = price
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

extension RangeComplexViewController: CalendarDelegate {
    
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date?) -> Bool {
        
        if let date = date {
            if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) { return false }
            
            switch self.selectionState {
            case .start:
                // less than startDate is not selectable
                if let startDate = self.startDate, date.lt(startDate, granularity: .day) { return false }
                
                // nearest unavailable date is selectable
                if let nearestUnavailableDate = self.nearestUnavailableDate, date.eq(nearestUnavailableDate, granularity: .day) { return true }
                
                // temp unavailable dates is not selectable
                if self.tempUnavailableDates.contains(date) { return false }
                
                // nearestUnavailableDate is not nil, the date is greater than that is not selectable
                if let nearestUDate = self.nearestUnavailableDate, date.gt(nearestUDate, granularity: .day) { return false }
                
                // Else judgement by available
                if let priceDate = self.priceDate(for: date) {
                    return priceDate.available
                }
                return false
            default:
                if let priceDate = self.priceDate(for: date) {
                    return priceDate.available
                }
                return false
            }
        }
        return true
    }
    
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {
        
        if let date = date {
            if self.startDate == nil {
                self.startDate = date
                self.selectionState = .start
            } else if (self.endDate == nil) {
                if let startDate = self.startDate, date.eq(startDate, granularity: .day) {
                    
                    self.selectionState = .none
                    return
                }
                self.endDate = date
                self.selectionState = .range
                
                // pop self ...
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
