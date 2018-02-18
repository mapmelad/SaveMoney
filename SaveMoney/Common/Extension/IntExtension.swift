//
//  IntExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

extension Int {
    var asString: String { return String(self) }
    
    var amountFormat: String {
        let formatter = NumberFormatter()
        let v = self as NSNumber
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.alwaysShowsDecimalSeparator = false
        formatter.generatesDecimalNumbers = false
        formatter.maximumFractionDigits = 0
        
        let str = formatter.string(from: v)!
        
        return str.replacingOccurrences(of: ", 00", with: "")
    }
}
