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
}
