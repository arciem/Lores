//
//  BackgroundView.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import Arciem

class BackgroundView : CImageView {
    override func setup() {
        super.setup()
        
        contentMode = .ScaleAspectFill
        image = UIImage(named: "Stars.jpg")
    }
    
    override func didMoveToSuperview() {
        if let sv = superview {
            constrainToSuperview()
        }
    }
}
