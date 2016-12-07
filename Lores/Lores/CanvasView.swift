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
    var touchBegan: ((_ point: CGPoint) -> Void)?
    var touchMoved: ((_ point: CGPoint) -> Void)?
    var touchEnded: ((_ point: CGPoint) -> Void)?
    var touchCancelled: ((_ point: CGPoint) -> Void)?
    
    override func setup() {
        super.setup()
        
        layer.magnificationFilter = kCAFilterNearest
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchBegan?(loc)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchMoved?(loc)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchEnded?(loc)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        let touch = touches!.first!
        let loc = touch.location(in: self)
        touchCancelled?(loc)
    }
}
