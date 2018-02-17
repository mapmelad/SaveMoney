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
        let sorted = sortedGrouped(expends)
        let topSpent = sorted[0]
        let spentInMost = expenseService.totalSpent(with: topSpent.value)

        let percent = (Double(spentInMost) / Double(expenseService.monthBudget)) * 100

        return (percent.rounded(), topSpent.key)
    }

    func averagePerCategory() -> [String: Int] {
        let expends = expenseService.allItems
        let grouped = expends.group(by: { $0.category })
        var samples = [String: [Int: Int]]()

        for elem in grouped {
            let monthGrouped = elem.value.group(by: { $0.date.month })

            var perMonth = [Int: Int]()
            for melem in monthGrouped { perMonth[melem.key] = expenseService.totalSpent(with: melem.value) }

            samples[elem.key] = perMonth
        }

        var ret = [String: Int]()

        for cat in samples {
            var avgPerMonth = 0
            for month in cat.value { avgPerMonth += month.value }
            avgPerMonth /= cat.value.keys.count

            ret[cat.key] = avgPerMonth
        }

        return ret
    }

    // MARK: - Private

    private func sortedGrouped(_ expends: [Expense]) -> [(key: String, value: [Expense])] {
        let grouped = expends.group(by: { $0.category })
        return Array(grouped).sorted { expenseService.totalSpent(with: $0.value) > expenseService.totalSpent(with: $1.value) }
    }

    private let expenseService: IExpenseService = ExpenseService.shared
}
