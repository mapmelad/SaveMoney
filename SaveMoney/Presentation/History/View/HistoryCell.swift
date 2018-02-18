//
//  HistoryCell.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

final class HistoryCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet var categoryView: UIButton!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var amountLabel: UILabel!
    
    // MARK: - Setters
    
    var category: String = "" { didSet { categoryLabel.text = category } }
    var date: String = "" { didSet { dateLabel.text = date } }
    var amount: Int = 0 { didSet { amountLabel.text = amount.amountFormat } }
    
    // MARK: - Overrides
    
    override func awakeFromNib() { super.awakeFromNib() }
    
    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }
}
