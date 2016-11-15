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
        cal.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cal
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.calendarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.calendarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
