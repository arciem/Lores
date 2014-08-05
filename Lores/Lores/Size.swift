//
//  Size.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public struct Size : Printable {
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public var description: String {
    get {
        return "Lores.Size(width:\(width) height:\(height))"
    }
    }
    
    public func randomX() -> Int {
        return Random.sharedInstance.randomInt(0..<width)
    }
    
    public func randomY() -> Int {
        return Random.sharedInstance.randomInt(0..<height)
    }
    
    public func randomPoint() -> Point {
        return Point(x: randomX(), y: randomY())
    }
}