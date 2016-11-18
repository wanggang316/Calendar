//
//  Date+Count.swift
//  Calendar
//
//  Created by wanggang on 18/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation


/**
 count extension
 */
public extension Date {
    public static func days(of month: Date) -> Int {
        let calendar = Date.gregorianCalendar
        let range = calendar.range(of: .day, in: .month, for: month)
        return range?.count ?? 0
    }
    
    public static func days(from fromMonth: Date, to toMonth: Date) -> Int {
        let firstDate = fromMonth.firstDateOfMonth()
        let lastDate = toMonth.lastDateOfMonth()
        let calendar = Date.gregorianCalendar
        let components = calendar.dateComponents([.day], from: firstDate, to: lastDate)
        return components.day! + 1
    }
    
    public static func nights(from fromDate: Date, to toDate: Date) -> Int {
        let calendar = Date.gregorianCalendar
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day!
    }
    
    public static func months(from fromMonth: Date, to toMonth: Date) -> Int {
        let calendar = Date.gregorianCalendar
        let components = calendar.dateComponents([.month], from: fromMonth.firstDateOfMonth(), to: toMonth.lastDateOfMonth())
        return components.month! + 1
    }
}
