//
//  MockDataProvider.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Timepiece
import UIKit

protocol IExpenseService: class {
    // MARK: Methods
    
    func randomizeData()
    
    func addExpense(_ e: Expense)
    
    func totalSpent(with spends: [Expense]) -> Int
    
    // MARK: Members
    
    var categories: [String] { get set }
    
    var monthBudget: Int { get set }
    
    var leftMonthBudget: Int { get }
    
    var leftDayBudget: Int { get }
    
    var daysInMonth: Int { get }
    
    var daysLeftThisMonth: Int { get }
    
    var displayModel: [HistorySection] { get }
    
    var sectionCount: Int { get }
}

final class ExpenseService: IExpenseService {
    // MARK: - Instance
    
    static let shared = ExpenseService()
    
    // MARK: - IExpenseDataProvider
    
    // MARK: Methods
    
    func randomizeData() { allItems = dataProvider.mockData() }
    
    func addExpense(_ e: Expense) {
        allItems.insert(e, at: 0)
        postUpdateNotification()
    }
    
    func totalSpent(with spends: [Expense]) -> Int { return spends.reduce(Int(0), { $0 + $1.amount }) }
    
    // MARK: Members
    
    var categories = [String]() { didSet { dataProvider.categories = categories } }
    
    var monthBudget = 10_000
    
    var leftMonthBudget: Int { return monthBudget - spentInThisMonth }
    
    var leftDayBudget: Int { return maxTodayBudget - spentThisDay }
    
    var daysInMonth: Int { return Date.daysInThisMonth }
    
    var daysLeftThisMonth: Int { return Date.daysLeftThisMonth }
    
    var displayModel = [HistorySection]()
    
    var sectionCount: Int { return displayModel.count }
    
    // MARK: - Private
    
    private var maxTodayBudget: Int { return spentThisMonthBeforeToday / daysLeftThisMonth }
    
    private var spentThisMonthBeforeToday: Int { return spentInThisMonth - spentThisDay }
    
    private var spentThisDay: Int {
        let thisMonthSpends = allItems.filter { $0.date.monthIn(Date.today) }
        let thisDay = thisMonthSpends.filter { $0.date.inCurrentDay }
        
        return totalSpent(with: thisDay)
    }
    
    private var allItems = [Expense]() { didSet { updateDisplayModel(allItems) } }
    
    private var spentInThisMonth: Int {
        let thisMonthSpends = allItems.filter { $0.date.inCurrentMonth }
        
        return totalSpent(with: thisMonthSpends)
    }
    
    private let dataProvider: IDataProvider = MockDataProvider([])
    
    // MARK: - Methods
    
    private func updateDisplayModel(_ spends: [Expense]) {
        displayModel = spends.reduce([]) { (grouped: [HistorySection], item: Expense) in
            if let gi = grouped.first(where: { $0.header == item.header }) {
                gi.spends.append(item)
                
                return grouped
            }
            return grouped + [HistorySection(item)]
        }
    }
    
    private func postUpdateNotification() { NotificationCenter.default.post(name: Notification.Name("shouldReloadTable"), object: nil) }
}
