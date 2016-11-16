//
//  CalendarWeekView.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

open class CalendarWeekView: UIView {
    
    //
    open var contentInset: UIEdgeInsets? {
        didSet {
            
        }
    }
    
    // MARK: - UI
    public var contentView: UIView = UIView()
    

    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.4, blue: 0.5, alpha: 0.7)
        self.contentView.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.5, blue: 0.8, alpha: 0.5)
        self.addSubview(self.contentView)
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
    }

}
