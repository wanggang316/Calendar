//
//  SheetDatePickerDayCell.swift
//  Calendar
//
//  Created by gang wang on 2018/11/30.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class SheetDatePickerDayCell: DayCell {
    
    enum DayCellState {
        case empty
        case disabled
        case normal
        case selected
    }
    
    var state: DayCellState = .normal {
        didSet {

            switch state {
            case .empty:
                self.descLabel.removeFromSuperview()
                self.backView.backgroundColor = UIColor.white
                self.titleLabel.text = nil
            case .disabled:
                self.descLabel.removeFromSuperview()
                self.backView.backgroundColor = UIColor.white
                self.titleLabel.textColor = UIColor(red: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
            case .normal:
                self.descLabel.removeFromSuperview()
                self.backView.backgroundColor = UIColor.white
                self.titleLabel.textColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
            case .selected:
                self.backView.addSubview(self.descLabel)
                self.backView.backgroundColor = UIColor(red: 255.0 / 255.0, green: 245.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
                self.titleLabel.textColor = UIColor(red: 243.0 / 255.0, green: 152.0 / 255.0, blue: 0, alpha: 1.0)
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
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 243.0 / 255.0, green: 152.0 / 255.0, blue: 0, alpha: 1.0)
        label.textAlignment = .center
        label.text = "起租"
        return label
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = self.bounds
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 24)
        self.titleLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 6)
        switch state {
        case .selected:
            self.descLabel.frame = CGRect(x: 0, y: self.titleLabel.frame.maxY, width: self.bounds.width, height: 14)
        default: break
        }
        
    }
    
}
