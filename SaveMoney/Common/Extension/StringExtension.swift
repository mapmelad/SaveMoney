//
//  StringExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }

    var amount: Int? {
        let formatted = self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "₽", with: "")

        return Int(formatted)
    }
}
