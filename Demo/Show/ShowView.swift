//
//  ShowView.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class ShowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.calendarView)
        self.contentView.addSubview(self.cancelButton)
        self.addSubview(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = CGRect(x: 15, y: 40, width: self.frame.width - 30, height: self.frame.height - 70)
        self.titleLabel.frame = CGRect(x: 25, y: 25, width: 200, height: 20)
        self.calendarView.frame = CGRect(x: 0, y: self.titleLabel.frame.maxY + 17, width: self.contentView.frame.width, height: self.contentView.frame.height - self.titleLabel.frame.maxY - 17 - 55)
        self.cancelButton.frame = CGRect(x: self.contentView.frame.width / 2 - 12, y: self.contentView.frame.height - 15 - 25, width: 25, height: 25)
    }
    
    // MARK: - Action
    func cancelAction() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.alpha = 0.0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - UI
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3.0
        view.clipsToBounds = true
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "可租价格日历"
        return label
    }()
    
    private var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 1
        cal.minimumInteritemSpacing = 1
        cal.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        cal.minimumWeekAndDateItemSpacing = 10
        cal.weekViewHeight = 30
        cal.monthFooterViewHeight = 20
        cal.cellAspectRatio = 100.0 / 140.0
        
        cal.register(ShowDayCell.self)
        cal.register(monthHeader: ShowMonthHeaderView.self)
        cal.register(monthFooter: ShowMonthFooterView.self)
        return cal
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "cancel"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
        return button
    }()

}
