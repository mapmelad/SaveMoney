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

final class HistoryController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var adviceCollectionView: UICollectionView!
    @IBOutlet var historyTableView: UITableView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    private let historyHeaderReuseId = "histHeader"
    
    private let historyCellReuseId = "histCell"
    
    private let dataProvider = ExpenseMockDataProvider.shared
    
    private let datasource = ExpenseMockDataProvider.shared.spends
    
    // MARK: - Methods
    
    private func setupScreen() {
        setupContainers()
    }
    
    private func setupContainers() {
        setupHistoryContainer()
    }
    
    private func setupHistoryContainer() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.tableFooterView = UIView()
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdviceCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.cardView.layer.cornerRadius = 6
        // cell.advice = "some advice - \(indexPath.row)"
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard historyTableView != scrollView else { return }
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        var factor: CGFloat = 0.75
        if velocity.x < 0 {
            factor = -factor
        }
        let indexPath = IndexPath(row: Int((scrollView.contentOffset.x / Device.width + factor)), section: 0)
        
        adviceCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 37 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        
        cell.date = dataProvider.spendHeader(for: section)
        cell.totalSpent = dataProvider.totalSpent(in: section)
        
        return cell
    }
}

extension HistoryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return dataProvider.itemCount }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return dataProvider.spendsCount(in: section) }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        
        let item = dataProvider.spends(in: section)[row]
        let date = item.date
        let min = date.minute
        let humanMinute = min < 10 ? "0\(min)" : "\(min)"
        
        cell.category = item.category
        cell.date = "\(date.hour):\(humanMinute)"
        cell.amount = item.amount
        
        return cell
    }
}
