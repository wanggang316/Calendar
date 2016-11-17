
//
//  DateCenter.swift
//  Calendar
//
//  Created by wanggang on 16/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

/**
 basic extension
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
 convince get
 */
public extension Date {
    /**
     First Date of the assigned month
     
     - paramter month: `Date` type
     */
    public static func firstDate(ofMonth month: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: month)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    /**
     First Date of the assigned month.
     
     - parameter month: `Date` type, the date must contain correct year, month, day value.
     - returns:
     */
    public static func lastDate(ofMonth month: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: month)
        components.month = components.month! + 1
        components.day = 0
        return calendar.date(from: components)!
    }
    
    /**
     First date of the assigned weekday.
     
     - parameter weekday:
     
     - returns: ...
     */
    public static func lastDate(ofWeekday weekday: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: weekday)
        components.day = components.day! - weekday.weekday + 1
        return calendar.date(from: components)!
    }
    
}

/** 
 judge extention
 */
public extension Date {
    
    public func isToday() -> Bool {
        return self.compare(to: Date(), granularity: .day) == .orderedSame
    }
    
    public func isWeekend() -> Bool {
        let calendar = Calendar.current
        let weekdayRange = calendar.maximumRange(of: .weekday)
        let weekday = calendar.component(.weekday, from: self)
        
        if let range = weekdayRange {
            if weekday == range.lowerBound || weekday == range.count {
                return true
            }
        }
        return false
    }
    
    public func isSameDay(_ date: Date) -> Bool {
        return self.compare(to: date, granularity: .day) == .orderedSame
    }
    
    public func isSameMonth(_ date: Date) -> Bool {
        return self.compare(to: date, granularity: .month) == .orderedSame
    }
    
    public func isSameYear(_ date: Date) -> Bool {
        return self.compare(to: date, granularity: .year) == .orderedSame
    }
    
    
    public func compare(to date: Date, granularity: Calendar.Component) -> ComparisonResult {
        let calendar = Calendar.current
        return calendar.compare(self, to: date, toGranularity: granularity)
    }
}


/**
 count extension
 */
public extension Date {
    public static func days(ofMonth month: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month)
        return range?.count ?? 0
    }
    
    public static func days(fromMonth: Date, toMonth: Date) -> Int {
        let firstDate = Date.firstDate(ofMonth: fromMonth)
        let lastDate = Date.lastDate(ofMonth: toMonth)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: firstDate, to: lastDate)
        return components.day! + 1
    }
    
    public static func nights(fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day!
    }
}


/**
 extension for IndexPath
 */
extension Date {
    
    static func date(forFirstDayInSection day: Date, firstDate: Date) -> Date? {
        return nil
    }
    
    static func date(at indexPath: IndexPath, firstDate: Date) -> Date? {
        return nil
    }
    
    static func indexPath(forDate date: Date, firstDate: Date) -> IndexPath? {
        return nil
    }
}
