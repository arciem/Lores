//
//  Program.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public class Program {
    var _canvasSize = Size(width: 41, height: 31)
    var _canvas: Canvas?
    let serializer: Serializer
    var _framesPerSecond: Float = 0.0
    var canceler: Canceler?
    var needsDisplay: Bool = true
    public var didDisplay: DispatchBlock?
    
    public private(set) var canvas: Canvas! {
    get {
        if _canvas == nil {
            _canvas = Canvas(size: canvasSize)
        }
        return _canvas
    }
    set {
        _canvas = newValue
    }
    }
    
    func invalidateCanvas() {
        canvas = nil
    }
    
    public var canvasSize: Size {
    get {
        return _canvasSize
    }
    set {
        _canvasSize = newValue
        invalidateCanvas()
    }
    }
    
    public var framesPerSecond: Float {
    get {
        return _framesPerSecond
    }
    set {
        if _framesPerSecond != newValue {
            _framesPerSecond = newValue
            if let c = canceler {
                c.canceled = true
            }
            let interval = NSTimeInterval(Float(1.0) / _framesPerSecond)
            canceler = dispatchRepeatedOnBackground(atInterval: interval) { [unowned self] canceler in
                self.serializer.dispatch() {
                    self._update()
                }
                self.serializer.dispatchOnMain() {
                    self.displayIfNeeded()
                }
            }
        }
    }
    }
    
    public init() {
        self.serializer = Serializer(name: "ProgramView serializer")
        _setup()
    }
    
    func _setup() {
        setup()
    }
    
    func _update() {
        update()
        needsDisplay = true
    }
    
    public func display() {
        clear()
        draw()
        didDisplay?()
    }
    
    func displayIfNeeded() {
        if needsDisplay {
            display()
            needsDisplay = false
        }
    }
    
    public func clear() {
        canvas.clearToColor(Color(color: Color.White, alpha: 0.05))
    }
    
    public func setup() { }
    public func update() { }
    public func draw() { }
}