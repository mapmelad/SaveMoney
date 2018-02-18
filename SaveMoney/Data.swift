//
//  Data.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation
import UIKit

struct Year {
    let year: Int
    let months: [Month]
}

struct Month {
    let mon: Int
    let days: [Day]
}

struct Day {
    let day: Int
    let spendings: [Expense]
}

struct Expense {
    let amount: Double
    let cat: String
    let comment: String
}

let comments = ["cmnt1", "cmnt2", "cmnt3", "cmnt4"]
let cats = ["c1", "c2", "c3", "c4"]

extension Array {
    var randomElement: Element {
        let randomElem = Int(arc4random_uniform(UInt32(self.count)))
        
        return self[randomElem]
    }
}

func mockExpenses() -> [Expense] {
    let count = Int(arc4random_uniform(12))
    let randomNum = Double(arc4random()) + 10
    
    var expenses = [Expense]()
    
    for i in 0..<count {
        let expense = Expense(amount: 1.1 * (randomNum + Double(i)), cat: cats.randomElement, comment: comments.randomElement)
        
        expenses.append(expense)
    }
    
    return expenses
}

func mockDays() -> [Day] {
    var days = [Day]()
    
    for i in 1..<32 {
        let randomNum = Int(arc4random()) + 10
        let expenses = mockExpenses()
        
        let day = Day(day: i, spendings: expenses)
        days.append(day)
    }
    
    return days
}

func mockMonths() -> [Month] {
    var months = [Month]()
    
    for i in 1..<13 {
        let days = mockDays()
        let month = Month(mon: i, days: days)
        
        months.append(month)
    }
    
    return months
}

func mockYears() -> [Year] {
    var years = [Year]()
    
    for i in 2017..<2019 {
        let months = mockMonths()
        let year = Year(year: i, months: months)
        
        years.append(year)
    }
    
    return years
}

let years = mockYears()

