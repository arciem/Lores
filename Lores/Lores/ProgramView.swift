//
//  ProgramView.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

public class ProgramView: CView {
    public var program: Program!
    var canvasView: CanvasView!
    var backgroundView: BackgroundView!

    override public func setup() {
        super.setup()
        
        addBackgroundView()
        addCanvasView()
    }

    func addBackgroundView() {
        backgroundView = BackgroundView(frame: bounds)
        addSubview(backgroundView)
    }
    
    func addCanvasView() {
        canvasView = CanvasView(frame: bounds)
        addSubview(canvasView)
    }
    
    public func flush() {
        canvasView.image = program.canvas.image
    }
}
