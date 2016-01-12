//
//  CanvasView.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import WolfCore
import QuartzCore

class CanvasView : ImageView {
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
        if superview != nil {
            constrainToSuperview()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.locationInView(self)
        touchBegan?(point: loc)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.locationInView(self)
        touchMoved?(point: loc)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.locationInView(self)
        touchEnded?(point: loc)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let touch = touches!.first!
        let loc = touch.locationInView(self)
        touchCancelled?(point: loc)
    }
}
