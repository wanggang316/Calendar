//
//  PriceDate.swift
//  Calendar
//
//  Created by wanggang on 30/12/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import Foundation

struct PriceDates {
    let goodsID: Int
    let startDate: Date
    let endDate: Date
    
    let dates: Set<PriceDate>?
    
    init?(_ dictioanry: [String: Any]?) {
        guard let dictionary = dictioanry else { return nil }
        self.goodsID = dictionary["offer_id"] as? Int ?? -1
        
        let format = DateFormatter()
        format.timeZone = TimeZone(abbreviation: "UTC")
        format.dateFormat = "yyyy-MM-dd"
        
        guard let startString = dictionary["start_date"] as? String, let startDate = format.date(from: startString) else { return nil }
        self.startDate = startDate
    
        guard let endString = dictionary["end_date"] as? String, let endDate = format.date(from: endString) else { return nil }
        self.endDate = endDate
        
        self.dates = PriceDate.priceDates(dictionary["dates"] as? [[String : Any]])
    }
}

struct PriceDate: Hashable {

    let date: Date
    let available: Bool
    let price: Float
    
    init(date: Date, available: Bool, price: Float) {
        self.date = date
        self.available = available
        self.price = price
    }
    
    init?(_ dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        
        let format = DateFormatter()
        format.timeZone = TimeZone(abbreviation: "UTC")
        format.dateFormat = "yyyy-MM-dd"
        
        guard let dateString = dictionary["date"] as? String, let date = format.date(from: dateString) else { return nil }
        
        self.date = date
        self.available = dictionary["available"] as? Bool ?? false
        self.price = dictionary["price"] as? Float ?? 0
    }
    
    static func priceDates(_ jsonArray: [[String: Any]]?) -> Set<PriceDate>? {
        guard let jsonArray = jsonArray else { return nil }
        
        var result = Set<PriceDate>()
        
        for dic in jsonArray {
            if let date = PriceDate(dic) {
                result.update(with: date)
            }
        }
        return result
    }
    
    public var hashValue: Int {
        return Int(date.timeIntervalSince1970)
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: PriceDate, rhs: PriceDate) -> Bool {
        return lhs.date.timeIntervalSince1970 == rhs.date.timeIntervalSince1970
    }
}
