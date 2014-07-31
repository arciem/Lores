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
    override func setup() {
        super.setup()
        
        layer.magnificationFilter = kCAFilterNearest
        contentMode = .ScaleAspectFit
    }
    
    override func didMoveToSuperview() {
        if let sv = superview {
            constrainToSuperview()
        }
    }
}
