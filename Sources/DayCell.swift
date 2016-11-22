//
//  ViewCell.swift
//  Calendar
//
//  Created by wanggang on 18/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

public enum DayCellStyle : Int {
    /// Day cell with text label which is shown the date.
    case `default`
    /// No UI element in the cell, you can custom your element as you want.
    case custom
}

/**
 The base day cell, you should inherit it if you use this frame, like you use UITableViewCell.
 
 Day cell provide a optional `date` property:
 - if the date is nil, it's the cell which is before the first date of month or after the last date of month,
 - if the date is not nil, it's a valid date for you to use
 
 You can adjust the style or do any thing base the optional date.
 */
open class DayCell: UICollectionViewCell {
    
    open var date: Date? {
        didSet {
            if let date = date, self.style == .default, let textLabel = self.textLabel {
                textLabel.text = String(date.day)
            } else {
                self.textLabel?.text = nil
            }
        }
    }
    
    public var style: DayCellStyle = .`default` {
        
        didSet {
            switch style {
            case .default:
                if self.textLabel == nil {
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 15)
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

    /// default is nil.  label will be created if necessary.
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
            self.textLabel?.frame = self.bounds
        }
    }
}
