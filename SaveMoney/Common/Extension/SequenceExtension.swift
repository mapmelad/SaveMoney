//
//  SequenceExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key, val) in categories {
            result[key] = val.value
        }

        return result
    }
}
