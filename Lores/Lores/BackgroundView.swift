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
        image = UIImage(named: "BlackLeather.jpg", inBundle: NSBundle(identifier: "com.arciem.Lores"), compatibleWithTraitCollection: nil)
        backgroundColor = UIColor.blackColor()
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            constrainToSuperview()
        }
    }
}
