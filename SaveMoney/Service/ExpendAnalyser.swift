//
//  ExpendAnalyser.swift
//  SaveMoney
//
//  Created by Evgeniy on 18.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

protocol IExpendAnalyser: class {
    func analyse(_ expends: [Expense]) -> (spent: Double, category: String)
}

final class ExpendAnalyser: IExpendAnalyser {

    static let shared = ExpendAnalyser()

    func analyse(_ expends: [Expense]) -> (spent: Double, category: String) {
        let grouped = expends.group(by: { $0.category })
        let sorted = Array(grouped.sorted(by: { $0.value.count > $1.value.count }))

        let topSpent = sorted[0]
        let spentInMost = expenseService.totalSpent(with: topSpent.value)
        let percent = (Double(spentInMost) / Double(expenseService.monthBudget)) * 100

        return (percent.rounded(), topSpent.key)
    }

    private let expenseService: IExpenseService = ExpenseService.shared
}
