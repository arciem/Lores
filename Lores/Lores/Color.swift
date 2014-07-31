//
//  Color.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public struct Color : Printable {
    let red: Float
    let green: Float
    let blue: Float
    let alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(color: Color, alpha: Float) {
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = alpha
    }
    
    public init(var hue h: Float, var saturation s: Float, var brightness v: Float, alpha a: Float = 1.0) {
        v = clamp(v, min: 0.0, max: 1.0)
        s = clamp(s, min: 0.0, max: 1.0)
        red = v
        green = v
        blue = v
        alpha = a
        if(s > 0.0) {
            h %= 1.0
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floorf(h))
            let f = h - Float(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch(i) {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: assert(false, "unknown hue sector")
            }
        }
    }
    
    public static func randomColor(alpha: Float = 1.0) -> Color {
        return Color(
            red: Float(Arciem.random.randomFlat()),
            green: Float(Arciem.random.randomFlat()),
            blue: Float(Arciem.random.randomFlat()),
            alpha: alpha
        )
    }
    
    public static let Black: Color = Color(red: 0, green: 0, blue: 0)
    public static let DarkGray: Color = Color(red: 1 / 3.0, green: 1 / 3.0, blue: 1 / 3.0)
    public static let LightGray: Color = Color(red: 2 / 3.0, green: 2 / 3.0, blue: 2 / 3.0)
    public static let White: Color = Color(red: 1, green: 1, blue: 1)
    public static let Gray: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    public static let Red: Color = Color(red: 1, green: 0, blue: 0)
    public static let Green: Color = Color(red: 0, green: 1, blue: 0)
    public static let Blue: Color = Color(red: 0, green: 0, blue: 1)
    public static let Cyan: Color = Color(red: 0, green: 1, blue: 1)
    public static let Yellow: Color = Color(red: 1, green: 1, blue: 0)
    public static let Magenta: Color = Color(red: 1, green: 0, blue: 1)
    public static let Orange: Color = Color(red: 1, green: 0.5, blue: 0)
    public static let Purple: Color = Color(red: 0.5, green: 0, blue: 0.5)
    public static let Brown: Color = Color(red: 0.6, green: 0.4, blue: 0.2)
    public static let Clear: Color = Color(red: 0, green: 0, blue: 0, alpha: 0)

    public var description: String {
    get {
        return "Lores.Color(red:\(red) green:\(green) blue:\(blue) alpha:\(alpha))"
    }
    }
}