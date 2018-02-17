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
    
    let years = mockYears()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        
        let year = mockYears().first!
        
        for m in year.months {
            for d in m.days {
                for s in d.spendings {
                    log.debug("did spend \(s.amount) in \(s.cat) at \(d.day) - \(m.mon) - \(year.year)")
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    private let historyHeaderReuseId = "histHeader"
    
    private let historyCellReuseId = "histCell"
    
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
        let size = CGSize(width: Device.width, height: 128)
        
        return size
    }
}

extension HistoryController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdviceCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.cardView.layer.cornerRadius = 6
        cell.advice = "some advice - \(indexPath.row)"
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
    
}

extension HistoryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var c = 0
        for y in self.years { for m in y.months { c += m.days.count } }
        
        return c
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = section / 31
        
        return self.years[0].months[month].days[section % 31].spendings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        
        let month = section / 31
        let item = years[0].months[month].days[section % 31].spendings[row]
        
        cell.category = item.cat
        cell.date = item.comment
        cell.amount = Int(item.amount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        cell.date = "Date - \(section)"
        
        return cell
    }
}
