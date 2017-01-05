//
//  RangeComplexMonthHeaderView.swift
//  Calendar
//
//  Created by wanggang on 03/01/2017.
//  Copyright © 2017 GUM. All rights reserved.
//

import UIKit
import Calendar

class RangeComplexMonthHeaderView: MonthHeaderView {

    
    override var date: Date? {
        didSet {
            if let date = date {
                let monthSymbols = Date.formatter.standaloneMonthSymbols
                if let monthString = monthSymbols?[date.month - 1] {
                    self.monthLabel.text = monthString
                }
                self.yearLabel.text = String(date.year)
                self.monthLabel.sizeToFit()
            } else {
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.monthLabel)
        self.addSubview(self.yearLabel)
        self.layer.addSublayer(self.bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = self.date {
            self.monthLabel.frame = CGRect(x: 13, y: 20, width: self.monthLabel.frame.width, height: 20)
            self.yearLabel.frame = CGRect(x: self.monthLabel.frame.maxX + 3, y: self.monthLabel.frame.maxY - 2 - 9, width: 100, height: 9)
            self.bottomLine.frame = CGRect(x: self.monthLabel.frame.minX, y: self.monthLabel.frame.maxY + 11, width: 30, height: 2)
        }
    }
    
    // MARK: - UI
    var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.darkText
        return label
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.darkText
        return label
    }()
    
    var bottomLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(colorLiteralRed: 230.0 / 255.0, green: 230.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0).cgColor
        return layer
    }()

}
