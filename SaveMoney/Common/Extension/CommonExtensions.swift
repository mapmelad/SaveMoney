//
//  CommonExtensions.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

final class Box<A> {
    var value: A
    init(_ val: A) {
        value = val
    }
}

func getRussianMonth(_ indexMonth: Int) -> String {
    let sDict: [Int: String] = [
        1: "Января",
        2: "Февраля",
        3: "Марта",
        4: "Апреля",
        5: "Мая",
        6: "Июня",
        7: "Июля",
        8: "Августа",
        9: "Сентября",
        10: "Октября",
        11: "Ноября",
        12: "Декабря"
    ]

    return sDict[indexMonth] ?? ""
}

func month(for idx: Int) -> String {
    let sDict: [Int: String] = [
        1: "Январь",
        2: "Февраль",
        3: "Март",
        4: "Апрель",
        5: "Май",
        6: "Июнь",
        7: "Июль",
        8: "Август",
        9: "Сентябрь",
        10: "Октябрь",
        11: "Ноябрь",
        12: "Декабрь"
    ]

    return sDict[idx] ?? ""
}
