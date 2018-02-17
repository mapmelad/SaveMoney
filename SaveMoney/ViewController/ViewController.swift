//
//  ViewController.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var spendAmountTextField: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    let category = ["Транспорт 🚎", "Бары 🍻", "Кафе 🍟", "Одежда 👟", "Сотовая связь 📱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTipsAmount()
        
        for i in 1..<11 {
            if let v = view.viewWithTag(i) as? UIButton {
                v.rx.tap.subscribe(onNext: { [unowned self] _ in
                    self.onButtonTap(i - 1)
                })
            }
        }
        
        deleteButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.spendAmountTextField.text?.removeLast()
        })
        
    }
    
    private func onButtonTap(_ idx: Int) {
        log.debug("did tap - \(idx)")
        let s = String(idx)
        let h = spendAmountTextField.hasText
        if !h {
            spendAmountTextField.text?.append(s)
        } else {
            let text = spendAmountTextField.text!
            let tidx = text.index(text.endIndex, offsetBy: -2)
            spendAmountTextField.text?.insert(Character(s), at: tidx)
        }
        moveCaret()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bindTipsAmount() {
        let ft = spendAmountTextField.rx.text.filter { $0 != nil && !($0 ?? "").isEmpty }.map { $0 ?? "" }
        ft.subscribe { s in
            self.updateTipsTextField(s.element!)
            // self.spendAmountTextField.text = ""
        }
        
    }
    
    func updateTipsTextField(_ currentText: String) {
        if currentText.count == 2 && currentText == " ₽" {
            spendAmountTextField.text = nil
        } else {
            appendRubleSymbol(currentText)
            moveCaret()
        }
    }
    
    private func appendRubleSymbol(_ currentText: String) {
        
        let t = spendAmountTextField.text ?? ""
        print(t)
        if t.last != "₽" { spendAmountTextField.text?.append(" ₽") }
    }
    
    private func moveCaret() {
        guard let newPosition = spendAmountTextField.position(from: spendAmountTextField.endOfDocument, offset: -2) else { return }
        let newRange = spendAmountTextField.textRange(from: newPosition, to: newPosition)
        spendAmountTextField.selectedTextRange = newRange
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: category[indexPath.row].size(OfFont: UIFont.systemFont(ofSize: 17.0)).width + 15.0, height: 30)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.title.text = category[indexPath.row]
        
        return cell
    }
}
