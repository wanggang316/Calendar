//
//  Date+Basic.swift
//  Calendar
//
//  Created by wanggang on 18/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

public extension Date {
    
    public static var gregorianCalendar: Calendar {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        return calendar
    }
    
    /// standard formatter
    public static var formatter: DateFormatter {
        let calendar = Date.gregorianCalendar
        let formatter = DateFormatter()
        formatter.calendar = calendar
        return formatter
    }
    
    public var era: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.era, from: self)
    }
    
    public var year: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.year, from: self)
    }
    
    public var month: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.month, from: self)
    }
    public var day: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.day, from: self)
    }
    
    public var weekday: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.weekday, from: self)
    }
    
    public var hour: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.hour, from: self)
    }
    
    public var minute: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.minute, from: self)
    }
    
    public var second: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.second, from: self)
    }
    
    public var weekdayOrdinal: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.weekdayOrdinal, from: self)
    }
    
    public var quarter: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.quarter, from: self)
    }
    
    public var weekOfMonth: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.weekOfMonth, from: self)
    }
    
    public var weekOfYear: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.weekOfYear, from: self)
    }
    
    public var yearForWeekOfYear: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.yearForWeekOfYear, from: self)
    }
    
    public var nanosecond: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.nanosecond, from: self)
    }
    
    public var calendar: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.calendar, from: self)
    }
    
    public var timeZone: Int {
        let calendar = Date.gregorianCalendar
        return calendar.component(.timeZone, from: self)
    }
}

/**
 convince getters
 */
public extension Date {
    /**
     First Date of the assigned month
     
     - paramter month: `Date` type
     */
    public func firstDateOfMonth() -> Date {
        let calendar = Date.gregorianCalendar
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    /**
     First Date of the assigned month.
     
     - parameter month: `Date` type, the date must contain correct year, month, day value.
     - returns:
     */
    public func lastDateOfMonth() -> Date {
        let calendar = Date.gregorianCalendar
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.month = components.month! + 1
        components.day = 0
        return calendar.date(from: components)!
    }
    
    /**
     First date of the assigned weekday.
     
     - parameter weekday:
     
     - returns: ...
     */
    public func lastDateOfWeekday() -> Date {
        let calendar = Date.gregorianCalendar
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        components.day = components.day! - self.weekday + 1
        return calendar.date(from: components)!
    }
}

