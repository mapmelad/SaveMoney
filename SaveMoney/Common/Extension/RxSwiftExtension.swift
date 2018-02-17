//
//  RxSwiftExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 17.02.18.
//  Copyright © 2018 own2pwn. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt

extension ObservableType {
    // public func next(_ block: ((Self.E) -> Swift.Void)? = nil) -> Disposable {

    /**
     Subscribes an element handler, an error handler, a completion handler and disposed handler to an observable sequence.

     - parameter block: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    @discardableResult
    public func next(_ block: @escaping ((Self.E) -> Swift.Void)) -> Disposable {
        return subscribe(onNext: block)
    }
}
