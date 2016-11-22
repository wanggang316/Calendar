//
//  SimpleDateCell.swift
//  Calendar
//
//  Created by wanggang on 17/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class SimpleDateCell: DayCell {
    
    var title: String? {
        didSet {
            if let title = title {
                self.titleLabel.text = title
            } else {
                self.titleLabel.text = nil
            }
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(colorLiteralRed: 0.7, green: 0.3, blue: 0.1, alpha: 0.3)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
    
    
}
