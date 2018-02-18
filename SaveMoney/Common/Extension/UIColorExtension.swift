//
//  UIColorExtension.swift
//  SaveMoney
//
//  Created by supreme on 18/02/2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        let divider: CGFloat = 255

        return UIColor(displayP3Red: r / divider, green: g / divider, blue: b / divider, alpha: a)
    }

    static func hex(_ hex: Int) -> UIColor {
        let red = CGFloat((hex >> 16) & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let blue = CGFloat((hex >> 0) & 0xFF)

        return rgb(red, green, blue)
    }

    static func _hex(_ hex: String) -> UIColor {
        var intValue = -1
        let scanner = Scanner(string: hex)
        scanner.scanInt(&intValue)

        return self.hex(intValue)
    }
}
