//
//  Point.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct Point {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        get {
            return "Lores.Point(x:\(x) y:\(y))"
        }
    }
}