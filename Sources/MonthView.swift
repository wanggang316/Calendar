//
//  MonthView.swift
//  Calendar
//
//  Created by wanggang on 16/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

public enum MonthViewStyle : Int {
    /// View with text label which is shown the date.
    case `default`
    /// No UI element in the cell, you can custom your element as you want.
    case custom
}


open class MonthView: UICollectionReusableView {
}

open class MonthHeaderView: MonthView {
    
    open var date: Date? {
        didSet {
            if let date = date, self.style == .default, let textLabel = self.textLabel {
                let monthSymbols = Date.formatter.standaloneMonthSymbols
                if let monthString = monthSymbols?[date.month - 1] {
                    textLabel.text = monthString
                    textLabel.sizeToFit()
                }
            } else {
                self.textLabel?.text = nil
            }
        }
    }
    
    public var style: MonthViewStyle = .`default` {
        
        didSet {
            switch style {
            case .default:
                if self.textLabel == nil {
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 16)
                    label.textColor = UIColor.darkGray
                    label.textAlignment = .left
                    self.textLabel = label
                    self.addSubview(self.textLabel!)
                }
            case .custom:
                self.textLabel = nil
            }
        }
    }
    
    open var textLabel: UILabel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if style == .`default` {
            self.textLabel?.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.textLabel?.frame.width ?? 0, height: 20))
            if let date = self.date {
                self.textLabel?.center = CGPoint(x: CGFloat(25 * ((date.weekday - 1) * 2 + 1)), y: self.frame.height / 2)
            }
        }
    }
}

open class MonthFooterView: MonthView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
