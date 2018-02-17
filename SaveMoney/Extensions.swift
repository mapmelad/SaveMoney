//
//  Extensions.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation
import UIKit

extension Comparable {
    func bound(min: Self, max: Self) -> Self {
        precondition(min < max)
        if self < min { return min }
        if self > max { return max }
        return self
    }
}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}
