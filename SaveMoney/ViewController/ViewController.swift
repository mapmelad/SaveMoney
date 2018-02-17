//
//  ViewController.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var spendAmountTextField: UITextField!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var monthBudgetLabel: UILabel!
    
    @IBOutlet var todayBudget: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMockDataProvider()
        setupScreen()
        setupBindings()
    }
    
    private func setupMockDataProvider() {
        expenseService.categories = categories
        expenseService.randomizeData()
    }
    
    private func setupScreen() {
        setupContainers()
        updateBalance()
    }
    
    private func updateBalance() {
        updateMonthBudget()
        updateDayBudget()
    }
    
    private func setupContainers() { setupKeyboardContainer() }
    
    private func setupKeyboardContainer() { spendAmountTextField.delegate = self }
    
    // MARK: - Members
    
    var oldCellIndex = IndexPath(row: -1, section: -1)
    
    private let categories = ["Общее 💁‍♂️", "Транспорт 🚎", "Бары 🍻", "Кафе 🍟", "Одежда 👟", "Сотовая связь 📱", "Дом 🏡"]
    
    private let expenseService: IExpenseService = ExpenseService.shared
    
    // MARK: - Setup
    
    private func onKeyboardTap(_ idx: Int) { spendAmountTextField.append(idx) }
    
    private func onDeleteButtonTap() { spendAmountTextField.deleteChar() }
    
    private func updateTipsTextField(_ currentText: String) {}
}

private extension ViewController {
    private func setupBindings() {
        bindTipsAmount()
        bindKeyboardTaps()
        bindKeyboardDelete()
        bindAddButton()
    }
    
    private func bindMoneyLeft() {}
    
    private func updateMonthBudget() {
        let d = Date()
        let lastDay = 30 - d.day
        monthBudgetLabel.text = "\(expenseService.leftBudget)₽ на \(lastDay) дней"
        // Посчитать все сегодняшние расходы и вычесть из dataProvider.monthLateBudget
    }
    
    private func updateDayBudget() {
        let d = Date()
        let lastDay = 30 - d.day
        let lastMoney = expenseService.leftBudget / lastDay
        // Посчитать все сегодняшние расходы и вычесть из dataProvider.monthLateBudget / lastDay
        todayBudget.text = "\(lastMoney)₽"
    }
    
    private func bindAddButton() {
        addButton.rx.tap.next { [unowned self] in
            if self.oldCellIndex.row == -1 {
                self.errorLabel.isHidden = false
            } else {
                self.errorLabel.isHidden = true
                self.addExpense()
            }
        }
    }
    
    private func addExpense() {
        if let cell = collectionView.cellForItem(at: oldCellIndex) as? CategoryCollectionViewCell,
            let spentText = spendAmountTextField.text,
            let amount = spentText.amount,
            let category = cell.title.text {
            
            let spend = Expense(id: Int(arc4random()), amount: amount, category: category, date: Date())
            expenseService.addExpense(spend)
            
            spendAmountTextField.text = "Потрачено " + spentText
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: { [unowned self] in
                self.spendAmountTextField.text = " ₽"
                self.updateBalance()
            })
        }
    }
    
    private func bindTipsAmount() {
        spendAmountTextField.rx.text
            .unwrap()
            .distinct()
            .filter { !$0.isEmpty }
            .next { [unowned self] newValue in
                self.updateTipsTextField(newValue)
            }
    }
    
    private func bindKeyboardTaps() {
        let tagsCount = 11
        
        for i in 1..<tagsCount {
            if let v = view.viewWithTag(i) as? UIButton {
                v.rx.tap.next { [unowned self] in
                    self.onKeyboardTap(i - 1)
                }
            }
        }
    }
    
    private func bindKeyboardDelete() {
        deleteButton.rx.tap.next { [unowned self] _ in
            self.onDeleteButtonTap()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return false }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categories[indexPath.row].size(OfFont: UIFont.systemFont(ofSize: 17.0)).width + 15.0, height: 30)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return categories.count }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
        
        if indexPath == oldCellIndex {
            cell.bgView.backgroundColor = UIColor(red: 0.98, green: 0.51, blue: 0.12, alpha: 1.0)
        } else {
            cell.bgView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
        }
        
        cell.title.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            selectedCell.bgView.backgroundColor = UIColor(red: 0.98, green: 0.51, blue: 0.12, alpha: 1.0)
            
            if let oldCell = collectionView.cellForItem(at: oldCellIndex) as? CategoryCollectionViewCell {
                oldCell.bgView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
            }
            
            oldCellIndex = indexPath
        }
        
        /* let oldCell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(at: IndexPath(row:cellIndex, section: 0))
         let newCell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
         
         oldCell.bgView.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
         newCell.bgView.backgroundColor = UIColor(red:0.98, green:0.51, blue:0.12, alpha:1.0)
         print(cellIndex, indexPath.row)
         cellIndex = indexPath.row */
        
    }
}

extension ObservableType {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     
     - returns: An observable sequence of non-optional elements
     */
    public var ignoreNil: RxSwift.Observable<Self.E> { return flatMap { Observable.from(optional: $0) } }
}
