//
//  SimpleDateCell.swift
//  Calendar
//
//  Created by wanggang on 17/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar



class SingleSelectionDayCell: DayCell {
    
    enum DayCellState {
        case empty
        case normal
        case selected
    }
    
    var state: DayCellState = .normal {
        didSet {
                switch state {
                case .empty:
                    self.topLayer.isHidden = true
                    self.titleLabel.text = nil
                    self.titleLabel.backgroundColor = UIColor.white
                    self.titleLabel.layer.cornerRadius = 0
                case .normal:
                    self.topLayer.isHidden = false
                    self.titleLabel.layer.cornerRadius = 0
                    self.titleLabel.backgroundColor = UIColor.white

                    if let date = self.date, date.isToday() {
                        self.titleLabel.textColor = UIColor(red: 255.0 / 255.0, green: 60.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
                    } else if let date = self.date, date.isWeekend() {
                        self.titleLabel.textColor = UIColor.lightGray
                    } else {
                        self.titleLabel.textColor = UIColor.darkGray
                    }
                case .selected:
                    self.topLayer.isHidden = false
                    self.titleLabel.layer.cornerRadius = 17
                    self.titleLabel.textColor = UIColor.white
                    if let date = self.date, date.isToday() {
                        self.titleLabel.backgroundColor = UIColor(red: 255.0 / 255.0, green: 50.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
                    } else {
                        self.titleLabel.backgroundColor = UIColor.darkGray
                    }
                }
        }
    }

    override var date: Date? {
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
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    lazy var topLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5)
        layer.backgroundColor = UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0).cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(self.topLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.titleLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 13)
    }
    
    
    
}
