//
//  Log.swift
//  Lores
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import WolfCore

public var logOutputStream: StandardOutputStream = standardOutputStream

public func logPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let s = items.map({ "\($0)" }).joined(separator: separator) + terminator
    logOutputStream.write(s)
}
