//
//  CalendarWeekView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

open class CalendarWeekView: UIView {
    
    weak var delegate: CalendarWeekViewDelegate?
    
    open var contentInset: UIEdgeInsets?
    
    // MARK: - UI
    public var contentView: UIView = UIView()
    
    // MARK: - public functions
    public func reloadWeekView() {
        for i in 0...7 {
            let label = self.viewWithTag(109001 + i)
            if let label = label as? UILabel {
                self.delegate?.calendarWeekView(self, weekdayView: label, forWeekday: i)
            }
        }
    }

    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.4, blue: 0.5, alpha: 0.7)
        self.contentView.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.5)
        self.addSubview(self.contentView)
        
        let weekdaySymbols = Date.formatter.veryShortWeekdaySymbols
        
        for (index, element) in weekdaySymbols!.enumerated() {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.tag = 109001 + index
            label.text = element
            self.contentView.addSubview(label)
        }
        
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let contentInset = self.contentInset {
            self.contentView.frame = CGRect(x: contentInset.left,
                                            y: contentInset.top,
                                            width: self.frame.width - contentInset.left - contentInset.right,
                                            height: self.frame.height - contentInset.top - contentInset.bottom)
        } else {
            self.contentView.frame = self.bounds
        }
        
        for i in 0...7 {
            let label = self.viewWithTag(109001 + i)
            if let label = label {
                let width: CGFloat = self.contentView.frame.width / 7
                label.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: self.contentView.frame.height)
            }
        }
    }
}

protocol CalendarWeekViewDelegate: NSObjectProtocol {
    func calendarWeekView(_ weekView: CalendarWeekView, weekdayView: UILabel, forWeekday weekday: Int)
}
