//
//  CategoryViewController.swift
//  SaveMoney
//
//  Created by Semyon on 18.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class CategoryViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var allTimeSpentLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIBarButtonItem!
    
    // MARK: - Member
    
    private let historyHeaderReuseId = "histHeader"
    private let historyCellReuseId = "histCell"
    private let expenseService: IExpenseService = ExpenseService.shared
    
    var passedExpense: Expense!
    
    var _displayModel = [HistorySection]()
    
    private var datasource: [HistorySection] {
        let allItems = expenseService.allItems
        let category = passedExpense.category
        let filtered = allItems.filter { $0.category == category }
        
        var displayModel = [HistorySection]()
        
        displayModel = filtered.reduce([]) { (grouped: [HistorySection], item: Expense) in
            if let gi = grouped.first(where: { $0.date.month == item.date.month && $0.date.year == item.date.year }) {
                gi.spends.append(item)
                
                return grouped
            }
            return grouped + [HistorySection(item)]
        }
        
        displayModel[0].spends.sort(by: { $0.date > $1.date })
        
        return displayModel
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setapNavBar()
        bundBackButton()
    }
    
    // MARK: - Methods
    
    private func setupScreen() {
        updateTotalSpent()
        _displayModel = datasource
    }
    
    private func updateTotalSpent() {
        DispatchQueue.global(qos: .default).async {
            let allItems = self.expenseService.allItems
            let category = self.passedExpense.category
            let filtered = allItems.filter { $0.category == category }
            let totalSpent = self.expenseService.totalSpent(with: filtered)
            DispatchQueue.main.async { self.allTimeSpentLabel.text = "За всё время: " + totalSpent.amountFormat }
        }
    }
    
    // MARK: - Appereance
    
    private func setapNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.80, blue: 0.40, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationItem.title = passedExpense.category
    }
    
    private func bundBackButton() {
        backButton.rx.tap.next { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 37 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        let item = _displayModel[section]
        let totalSpent = expenseService.totalSpent(with: item.spends)
        
        cell.date = month(for: item.spends[0].date.month)
        cell.totalSpentLabel.text = totalSpent.amountFormat
        
        return cell
    }
}

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return _displayModel.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return _displayModel[section].spends.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        cell.selectionStyle = .none
        
        let row = indexPath.row
        let section = indexPath.section
        let item = _displayModel[section].spends[row]
        
        cell.category = item.category
        cell.date = item.header
        cell.amount = item.amount
        
        return cell
    }
}
