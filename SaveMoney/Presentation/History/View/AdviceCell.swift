//
//  AdviceCell.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

final class AdviceCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var cardView: UIView!
    @IBOutlet var adviceLabel: UILabel!

    // MARK: - Setters

    var advice: String = "" { didSet { adviceLabel.text = advice } }
}
