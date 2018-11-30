//
//  WeekView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

open class WeekView: UIView {
    
    weak var delegate: WeekViewDelegate?
    
    open var contentInset: UIEdgeInsets?
    
    // MARK: - UI
    public var contentView: UIView = UIView()
    
    // MARK: - public functions
    public func reloadWeekView() {
        for i in 0...7 {
            let label = self.viewWithTag(109001 + i)
            if let label = label as? UILabel {
                self.delegate?.weekView(self, weekdayView: label, forWeekday: i)
            }
        }
    }

    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.contentView)

        let weekdaySymbols = Date.formatter.shortWeekdaySymbols
        
        for (index, _) in weekdaySymbols!.enumerated() {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.tag = 109001 + index
            label.text = self.weekdayDescription(for: index)
            self.contentView.addSubview(label)
        }
    }
    
    func weekdayDescription(for index: Int) -> String {
        switch index {
        case 0: return "日"
        case 1: return "一"
        case 2: return "二"
        case 3: return "三"
        case 4: return "四"
        case 5: return "五"
        case 6: return "六"
        default: return ""
        }
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
                let width: CGFloat = (self.contentView.frame.width - 6.0) / 7.0
                label.frame = CGRect(x: (width + 1) * CGFloat(i), y: 0, width: width, height: self.contentView.frame.height)
            }
        }
    }
}

protocol WeekViewDelegate: NSObjectProtocol {
    func weekView(_ weekView: WeekView, weekdayView: UILabel, forWeekday weekday: Int)
}
