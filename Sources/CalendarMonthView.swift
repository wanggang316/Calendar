//
//  CalendarMonthView.swift
//  Calendar
//
//  Created by wanggang on 16/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

open class CalendarMonthView: UICollectionReusableView {
}

open class CalendarMonthHeaderView: CalendarMonthView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class CalendarMonthFooterView: CalendarMonthView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
