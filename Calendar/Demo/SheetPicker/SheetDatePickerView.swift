//
//  SheetDatePickerView.swift
//  Calendar
//
//  Created by gang wang on 2018/11/30.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class SheetDatePickerView: UIView {

    lazy var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 1
        cal.minimumInteritemSpacing = 1
        cal.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        cal.minimumWeekAndDateItemSpacing = 10
        cal.weekViewHeight = 28
        cal.monthFooterViewHeight = 0
        cal.cellAspectRatio = 1
        
        cal.weekView.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        cal.register(SheetDatePickerDayCell.self)
        cal.register(monthHeader: SheetPickerCalendarMonthView.self)
        
        cal.dataSource = self
        cal.delegate = self
        return cal
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0), for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentViewHeight))
        view.backgroundColor = UIColor.white
        
        view.addSubview(self.cancelButton)
        view.addSubview(self.titleLabel)
        view.addSubview(self.calendarView)
        
        return view
    }()
    lazy var emptyView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.contentViewHeight))
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private let buttonHeight: CGFloat = 52
    private var calendarHeight: CGFloat = 463
    private var contentViewHeight: CGFloat {
        return calendarHeight + buttonHeight
    }
    
    // MARK: - public properties
    // callback value
    var valueChangeCallback: ((String) -> Void)?
    // callback select row
    var rowChangeCallback: ((Int) -> Void)?
    
    var startDate: Date? {
        didSet {
            
            guard let startDate = startDate else { return }
            
            let date = startDate
            
            self.calendarView.fromDate = date
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            var components = calendar.dateComponents([Calendar.Component.year, .month, .day], from: date)
            if let day = components.day {
                components.day = day + spaceDays
                if let lastDate = calendar.date(from: components) {
                    self.calendarView.toDate = lastDate
                    
                    if lastDate.month == date.month {
                        calendarHeight = 28 + 44 + CGFloat(lastDate.lastDateOfMonth().weekOfMonth) * UIScreen.main.bounds.width / 7.0 + 20
                    } else {
                        calendarHeight = 463
                    }
                }
            }
            self.calendarView.reloadData()
            self.layoutSubviews()
        }
    }
    
    var selectedDate: Date? {
        didSet {
            self.calendarView.reloadData()
        }
    }
    var spaceDays: Int = 15
    
    var selectedHandler: ((Date) -> Void)?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.2)

        self.titleLabel.text = "选择起租日期"
        
        
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.contentViewHeight)
        self.cancelButton.frame = CGRect(x: 15, y: 0, width: 50, height: buttonHeight)
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: buttonHeight)
        self.titleLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: buttonHeight / 2)
        self.calendarView.frame = CGRect(x: 0, y: buttonHeight, width: self.contentView.frame.width, height: calendarHeight)
        
        self.addSubview(self.emptyView)
        self.addSubview(self.contentView)
        
        
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    // MARK: - public
    func show() {
        self.alpha = 0.0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentViewHeight)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - self.contentViewHeight, width: self.frame.width, height: self.contentViewHeight)
        }) { result in
            
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentViewHeight)
        }) { result in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - Actions
    @objc private func dateChanged(_ sender: UIDatePicker) {
        
    }
    
    @objc private func tapAction() {
        self.close()
    }
    
    @objc private func cancelAction() {
        self.close()
    }
}


extension SheetDatePickerView: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {
        
        cell.style = .custom
        
        if let cell = cell as? SheetDatePickerDayCell {
            if let date = date {
                
                if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) {
                    cell.state = .disabled
                } else if let selectedDate = self.selectedDate, date.eq(selectedDate, granularity: .day) {
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
        weekdayView.textColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
}

extension SheetDatePickerView: CalendarDelegate {
    
    func calendarView(_ calendarView: CalendarView, shouldSelectDate date: Date?) -> Bool {
        if let date = date {
            if date.lt(calendarView.fromDate, granularity: .day) || date.ge(calendarView.toDate, granularity: .day) {
                return false
            }
        }
        return true
    }
    
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {
        
        self.selectedDate = date
        calendarView.reloadData()
        
        if let date = date {
            self.selectedHandler?(date)
            self.close()
        }
    }
}
