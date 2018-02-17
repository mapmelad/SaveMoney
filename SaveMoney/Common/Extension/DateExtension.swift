//
//  DateExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

public extension Date {
    public func monthIn(_ date: Date) -> Bool {
        return year == date.year &&
            month == date.month
    }
    
    var today: Date { return Date() }
    
    var inCurrentMonth: Bool {
        return year == today.year &&
            month == today.month
    }
    
    var inCurrentDay: Bool {
        return year == today.year &&
            month == today.month &&
            day == today.day
    }
    
    static var today: Date { return Date() }
    
    static var daysInThisMonth: Int {
        let td = Date()
        let lastDay = Date(year: td.year, month: td.month + 1, day: 1).addingTimeInterval(-(60 * 60))
        
        return lastDay.day
    }
    
    static var daysLeftThisMonth: Int {
        let td = Date()
        let lastDay = Date(year: td.year, month: td.month + 1, day: 1).addingTimeInterval(-(60 * 60))
        
        return lastDay.day - td.day
    }
}
