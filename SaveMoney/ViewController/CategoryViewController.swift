//
//  CategoryViewController.swift
//  SaveMoney
//
//  Created by Semyon on 18.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var allTimeSpentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private let historyHeaderReuseId = "histHeader"
    private let historyCellReuseId = "histCell"
    
    var item = Expense(id: 100500, amount: 100500, category: "123123r", date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setapNavBar()
        bundBackButton()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setapNavBar(){
        UINavigationBar.appearance().barTintColor = UIColor(red:0.00, green:0.80, blue:0.40, alpha:1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.title = item.category
    }
    
    private func bundBackButton(){
        backButton.rx.tap.next { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 37 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyHeaderReuseId) as! HistorySectionHeaderCell
        //let section = displayModel[section]
        
        cell.date = "Апрель"
        cell.totalSpentLabel.text =  "Всего 2000 ₽"
        
        return cell
    }
}

extension CategoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 5 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 10 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(at: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        
        //        let item = displayModel[section].spends[row]
        //        let date = item.date
        //        let min = date.minute
        //        let humanMinute = min < 10 ? "0\(min)" : "\(min)"
        
        cell.category = "Транспорт 🤲"
        cell.date = "17 января"
        cell.amount = 1200
        
        return cell
    }
}
