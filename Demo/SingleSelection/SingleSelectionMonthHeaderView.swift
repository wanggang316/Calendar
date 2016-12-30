//
//  SimpleMonthHeaderView.swift
//  Calendar
//
//  Created by wanggang on 22/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class SingleSelectionMonthHeaderView: MonthHeaderView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let date = self.date {
            let centerX = (self.frame.width / 14.0) * CGFloat((date.weekday - 1) * 2 + 1)
            self.textLabel?.center = CGPoint(x: CGFloat(centerX), y: self.frame.height / 2)
        }
    }
}
