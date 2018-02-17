//
//  HistorySectionHeaderCell.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

protocol HistoryHeader: class {
    var date: String { get set }
}

final class HistorySectionHeaderCell: UITableViewCell, HistoryHeader {
    // MARK: - Outlets

    @IBOutlet var dateLabel: UILabel!

    // MARK: - Setters

    var date: String = "" { didSet { dateLabel.text = date } }

    // MARK: - Overrides

    override func awakeFromNib() { super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }
}
