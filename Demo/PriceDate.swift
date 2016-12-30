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
    
    let dates: [PriceDate]?
    
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

struct PriceDate {
    let date: Date
    let available: Bool
    let price: Float
    
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
    
    static func priceDates(_ jsonArray: [[String: Any]]?) -> [PriceDate]? {
        guard let jsonArray = jsonArray else { return nil }
        
        return jsonArray.map { element in
            PriceDate(element)!
        }
    }
}
