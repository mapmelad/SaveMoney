//
//  CommonExtensions.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation

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

