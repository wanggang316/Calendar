//
//  ShowDayCell.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar


class ShowDayCell: DayCell {

    enum DayCellState {
        case empty
        case disabled
        case available
        case unavailable
    }

    var state: DayCellState = .empty {
        didSet {
            switch state {
            case .empty:
                self.textLabel?.text = nil
                self.priceLabel.text = nil
                self.backgroundView = nil
            case .disabled:
                self.backgroundView = nil
                self.priceLabel.text = nil
                self.textLabel?.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green:192.0 / 255.0, blue: 200.0 / 255.0, alpha:1.0)
            case .available:
                self.backgroundView = nil
                self.textLabel?.textColor = UIColor(colorLiteralRed: 9.0 / 255.0, green: 9.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
            case .unavailable:
                self.backgroundView = self.backgroundImageView
                self.textLabel?.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
                self.priceLabel.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
                self.priceLabel.text = "已租"
            }
            self.layoutSubviews()
        }
    }
    override var date: Date? {
        didSet {
            if let date = date {
                self.textLabel?.text = String(date.day)
            } else {
                self.textLabel?.text = nil
            }
        }
    }
    var price: Float? {
        didSet {
            if let price = price {
                self.priceLabel.text = String(price)
            } else {
                self.priceLabel.text = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.priceLabel)
        self.addSubview(self.backgroundImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textLabel = self.textLabel {
            if let _ = self.price {
                textLabel.frame = CGRect(x: 0, y: self.contentView.center.y - 15 - 1, width: textLabel.frame.width, height: 15)
                self.priceLabel.frame = CGRect(x: 0, y: self.contentView.center.y + 5, width: self.contentView.frame.width, height: 9)
                self.backgroundImageView.frame = self.contentView.bounds
            } else {
                textLabel.frame = self.contentView.bounds
                self.backgroundImageView.frame = self.contentView.bounds
            }
        } else {
            
        }
    }
    
    
    // MARK: - UI
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.textColor = UIColor(colorLiteralRed: 157.0 / 255.0, green: 157.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
        return label
    }()
    
    var backgroundImageView: UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "unavailable")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }
}
