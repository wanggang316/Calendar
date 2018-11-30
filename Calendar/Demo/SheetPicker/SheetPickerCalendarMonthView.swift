//
//  SheetPickerCalendarMonthView.swift
//  Calendar
//
//  Created by gang wang on 2018/11/30.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class SheetPickerCalendarMonthView: MonthHeaderView {
    
    override var date: Date? {
        didSet {
            if let date = date {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy年MM月"
                dateFormatter.string(from: date)
                
//                let monthSymbols = Date.formatter.standaloneMonthSymbols
//                if let monthString = monthSymbols?[date.month - 1] {
                    self.monthLabel.text = dateFormatter.string(from: date)
//                }
                self.monthLabel.sizeToFit()
            } else {
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.style = .custom
        self.addSubview(self.monthLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = self.date {
            self.monthLabel.frame = CGRect(x: 0, y: 0, width: self.monthLabel.frame.width, height: 20)
            self.monthLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        }
    }
    
    // MARK: - UI
    var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        return label
    }()
}
