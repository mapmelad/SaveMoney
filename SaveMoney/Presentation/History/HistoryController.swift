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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - Members
    
    private let historyHeaderReuseId = "histHeader"
    
    private let historyCellReuseId = "histCell"
    
    // MARK: - Methods
}

extension HistoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: Device.width, height: 128)
        
        return size
    }
}

extension HistoryController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdviceCell = collectionView.dequeueReusableCell(at: indexPath)
        
        return cell
    }
}

extension HistoryController: UITableViewDelegate {
    
}

extension HistoryController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        
        cell.category = "cat"
        cell.date = "12 feb"
        cell.amount = 88
        
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
