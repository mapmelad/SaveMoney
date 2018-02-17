//
//  UITextFieldExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

extension UITextField {
    var safeText: String {
        return text ?? ""
    }
}

extension UITextField {
    
    func updateAmountText() {
        let currentText = safeText
        
        if currentText.first! == "0" {
            self.text?.remove(at: text!.startIndex)
        }
        
        if currentText.count == 2 && currentText == " ₽" {
            text = nil
        } else {
            self.appendRubleSymbol()
            self.moveCaret()
        }
    }
    
    func append(_ char: Int) {
        self.append(String(char))
    }
    
    func append(_ char: String) {
        if !hasText {
            self.text?.append(char)
        } else {
            let tidx = text!.index(text!.endIndex, offsetBy: -2)
            self.text?.insert(Character(char), at: tidx)
        }
        
        if let a = self.text?.amount { self.text = a.amountFormat }
        self.moveCaret()
    }
    
    func deleteChar() {
        guard let text = text, text.count > 2 else { return }
        
        let idx = text.index(text.endIndex, offsetBy: -3)
        self.text?.remove(at: idx)
        if let a = self.text?.amount { self.text = a.amountFormat }
    }
    
    func appendRubleSymbol() {
        guard let text = self.text else { return }
        if text.last != "₽" { self.text?.append(" ₽") }
    }
    
    func moveCaret() {
        guard let newPosition = position(from: self.endOfDocument, offset: -2) else { return }
        let newRange = self.textRange(from: newPosition, to: newPosition)
        self.selectedTextRange = newRange
    }
}
