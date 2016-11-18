//
//  Date+Compare.swift
//  Calendar
//
//  Created by wanggang on 18/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation


/**
 judge extention
 */
public extension Date {
    
    public func isToday() -> Bool {
        return self.compare(to: Date(), granularity: .day) == .orderedSame
    }
    
    public func isWeekend() -> Bool {
        let calendar = Date.gregorianCalendar
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
    
    /// Greater than
    public func gt(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) == .orderedDescending
    }
    
    /// Greater than or equal
    public func ge(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) != .orderedAscending
    }
    
    /// Less than
    public func lt(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) == .orderedAscending
    }
    
    /// Less than or equal
    public func le(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) != .orderedDescending
    }
    
    /// Equal
    public func eq(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) == .orderedSame
    }
    
    /// Not equal
    public func ne(_ date: Date,  granularity: Calendar.Component) -> Bool {
        return self.compare(to: date, granularity: granularity) != .orderedSame
    }
    
    
    public func compare(to date: Date, granularity: Calendar.Component) -> ComparisonResult {
        let calendar = Date.gregorianCalendar
        return calendar.compare(self, to: date, toGranularity: granularity)
    }
    
    
    
}
