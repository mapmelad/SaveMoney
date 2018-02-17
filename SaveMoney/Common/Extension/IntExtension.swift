//
//  IntExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

extension Int {
    var asString: String { return String(self) }
    
    var spendAmount: String { return "\(self) ₽" }
}
