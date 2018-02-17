//
//  Reusable.swift
//  RxPrice
//
//  Created by Evgeniy on 10.02.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String { return String(describing: self) }
}

extension UITableViewCell: Reusable {}

extension UICollectionViewCell: Reusable {}

extension UIViewController: Reusable {}

extension UITableView {
    func register<T: Reusable>(_ cellClass: T.Type = T.self) where T: UITableViewCell {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }

    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as! T

        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as! T

        return cell
    }
}

extension UIStoryboard {
    func instantiateViewController<T: Reusable>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseID) as? T else {
            fatalError()
        }
        return viewController
    }
}
