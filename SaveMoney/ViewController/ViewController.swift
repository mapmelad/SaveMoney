//
//  ViewController.swift
//  SaveMoney
//
//  Created by Semyon on 17.02.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var spendAmountTextField: UITextField!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupBindings()
    }
    
    private func setupScreen() {
        setupContainers()
    }
    
    private func setupContainers() {
        setupKeyboardContainer()
    }
    
    private func setupKeyboardContainer() {}
    
    // MARK: - Members
    
    private let category = ["Транспорт 🚎", "Бары 🍻", "Кафе 🍟", "Одежда 👟", "Сотовая связь 📱"]
    
    // MARK: - Setup
    
    private func onKeyboardTap(_ idx: Int) {
        let s = String(idx)
        let h = spendAmountTextField.hasText
        
        if !h {
            spendAmountTextField.text?.append(s)
        } else {
            let text = spendAmountTextField.text!
            let tidx = text.index(text.endIndex, offsetBy: -2)
            spendAmountTextField.text?.insert(Character(s), at: tidx)
        }
        spendAmountTextField.moveCaret()
    }
    
    private func onDeleteButtonTap() {
        guard let text = spendAmountTextField.text, text.count > 2 else { return }
        
        let idx = text.index(text.endIndex, offsetBy: -3)
        spendAmountTextField.text?.remove(at: idx)
    }
    
    func updateTipsTextField(_ currentText: String) {
        if currentText.first! == "0" {
            spendAmountTextField.text?.remove(at: spendAmountTextField.text!.startIndex)
        }
        
        if currentText.count == 2 && currentText == " ₽" {
            spendAmountTextField.text = nil
        } else {
            spendAmountTextField.appendRubleSymbol()
            spendAmountTextField.moveCaret()
        }
    }
}

extension ViewController {
    private func setupBindings() {
        bindTipsAmount()
        bindKeyboardTaps()
        bindKeyboardDelete()
    }
    
    private func bindTipsAmount() {
        spendAmountTextField.rx.text
            .unwrap()
            .filter { !$0.isEmpty }
            .next { [unowned self] newValue in
                self.updateTipsTextField(newValue)
            }
    }
    
    private func bindKeyboardTaps() {
        let tagsCount = 11
        
        for i in 1..<tagsCount {
            if let v = view.viewWithTag(i) as? UIButton {
                v.rx.tap.next { [unowned self] in
                    self.onKeyboardTap(i - 1)
                }
            }
        }
    }
    
    private func bindKeyboardDelete() {
        deleteButton.rx.tap.next { [unowned self] _ in
            self.onDeleteButtonTap()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: category[indexPath.row].size(OfFont: UIFont.systemFont(ofSize: 17.0)).width + 15.0, height: 30)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return category.count }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
        
        cell.title.text = category[indexPath.row]
        
        return cell
    }
}
