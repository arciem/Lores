//
//  ProgramView.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import WolfCore

open class ProgramView: View {
    open var program: Program!
    var canvasView: CanvasView!
    var backgroundView: BackgroundView!

    override open func setup() {
        super.setup()

        layer.magnificationFilter = kCAFilterNearest
        backgroundColor = UIColor.green
        
        addBackgroundView()
        addCanvasView()
    }

    func addBackgroundView() {
        backgroundView = BackgroundView(frame: bounds)
        addSubview(backgroundView)
        backgroundView.constrainToSuperview()
    }
    
    func addCanvasView() {
        canvasView = CanvasView(frame: bounds)
        addSubview(canvasView)
        canvasView.constrainToSuperview()
        
        canvasView.touchBegan = { [unowned self] point in
            self.program.touchBeganAtPoint(self.canvasPointForCanvasViewPoint(point))
        }
        
        canvasView.touchMoved = { [unowned self] point in
            self.program.touchMovedAtPoint(self.canvasPointForCanvasViewPoint(point))
        }
        
        canvasView.touchEnded = { [unowned self] point in
            self.program.touchEndedAtPoint(self.canvasPointForCanvasViewPoint(point))
        }
        
        canvasView.touchCancelled = { [unowned self] point in
            self.program.touchCancelledAtPoint(self.canvasPointForCanvasViewPoint(point))
        }
    }
    
    open func flush() {
        canvasView.image = program.canvas.image
    }
    
    func canvasPointForCanvasViewPoint(_ point: CGPoint) -> Point {
        let canvasImageSize = self.program.canvas.image.size
        let canvasImageSizeScaled = canvasImageSize.aspectFit(within: self.canvasView.bounds.size)
        let canvasImageFrame = CGRect(origin: .zero, size: canvasImageSizeScaled).settingMidXmidY(self.canvasView.bounds.midXmidY)
        let fx = point.x.mapped(from: canvasImageFrame.minX..canvasImageFrame.maxX, to: CGFloat(0)..canvasImageSize.width)
        let fy = point.y.mapped(from: canvasImageFrame.minY..canvasImageFrame.maxY, to: CGFloat(0)..canvasImageSize.height)
        let x = Int(floor(fx))
        let y = Int(floor(fy))
        let p = Point(x: x, y: y)
        return p
    }
}
