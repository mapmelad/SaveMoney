//
//  HistorySection.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

struct HistorySection {
    let header: String
    let date: Date
    var spends: [Expense]

    init(_ expense: Expense) {
        self.header = expense.header
        self.date = expense.date
        self.spends = [expense]
    }
}
