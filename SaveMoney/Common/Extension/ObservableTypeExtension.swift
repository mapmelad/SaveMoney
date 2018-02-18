//
//  ObservableTypeExtension.swift
//  SaveMoney
//
//  Created by Evgeniy on 18.02.18.
//  Copyright © 2018 Semyon. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {

    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.

     - returns: An observable sequence of non-optional elements
     */
    public var ignoreNil: RxSwift.Observable<Self.E> { return flatMap { Observable.from(optional: $0) } }
}
