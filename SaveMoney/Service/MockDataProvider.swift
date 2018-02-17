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
        return "\(self.date.day) \(self.date.month)"
    }
}

final class ExpenseMockDataProvider {
    static let shared = ExpenseMockDataProvider()
    
    // MARK: - Members
    
    var categories = [String]()
    
    var monthBudget = 10_000
    var monthLateBudget = 5_000
    
    lazy var spends: [Expense] = { mockData() }()
    
    // MARK: - Private
    
    private func mockData() -> [Expense] {
        var spends = [Expense]()
        
        let startDate = Date()
        let endDate = Date()
        
        for dayIdx in 1...31 {
            let spendsCount = Int(arc4random_uniform(10)) + 1
            
            for spendIdx in 1..<spendsCount {
                let amount = Int(arc4random_uniform(12_000))
                let category = categories.randomElement
                let id = Int(arc4random())
                
                let hour = Int(arc4random_uniform(12 + 1))
                let date = Date(year: 2017, month: 12, day: dayIdx)
                
                let expense = Expense(id: id, amount: amount, category: category, date: date)
                
                spends.append(expense)
            }
        }
        
        return spends
    }
}
