//
//  Expense.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

struct Expense {
    let id: Int

    let amount: Int
    let category: String
    let date: Date

    var header: String {
        let humanMonth = getRussianMonth(self.date.month)

        return "\(self.date.day) \(humanMonth)"
    }
}

extension Expense: Equatable {
    static func ==(lhs: Expense, rhs: Expense) -> Bool { return lhs.id == rhs.id }
}
