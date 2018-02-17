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
    
    var leftBudget: Int { get set }
    
    var displayModel: [HistorySection] { get }
    
    var sectionCount: Int { get }
}

final class ExpenseService: IExpenseService {
    // MARK: - Instance
    
    static let shared = ExpenseService()
    
    // MARK: - IExpenseDataProvider
    
    // MARK: Methods
    
    func randomizeData() { allItems = dataProvider.mockData() }
    
    func addExpense(_ e: Expense) { allItems.append(e); postUpdateNotification() }
    
    func totalSpent(with spends: [Expense]) -> Int { return spends.reduce(Int(0), { $0 + $1.amount }) }
    
    // MARK: Members
    
    var categories = [String]() { didSet { dataProvider.categories = categories } }
    
    var monthBudget = 10_000
    
    var leftBudget = 5_000
    
    var displayModel = [HistorySection]()
    
    var sectionCount: Int { return displayModel.count }
    
    // MARK: - Private
    
    private let dataProvider: IDataProvider = MockDataProvider([])
    
    private var allItems = [Expense]() { didSet { updateDisplayModel(allItems) } }
    
    // MARK: - Methods
    
    private func updateDisplayModel(_ spends: [Expense]) {
        displayModel = spends.reduce([]) { (grouped: [HistorySection], item: Expense) in
            if let gi = grouped.first(where: { $0.header == item.header }) {
                gi.spends.append(item)
                
                return grouped
            }
            return grouped + [HistorySection(item)]
        }
        
        displayModel.sort(by: { $0.date > $1.date })
    }
    
    private func postUpdateNotification() { NotificationCenter.default.post(name: Notification.Name("shouldReloadTable"), object: nil) }
}
