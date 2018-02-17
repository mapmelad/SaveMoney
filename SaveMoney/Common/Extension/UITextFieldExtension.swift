//
//  UITextFieldExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

extension UITextField {
    func moveCaret() {
        guard let newPosition = position(from: self.endOfDocument, offset: -2) else { return }
        let newRange = self.textRange(from: newPosition, to: newPosition)
        self.selectedTextRange = newRange
    }

    func appendRubleSymbol() {
        guard let text = self.text else { return }
        if text.last != "₽" { self.text?.append(" ₽") }
    }
}
