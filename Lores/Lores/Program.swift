//
//  Program.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import WolfCore

open class Program {
    private var _canvasSize = Size(width: 41, height: 31)
    private var _canvas: Canvas?
    private var _framesPerSecond: Float = 0.0
    private var canceler: Cancelable?
    private var needsDisplay: Bool = true
    public var didDisplay: Block?

    public fileprivate(set) var canvas: Canvas! {
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

    private func invalidateCanvas() {
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

    private var queue = DispatchQueue(label: "Program Queue", qos: DispatchQoS.init(qosClass: .userInteractive, relativePriority: 0), attributes: [])
    private var dispatchSource: DispatchSourceTimer!

    public var framesPerSecond: Float {
        get {
            return _framesPerSecond
        }
        set {
            if _framesPerSecond != newValue {
                _framesPerSecond = newValue
                let interval = TimeInterval(Float(1.0) / _framesPerSecond)
                print("framesPerSecond: \(newValue), interval: \(interval)")
                dispatchSource?.cancel()
                dispatchSource = DispatchSource.makeTimerSource(flags: [.strict], queue: queue)
                dispatchSource.scheduleRepeating(deadline: .now(), interval: interval, leeway: DispatchTimeInterval.milliseconds(0))
                dispatchSource.setEventHandler { [unowned self] in
                    self._update()
                    dispatchOnMain {
                        self.displayIfNeeded()
                    }
                }
                dispatchSource.resume()
            }
        }
    }

    public init() {
        _setup()
    }

    private func _setup() {
        setup()
    }

    private var lastUpdateTime: TimeInterval?
    private var averageElapsedTime: TimeInterval?

    private func _update() {
        let updateTime = Date.timeIntervalSinceReferenceDate
        if let lastUpdateTime = lastUpdateTime {
            let elapsedTime = updateTime - lastUpdateTime
            if let averageElapsedTime = averageElapsedTime {
                self.averageElapsedTime = (elapsedTime + averageElapsedTime) / 2
            } else {
                averageElapsedTime = elapsedTime
            }
//            print("target: \(1.0 / framesPerSecond) elapsed: \(elapsedTime) averageElapsed: \(averageElapsedTime!)")
        }
        lastUpdateTime = updateTime

        update()
        needsDisplay = true
    }

    public func display() {
        clear()
        draw()
        didDisplay?()
    }

    private func displayIfNeeded() {
        if needsDisplay {
            display()
            needsDisplay = false
        }
    }

    open func clear() {
        canvas.clearToColor(Color(color: .white, alpha: 0.1))
    }

    open func setup() { }
    open func update() { }
    open func draw() { }

    open func touchBeganAtPoint(_ point: Point) { }
    open func touchMovedAtPoint(_ point: Point) { }
    open func touchEndedAtPoint(_ point: Point) { }
    open func touchCancelledAtPoint(_ point: Point) { }
}
