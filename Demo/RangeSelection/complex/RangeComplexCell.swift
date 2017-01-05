//
//  RangeComplexCell.swift
//  Calendar
//
//  Created by wanggang on 03/01/2017.
//  Copyright © 2017 GUM. All rights reserved.
//

import UIKit
import Calendar

class RangeComplexCell: DayCell {

    
    enum DayCellState {
        case empty
        case disabled
        case available
        case unavailable
        case availableDisabled
        case selectedStart
        case selectedMiddle
        case selectedEnd
        case tempEnd
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
    
    var price: Float? {
        didSet {
            if let price = price {
                self.priceLabel.text = String(price)
            } else {
                self.priceLabel.text = nil
            }
        }
    }
    
    var state: DayCellState = .empty {
        didSet {
            switch state {
            case .empty:
                self.textLabel?.text = nil
                self.priceLabel.text = nil
                self.priceLabel.removeFromSuperview()
                self.backgroundView = nil
                self.contentView.backgroundColor = UIColor.white
            case .disabled:
                self.priceLabel.removeFromSuperview()
                self.backgroundView = nil
                
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
            case .available:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(colorLiteralRed: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.priceLabel.textColor = UIColor(colorLiteralRed: 157.0 / 255.0, green: 157.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
            case .unavailable:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = self.backgroundImageView
                
                self.contentView.backgroundColor = UIColor.clear
                self.textLabel?.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
                self.priceLabel.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
                
                self.priceLabel.text = "已租"
                
            case .availableDisabled:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
                self.priceLabel.textColor = UIColor(colorLiteralRed: 192.0 / 255.0, green: 192.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
            case .selectedStart:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                self.contentView.backgroundColor = UIColor(colorLiteralRed: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.priceLabel.textColor = UIColor.white
                self.priceLabel.text = "入住"
            case .selectedMiddle:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                self.contentView.backgroundColor = UIColor(colorLiteralRed: 58.0 / 255.0, green: 58.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.priceLabel.textColor = UIColor.white
            case .selectedEnd:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                self.contentView.backgroundColor = UIColor(colorLiteralRed: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.textLabel?.textColor = UIColor.white
                self.priceLabel.textColor = UIColor.white
                self.priceLabel.text = "入住"
            case .tempEnd:
                self.contentView.addSubview(self.priceLabel)
                self.backgroundView = nil
                self.contentView.backgroundColor = UIColor.white
                self.textLabel?.textColor = UIColor(colorLiteralRed: 9.0 / 255.0, green: 9.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
                self.priceLabel.textColor = UIColor(colorLiteralRed: 157.0 / 255.0 , green: 157.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
                self.priceLabel.text = "仅退房"
                
            }
            
            self.layoutSubviews()
        }
    }
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = CGRect(x: 0, y: self.bounds.height / 2 - 15, width: self.bounds.width, height: 15)

        if self.priceLabel.superview != nil && self.priceLabel.text != nil  {
            self.priceLabel.frame = CGRect(x: 0, y: self.bounds.height / 2 + 4, width: self.bounds.width, height: 9)
        } else {
//            self.textLabel?.frame = self.bounds
        }
        
        self.backgroundImageView.frame = self.contentView.bounds
    }
    
    // MARK: - UI
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = UIColor(colorLiteralRed: 157.0 / 255.0, green: 157.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
        return label
    }()
    
    var backgroundImageView: UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "unavailable1")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }

}
