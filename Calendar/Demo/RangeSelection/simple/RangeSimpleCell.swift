//
//  RangeSimpleSelectionCell.swift
//  Calendar
//
//  Created by wanggang on 03/01/2017.
//  Copyright © 2017 GUM. All rights reserved.
//

import UIKit

class RangeSimpleCell: DayCell {
    
    enum DayCellState {
        case empty
        case disabled
        case available
        case availableDisabled
        case selectedStart
        case selectedMiddle
        case selectedEnd
    }
    
    override var date: Date? {
        didSet {
            if let date = self.date {
                self.textLabel?.font = UIFont.systemFont(ofSize: 17)
                self.textLabel?.text = String(date.day)
            } else {
                self.textLabel?.text = nil
            }
        }
    }
    
    var state: DayCellState = .empty {
        didSet {
            switch state {
            case .empty:
                self.textLabel?.text = nil
                self.stateLabel.text = nil
                self.stateLabel.removeFromSuperview()
                self.contentView.backgroundColor = UIColor.white
            case .disabled:
                self.stateLabel.removeFromSuperview()
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(red: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
            case .available:
                self.stateLabel.removeFromSuperview()
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(red: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
            case .availableDisabled:
                self.stateLabel.removeFromSuperview()
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(red: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
            case .selectedStart:
                self.contentView.addSubview(self.stateLabel)
                self.contentView.backgroundColor = UIColor(red: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.stateLabel.textColor = UIColor.white
                self.stateLabel.text = "入住"
            case .selectedMiddle:
                self.stateLabel.removeFromSuperview()
                self.contentView.backgroundColor = UIColor(red: 58.0 / 255.0, green: 58.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.stateLabel.textColor = UIColor.white
            case .selectedEnd:
                self.contentView.addSubview(self.stateLabel)
                self.contentView.backgroundColor = UIColor(red: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.stateLabel.textColor = UIColor.white
                self.stateLabel.text = "退房"
            }
            self.layoutSubviews()
        }
    }
    
    // MARK: - 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.stateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.stateLabel.superview != nil && self.stateLabel.text != nil  {
            self.textLabel?.frame = CGRect(x: 0, y: self.bounds.height / 2 - 15, width: self.bounds.width, height: 15)
            self.stateLabel.frame = CGRect(x: 0, y: self.bounds.height / 2 + 4, width: self.bounds.width, height: 9)
        } else {
            self.textLabel?.frame = self.bounds
        }
    }
    
    // MARK: - UI
    var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = UIColor(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
        return label
    }()
}
