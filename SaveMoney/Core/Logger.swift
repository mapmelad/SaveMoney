//
//  Logger.swift
//  BetterCallSoul
//
//  Created by Evgeniy on 05.02.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyBeaver

typealias log = SwiftyBeaver

public final class Logger {
    static func setupLogging() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }
}
