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
