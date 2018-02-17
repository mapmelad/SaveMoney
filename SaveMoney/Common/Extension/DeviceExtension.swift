//
//  DeviceExtension.swift
//  RxPrice
//
//  Created by Evgeniy on 10.02.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

final class Device {
    static var size: CGSize { return UIScreen.main.bounds.size }

    static var width: CGFloat { return size.width }

    static var height: CGFloat { return size.height }
}
