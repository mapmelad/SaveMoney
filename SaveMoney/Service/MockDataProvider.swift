//
//  MockDataProvider.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

protocol IDataProvider: class {
    func mockData() -> [Expense]
    
    var categories: [String] { get set }
}

final class MockDataProvider: IDataProvider {
    init(_ cats: [String]) { categories = cats }
    
    // MARK: - IDataProvider
    
    func mockData() -> [Expense] { return mockCurrentYear() }
    
    var categories: [String]
    
    // MARK: - Private
    
    // MARK: - Members
    
    private let maxSpend: UInt32 = 200
    
    // MARK: - Mock
    
    private func mockLastYearData() -> [Expense] {
        var spends = [Expense]()
        
        for dayIdx in 1...31 {
            let spendsCount = Int(arc4random_uniform(10)) + 1
            
            var localSpends = [Expense]()
            
            for spendIdx in 1..<spendsCount {
                let amount = Int(arc4random_uniform(maxSpend))
                let category = categories.randomElement
                let id = Int(arc4random())
                
                let hour = Int(arc4random_uniform(24 + 1))
                let minute = Int(arc4random_uniform(60))
                let date = Date(year: 2_017, month: 12, day: dayIdx, hour: hour, minute: minute, second: minute)
                
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
        
        for monthIdx in 1...2 {
            for dayIdx in 1...31 {
                
                if monthIdx > 2 { break }
                if monthIdx == 2 { if dayIdx > Date().day { break } }
                
                let spendsCount = Int(arc4random_uniform(3)) + 1
                
                var localSpends = [Expense]()
                
                for spendIdx in 1..<spendsCount {
                    let amount = Int(arc4random_uniform(maxSpend))
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
