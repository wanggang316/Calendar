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
                textLabel.text = String("\(date.year) 年 \(date.month) 月")
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
                    label.font = UIFont.systemFont(ofSize: 20)
                    label.textColor = UIColor.darkGray
                    label.textAlignment = .center
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
        self.backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if style == .`default` {
            self.textLabel?.frame = self.bounds
        }
    }
}

open class MonthFooterView: MonthView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
