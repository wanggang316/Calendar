//
//  SimpleMonthHeaderView.swift
//  Calendar
//
//  Created by wanggang on 22/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class SimpleMonthHeaderView: MonthHeaderView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}
