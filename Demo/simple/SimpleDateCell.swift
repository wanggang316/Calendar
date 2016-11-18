//
//  SimpleDateCell.swift
//  Calendar
//
//  Created by wanggang on 17/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

class SimpleDateCell: UICollectionViewCell {
    
    var date: Date? {
        didSet {
            if let date = date {
                self.titleLabel.text = String(date.day)
                if date.isToday() {
                    self.titleLabel.text = "Today"
                }
            } else {
                self.titleLabel.text = nil
            }
        }
    }
    
    var isGray: Bool = false {
        didSet {
            if isGray {
                self.titleLabel.textColor = UIColor.lightGray
            } else {
                self.titleLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
}
