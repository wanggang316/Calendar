
//
//  DateCenter.swift
//  Calendar
//
//  Created by wanggang on 16/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

/**
 Date tool box.
 */
public extension Date {
    
    public var era: Int {
        let calendar = Calendar.current
        return calendar.component(.era, from: self)
    }
    
    public var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    public var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    public var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    public var weekday: Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    public var hour: Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    public var minute: Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    
    public var second: Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: self)
    }
    
    public var weekdayOrdinal: Int {
        let calendar = Calendar.current
        return calendar.component(.weekdayOrdinal, from: self)
    }
    
    public var quarter: Int {
        let calendar = Calendar.current
        return calendar.component(.quarter, from: self)
    }
    
    public var weekOfMonth: Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfMonth, from: self)
    }
    
    public var weekOfYear: Int {
        let calendar = Calendar.current
        return calendar.component(.weekOfYear, from: self)
    }
    
    public var yearForWeekOfYear: Int {
        let calendar = Calendar.current
        return calendar.component(.yearForWeekOfYear, from: self)
    }
    
    public var nanosecond: Int {
        let calendar = Calendar.current
        return calendar.component(.nanosecond, from: self)
    }
    
    public var calendar: Int {
        let calendar = Calendar.current
        return calendar.component(.calendar, from: self)
    }
    
    public var timeZone: Int {
        let calendar = Calendar.current
        return calendar.component(.timeZone, from: self)
    }
    
}


/**
 extension for IndexPath
 */
extension NSDate {
    
    class func date(forFirstDayInSection day: Date, firstDate: Date) -> Date? {
        return nil
    }
    
    class func date(at indexPath: IndexPath, firstDate: Date) -> Date? {
        return nil
    }
    
    class func indexPath(forDate date: Date, firstDate: Date) -> IndexPath? {
        return nil
    }
}
