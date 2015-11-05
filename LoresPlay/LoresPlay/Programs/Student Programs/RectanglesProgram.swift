//
//  Rectangles.swift
//  LoresPlay
//
//  Created by Jade on 10/25/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Lores

class RectanglesProgram: Program {
    
    override func draw()  {
        drawRectangle(x1:  6, y1:  7, x2: 11, y2: 12, toColor: .Red)
        drawRectangle(x1: 21, y1:  3, x2: 29, y2:  5, toColor: .White)
        drawRectangle(x1: 29, y1:  5, x2: 34, y2: 11, toColor: .Yellow)
        drawRectangle(x1: 16, y1:  5, x2: 25, y2: 16, toColor: .Purple)
        drawRectangle(x1: 22, y1: 14, x2: 31, y2: 22, toColor: .MediumBlue)
        drawRectangle(x1: 16, y1: 20, x2: 25, y2: 28, toColor: .Orange)
        drawRectangle(x1: 23, y1: 26, x2: 30, y2: 30, toColor: .LightGray)
        drawRectangle(x1: 29, y1: 19, x2: 35, y2: 24, toColor: .Green)
    }
    
    func drawHorizontalLine(x1 x1: Int, x2: Int, y: Int, toColor color: Color) {
        for x in x1...x2 {
            canvas[x, y] = color
        }
    }
    
    func drawVerticalLine(y1 y1: Int, y2: Int, x: Int, toColor color: Color) {
        for y in y1...y2 {
            canvas[x, y] = color
        }
    }
    
    func drawRectangle(x1 x1: Int, y1: Int, x2: Int, y2: Int, toColor color: Color) {
        drawHorizontalLine(x1: x1, x2: x2, y: y1, toColor: color)
        drawHorizontalLine(x1: x1, x2: x2, y: y2, toColor: color)
        drawVerticalLine(y1: y1, y2: y2, x: x1, toColor: color)
        drawVerticalLine(y1: y1, y2: y2, x: x2, toColor: color)
    }    
}
