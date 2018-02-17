//
//  SettingsController.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var budgetTextField: UITextField!
    @IBOutlet var budgetDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindDateLabel()
        bindBudgetDayLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bindBudgetDayLabel() {
        
        let calendar = Calendar.current
        let date = Date()
        let interval = calendar.dateInterval(of: .month, for: date)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        print(days)
        budgetDayLabel.text = String(10000 / days)
    }
    
    private func bindDateLabel() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let nameOfMonth = dateFormatter.string(from: nextMonth!)
        
        dateLabel.text = "До 1 \(getRussianMonth(Int(nameOfMonth)!))"
    }
}
