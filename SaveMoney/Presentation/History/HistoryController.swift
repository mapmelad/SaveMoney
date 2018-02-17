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
        //cell.advice = "some advice - \(indexPath.row)"
        
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

final class Box<A> {
    var value: A
    init(_ val: A) {
        value = val
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key, val) in categories {
            result[key] = val.value
        }
        
        return result
    }
}

extension HistoryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = datasource.group(by: { $0.header }).count
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = section / 31
        let item = datasource[section]
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        
        let month = section / 31
        let item = datasource[0] // years[0].months[month].days[section % 31].spendings[row]
        
        cell.category = item.category
        cell.date = item.header
        cell.amount = item.amount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        cell.date = "17 февраля"
        
        return cell
    }
}
