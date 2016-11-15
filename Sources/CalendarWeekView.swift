//
//  CalendarWeekView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

class CalendarWeekView: UIView {

    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(colorLiteralRed: 0.3, green: 0.4, blue: 0.5, alpha: 0.7)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
