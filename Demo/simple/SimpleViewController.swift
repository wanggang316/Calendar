//
//  SimpleViewController.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit
import Calendar

class SimpleViewController: UIViewController {
    
    var calendarView: CalendarView = {
        let cal = CalendarView()
        cal.minimumLineSpacing = 1
        cal.minimumInteritemSpacing = 1
        cal.contentInset = UIEdgeInsets(top: 64 + 10, left: 10, bottom: 10, right: 10)
        cal.minimumWeekAndDateItemSpacing = 10
        cal.weekViewHeight = 50
        cal.register(SimpleDateCell.self, forCellWithReuseIdentifier: "cell")
        return cal
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.calendarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.calendarView.dataSource = self
        self.view.addSubview(self.calendarView)
        
        let date = Date.distantPast
        let date1 = Date.distantFuture
        let gt = date < date1
        
        print(gt)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SimpleViewController: CalendarDataSource {
    
    func calendarView(_ calendarView: CalendarView, cell: CalendarDayCell, forDay date: Date?) {
        let scell = cell as! SimpleDateCell
        
        if let date = date {
            if date.isToday() {
                scell.textLabel?.text = "Today"
                scell.textLabel?.textColor = UIColor.darkGray
            } else if (date.lt(calendarView.fromDate, granularity: .day) || date.gt(calendarView.toDate, granularity: .day)) {
                scell.textLabel?.text = String(date.day)
                scell.textLabel?.textColor = UIColor.lightGray
            } else {
                scell.textLabel?.text = String(date.day)
                scell.textLabel?.textColor = UIColor.darkGray
            }
        }
        
        //scell.title = "-----"
    }
    
}
