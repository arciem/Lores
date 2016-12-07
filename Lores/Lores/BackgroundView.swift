//
//  BackgroundView.swift
//  Lores
//
//  Created by Robert McNally on 7/30/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import WolfCore

class BackgroundView : ImageView {
    override func setup() {
        super.setup()
        
        contentMode = .scaleAspectFill
        image = UIImage(named: "BlackLeather.jpg", in: Bundle(identifier: "com.arciem.Lores"), compatibleWith: nil)
        backgroundColor = UIColor.black
    }
}
