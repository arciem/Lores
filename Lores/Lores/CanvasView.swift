//
//  CanvasView.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem
import QuartzCore

class CanvasView : CImageView {
    var touchBegan: ((point: CGPoint) -> Void)?
    var touchMoved: ((point: CGPoint) -> Void)?
    var touchEnded: ((point: CGPoint) -> Void)?
    var touchCancelled: ((point: CGPoint) -> Void)?
    
    override func setup() {
        super.setup()
        
        layer.magnificationFilter = kCAFilterNearest
        contentMode = .ScaleAspectFit
        userInteractionEnabled = true
    }
    
    override func didMoveToSuperview() {
        if let sv = superview {
            constrainToSuperview()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let loc = touch.locationInView(self)
        touchBegan?(point: loc)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let loc = touch.locationInView(self)
        touchMoved?(point: loc)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let loc = touch.locationInView(self)
        touchEnded?(point: loc)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let loc = touch.locationInView(self)
        touchCancelled?(point: loc)
    }
}
