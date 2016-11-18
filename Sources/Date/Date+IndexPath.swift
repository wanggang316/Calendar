//
//  Date+IndexPath.swift
//  Calendar
//
//  Created by wanggang on 18/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation




/**
 extension for IndexPath
 */
extension Date {
    
    static func firstDate(in section: Int, from date: Date) -> Date? {
        let calendar = Date.gregorianCalendar
        var components = DateComponents()
        components.month = section
        return calendar.date(byAdding: components, to: date.firstDateOfMonth())
    }
    
    static func date(at indexPath: IndexPath, from date: Date) -> Date? {
        
        let firstDateInSeciton = Date.firstDate(in: indexPath.section, from: date)
        
        if let firstDateInSeciton = firstDateInSeciton {
            
            let weekday = firstDateInSeciton.weekday
            
            guard indexPath.row >= (weekday - 1) && indexPath.row <= (weekday - 1 + Date.days(of: firstDateInSeciton) - 1) else { return nil }
            
            let calendar = Date.gregorianCalendar
            var components = calendar.dateComponents([.month, .day], from: firstDateInSeciton)
            components.day = indexPath.row - (weekday - 1)
            components.month = indexPath.section
            
            return calendar.date(byAdding: components, to: date.firstDateOfMonth())
        }
        return nil
    }
    
    static func indexPath(forDate date: Date, from fromDate: Date) -> IndexPath? {
        
        let firstDateOfMonth = date.firstDateOfMonth()
        
        let section = (date.year - fromDate.year) * 12 + date.month - fromDate.month
        let index = firstDateOfMonth.weekday + date.day - 2
        return IndexPath(item: index, section: section)
    }
    
    
    // MARK: - count
    static func numberOfItems(in section: Int, from date: Date) -> Int {
        let firstDateInSection = Date.firstDate(in: section, from: date)
        if let firstDateInSection = firstDateInSection {
            let weekdayIndex = firstDateInSection.weekday - 1
            
            let lastDateOfMonth = firstDateInSection.lastDateOfMonth()
            let lastDateWeekdayIndex = lastDateOfMonth.weekday
            
            let count = weekdayIndex + Date.days(of: firstDateInSection) + 7 - lastDateWeekdayIndex
            return count
        }
        return 0
    }
}
