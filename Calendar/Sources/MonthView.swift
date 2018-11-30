//
//  MonthView.swift
//  Calendar
//
//  Created by wanggang on 16/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

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
            if let date = date {
                if self.style == .default {
                    let monthSymbols = Date.formatter.standaloneMonthSymbols
                    if let monthString = monthSymbols?[date.month - 1] {
                        self.addSubview(self.textLabel)
                        self.textLabel.text = monthString
                        self.textLabel.sizeToFit()
                    }
                } else {
                    self.textLabel.removeFromSuperview()
                }
            } else {
                self.textLabel.removeFromSuperview()
                self.textLabel.text = nil
            }
        }
    }
    
    public var style: MonthViewStyle = .`default` {
        
        didSet {
            switch style {
            case .default:
//                if self.textLabel == nil {
//                    let label = UILabel()
//                    label.font = UIFont.systemFont(ofSize: 16)
//                    label.textColor = UIColor.darkGray
//                    label.textAlignment = .left
//                    self.textLabel = label
                    self.addSubview(self.textLabel)
//                }
            case .custom:
//                self.textLabel = nil
                self.textLabel.removeFromSuperview()
            }
        }
    }
    
    open lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.style = .default
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if style == .`default` {
            self.textLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.textLabel.frame.width, height: 20))
        }
    }
}

open class MonthFooterView: MonthView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
