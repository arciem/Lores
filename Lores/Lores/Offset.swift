//
//  Offset.swift
//  Lores
//
//  Created by Bevan Essman on 8/3/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

public struct Offset : Printable {
    public let dx: Int
    public let dy: Int
    
    public init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
    
    public var description: String {
    get {
        return "Lores.Offset(dx:\(dx) dy:\(dy))"
    }
    }
}