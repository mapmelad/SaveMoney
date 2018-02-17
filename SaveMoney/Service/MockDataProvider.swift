//
//  MockDataProvider.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Timepiece
import UIKit

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

final class ExpenseMockDataProvider {
    static let shared = ExpenseMockDataProvider()
    
    // MARK: - Members
    
    var categories = [String]()
    
    var monthBudget = 10_000
    var leftBudget = 5_000
    
    // MARK: - Getters
    
    var itemCount: Int { return self.spends.count }
    
    var todaySpends: [Expense] { return self.spends.last!.value }
    
    func addSpend(_ spend: Expense) {
        log.debug("before - \(self.expenses.count)")
        self.expenses.append(spend)
        NotificationCenter.default.post(name: Notification.Name("shouldReloadTable"), object: nil)
        log.debug("after - \(self.expenses.count)")
    }
    
    func spendHeader(for day: Int) -> String { return self.spends[day].key }
    
    func spends(in day: Int) -> [Expense] { return self.spends[day].value }
    
    func totalSpent(in day: Int) -> Int { return self.spends(in: day).reduce(Int(0)) { $0 + $1.amount } }
    
    func spendsCount(in day: Int) -> Int { return self.spends(in: day).count }
    
    // MARK: - Private
    
    private lazy var expenses: [Expense] = { mockCurrentYear() }()
    
    private var spends: [(key: String, value: [Expense])] {
        let grouped = expenses.group(by: { $0.header })
        let sorted = Array(grouped.sorted(by: { $0.value[0].date < $1.value[0].date }))
        
        log.debug("spends count - \(sorted.count)")
        
        return sorted.reversed()
    }
    
    private func mockLastYearData() -> [Expense] {
        var spends = [Expense]()
        
        let startDate = Date()
        let endDate = Date()
        
        for dayIdx in 1...31 {
            let spendsCount = Int(arc4random_uniform(10)) + 1
            
            var localSpends = [Expense]()
            
            for spendIdx in 1..<spendsCount {
                let amount = Int(arc4random_uniform(12_000))
                let category = categories.randomElement
                let id = Int(arc4random())
                
                let hour = Int(arc4random_uniform(24 + 1))
                let minute = Int(arc4random_uniform(60))
                let date = Date(year: 2_017, month: 12, day: dayIdx, hour: hour, minute: minute, second: minute) // Date(year: 2017, month: 12, day: dayIdx)
                
                let expense = Expense(id: id, amount: amount, category: category, date: date)
                
                localSpends.append(expense)
            }
            let sorted = localSpends.sorted(by: { $0.date < $1.date })
            spends.append(contentsOf: sorted)
        }
        
        return spends
    }
    
    private func mockCurrentYear() -> [Expense] {
        var spends = mockLastYearData()
        // var spends = [Expense]()
        
        for monthIdx in 1...2 {
            for dayIdx in 1...31 {
                
                if monthIdx > 2 { break }
                if monthIdx == 2 { if dayIdx > Date().day { break } }
                
                let spendsCount = Int(arc4random_uniform(10)) + 1
                
                var localSpends = [Expense]()
                
                for spendIdx in 1..<spendsCount {
                    let amount = Int(arc4random_uniform(12_000))
                    let category = categories.randomElement
                    let id = Int(arc4random())
                    
                    let hour = Int(arc4random_uniform(24 + 1))
                    let minute = Int(arc4random_uniform(60))
                    let date = Date(year: 2_018, month: monthIdx, day: dayIdx, hour: hour, minute: minute, second: minute)
                    
                    let expense = Expense(id: id, amount: amount, category: category, date: date)
                    
                    localSpends.append(expense)
                }
                let sorted = localSpends.sorted(by: { $0.date < $1.date })
                spends.append(contentsOf: sorted)
            }
        }
        
        return spends.sorted(by: { $0.date > $1.date })
    }
}
