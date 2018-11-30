//
//  SheetDatePickerView.swift
//  Calendar
//
//  Created by gang wang on 2018/11/30.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class SheetDatePickerView: UIView {

    var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 1
        cal.minimumInteritemSpacing = 1
        cal.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        cal.minimumWeekAndDateItemSpacing = 10
        cal.weekViewHeight = 30
        cal.monthFooterViewHeight = 20
        cal.cellAspectRatio = 100.0 / 140.0
        
        cal.register(SheetDatePickerDayCell.self)
        cal.register(monthHeader: SheetPickerCalendarMonthView.self)
        
        return cal
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentViewHeight))
        view.backgroundColor = UIColor.white
        let buttonHeight: CGFloat = 38
        view.addSubview(self.calendarView)
        self.calendarView.frame = CGRect(x: 0, y: buttonHeight, width: view.frame.width, height: pickerHeight)
        
        self.cancelButton.frame = CGRect(x: 15, y: 0, width: 50, height: buttonHeight)
        view.addSubview(self.cancelButton)

        let lineView = UIView(frame: CGRect(x: 0, y: buttonHeight, width: view.frame.width, height: 0.5))
        lineView.backgroundColor = UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        view.addSubview(lineView)
        return view
    }()
    lazy var emptyView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.contentViewHeight))
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private let buttonHeight: CGFloat = 40
    private let pickerHeight: CGFloat = 200
    private let pickerRowHeight: CGFloat = 40
    private let contentViewHeight: CGFloat = 240
    
    // MARK: - public properties
    // callback value
    var valueChangeCallback: ((String) -> Void)?
    // callback select row
    var rowChangeCallback: ((Int) -> Void)?
    
    var items: [String] = [] {
        didSet {
            //            self.selectedRow = 0
            //            self.picker.selectRow(0, inComponent: 0, animated: false)
//            self.picker.reloadAllComponents()
        }
    }
    var selectedRow: Int = 0
    
    public func selectItem(_ item: String) {
        if let index = self.items.index(of: item) {
            self.selectedRow = index
//            self.picker.selectRow(index, inComponent: 0, animated: false)
//            self.picker.reloadAllComponents()
        }
    }
    
    var selectedDate: Date?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        self.addSubview(self.emptyView)
        self.addSubview(self.contentView)
//        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - public
    func show() {
        self.alpha = 0.0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentViewHeight)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - 200, width: self.frame.width, height: self.contentViewHeight)
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
    @objc private func confirmAction() {
        self.close()
        if self.selectedRow < self.items.count {
            self.valueChangeCallback?(self.items[self.selectedRow])
            self.rowChangeCallback?(self.selectedRow)
        }
    }
    
}


extension SheetDatePickerView: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: DayCell, forDay date: Date?) {
        
        cell.style = .custom
        
        if let cell = cell as? SheetDatePickerDayCell {
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

extension SheetDatePickerView: CalendarDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectedDate date: Date?, of cell: DayCell) {
        
        self.selectedDate = date
        calendarView.reloadData()
        
    }
}
