//
//  ArrayExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

public extension Array {
    public var randomElement: Element {
        let randomIdx = Int(arc4random_uniform(UInt32(count)))

        return self[randomIdx]
    }
}
