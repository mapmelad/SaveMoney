//
//  HistoryController.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

struct Advice {
    let titleAdvice: String
    let textAdvice: String
}

final class HistoryController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var adviceCollectionView: UICollectionView!
    @IBOutlet var historyTableView: UITableView!
    
    // MARK: - Overrides
    private let expendAnalyser: IExpendAnalyser = ExpendAnalyser.shared
    var advices = [Advice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupAdvice()
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated) }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    private let historyHeaderReuseId = "histHeader"
    
    private let historyCellReuseId = "histCell"
    
    private let expenseService: IExpenseService = ExpenseService.shared
    
    private var displayModel: [HistorySection] { return expenseService.displayModel }
    
    // MARK: - Methods
    
    private func setupScreen() {
        observeNewSpends()
        setupContainers()
    }
    
    private func setupAdvice() {
        advices.removeAll()
        let topSpent = expendAnalyser.analyse(expenseService.thisMonthSpends)
        let topCategory = expendAnalyser.averagePerCategory()
        advices.append(Advice(titleAdvice: "😱😱😱", textAdvice: "Мы заметили что на \(topSpent.category) ты тратишь \(topSpent.spent) % своего месячного бюджета. Попробуй сократить свой рассход."))
        advices.append(Advice(titleAdvice: "✈️⛅️🌴", textAdvice: "Впереди майские праздники. Отличный повод начать экономить сейчас, как следует отдохнуть. Попробуй сократить свои расходы по категориям \(Array(topCategory.keys)[0]) и \(Array(topCategory.keys)[1])."))
    }
    
    private func observeNewSpends() { NotificationCenter.default.addObserver(self, selector: #selector(onNewSpend(_:)), name: Notification.Name("shouldReloadTable"), object: nil) }
    
    private func setupContainers() {
        setupHistoryContainer()
    }
    
    private func setupHistoryContainer() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.tableFooterView = UIView()
    }
    
    @objc
    private func onNewSpend(_ notification: Any) {
        setupAdvice()
        historyTableView.reloadData()
        adviceCollectionView.reloadData()
    }
}

extension HistoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let size = CGSize(width: Device.width - 16 - 16, height: 128)
        let size = CGSize(width: Device.width, height: 168)
        
        return size
    }
}

extension HistoryController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return advices.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdviceCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.cardView.layer.cornerRadius = 6
        cell.titleAdviceLabel.text = advices[indexPath.row].titleAdvice
        cell.adviceLabel.text = advices[indexPath.row].textAdvice
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard historyTableView != scrollView else { return }
        
        targetContentOffset.pointee = scrollView.contentOffset
        let factor: CGFloat = velocity.x < 0 ? -0.75 : 0.75
        let indexPath = IndexPath(row: Int((scrollView.contentOffset.x / Device.width + factor)), section: 0)
        
        adviceCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 37 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        let section = displayModel[section]
        
        cell.date = section.header
        cell.totalSpent = expenseService.totalSpent(with: section.spends)
        
        return cell
    }
    
}

extension HistoryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return displayModel.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return displayModel[section].spends.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        
        let item = displayModel[section].spends[row]
        let date = item.date
        let min = date.minute
        let humanMinute = min < 10 ? "0\(min)" : "\(min)"
        
        cell.category = item.category
        cell.date = "\(date.hour):\(humanMinute)"
        cell.amount = item.amount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Category", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        
        let row = indexPath.row
        let section = indexPath.section
        
        let item = displayModel[section].spends[row]
        vc.passedExpense = item
        
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
}
