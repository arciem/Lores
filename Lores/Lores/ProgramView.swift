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

        layer.magnificationFilter = kCAFilterNearest
        backgroundColor = UIColor.greenColor()
        
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
    
    public func flush() {
        canvasView.image = program.canvas.image
    }
    
    func canvasPointForCanvasViewPoint(point: CGPoint) -> Point {
        let canvasImageSize = self.program.canvas.image.size
        let canvasImageSizeScaled = canvasImageSize.aspectFitWithinSize(self.canvasView.bounds.size)
        let canvasImageFrame = CGRect(origin: CGPoint.zero, size: canvasImageSizeScaled).rectBySettingMid(self.canvasView.bounds.mid)
        let fx = Math.map(point.x, canvasImageFrame.minX, canvasImageFrame.maxX, CGFloat(0), canvasImageSize.width)
        let fy = Math.map(point.y, canvasImageFrame.minY, canvasImageFrame.maxY, CGFloat(0), canvasImageSize.height)
        let x = Int(floor(fx))
        let y = Int(floor(fy))
        let p = Point(x: x, y: y)
        return p
    }
}
