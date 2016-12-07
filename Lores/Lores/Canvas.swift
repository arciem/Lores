//
//  Canvas.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit
import Accelerate
import WolfCore

open class Canvas {
    open let size: Size
    open let minX: Int = 0
    open let minY: Int = 0
    open let maxX: Int
    open let maxY: Int
    open let midX: Int
    open let midY: Int
    
    fileprivate let chunkyBytesCount: Int
    fileprivate let planarFloatsCount: Int
    fileprivate let planarFloatsPerRow: Int
    
    fileprivate let argb8Data: UnsafeMutablePointer<UInt8>
    fileprivate let argb8PremultipliedData: UnsafeMutablePointer<UInt8>
    fileprivate let alphaFData: UnsafeMutablePointer<Float>
    fileprivate let redFData: UnsafeMutablePointer<Float>
    fileprivate let greenFData: UnsafeMutablePointer<Float>
    fileprivate let blueFData: UnsafeMutablePointer<Float>

    fileprivate var argb8: vImage_Buffer
    fileprivate var argb8Premultiplied: vImage_Buffer
    fileprivate var alphaF: vImage_Buffer
    fileprivate var redF: vImage_Buffer
    fileprivate var greenF: vImage_Buffer
    fileprivate var blueF: vImage_Buffer
    
    fileprivate var maxPixelValues: [Float] = [1, 1, 1, 1]
    fileprivate var minPixelValues: [Float] = [0, 0, 0, 0]
    fileprivate let context: CGContext
    fileprivate var _image: UIImage?
    
    public init(size: Size) {
        assert(size.width > 0, "width must be > 0")
        assert(size.height > 0, "height must be > 0")

        self.size = size
        maxX = size.width - 1
        maxY = size.height - 1
        midX = size.width / 2
        midY = size.height / 2
        
        let width = self.size.width
        let height = self.size.height
        let colorSpace = sharedColorSpaceRGB
        let componentsPerPixel = Int(colorSpace.numberOfComponents) + 1 // alpha

        let chunkyBytesPerComponent = 1
        let chunkyBitsPerComponent = chunkyBytesPerComponent * 8
        let chunkyBytesPerPixel = componentsPerPixel * chunkyBytesPerComponent
        let chunkyBytesPerRow = Int(UInt(width * chunkyBytesPerPixel + 15) & ~UInt(0xf))
        chunkyBytesCount = height * chunkyBytesPerRow
        
        let planarBytesPerComponent = MemoryLayout<Float>.size
        let planarBytesPerRow = Int(UInt(width * planarBytesPerComponent * componentsPerPixel + 15) & ~UInt(0xf))
        planarFloatsPerRow = planarBytesPerRow >> 2
        planarFloatsCount = height * planarFloatsPerRow

        argb8Data = UnsafeMutablePointer<UInt8>.allocate(capacity: chunkyBytesCount)
        argb8PremultipliedData = UnsafeMutablePointer<UInt8>.allocate(capacity: chunkyBytesCount)
        alphaFData = UnsafeMutablePointer<Float>.allocate(capacity: planarFloatsCount)
        redFData = UnsafeMutablePointer<Float>.allocate(capacity: planarFloatsCount)
        greenFData = UnsafeMutablePointer<Float>.allocate(capacity: planarFloatsCount)
        blueFData = UnsafeMutablePointer<Float>.allocate(capacity: planarFloatsCount)

        let uWidth = vImagePixelCount(width)
        let uHeight = vImagePixelCount(height)
        
//        argb8 = vImage_Buffer(data: argb8Data, height: uHeight, width: uWidth, rowBytes: chunkyBytesPerRow)
        argb8 = vImage_Buffer(data: argb8Data, height: vImagePixelCount(height), width: uWidth, rowBytes: chunkyBytesPerRow)
        argb8Premultiplied = vImage_Buffer(data: argb8PremultipliedData, height: uHeight, width: uWidth, rowBytes: chunkyBytesPerRow)
        alphaF = vImage_Buffer(data: alphaFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        redF = vImage_Buffer(data: redFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        greenF = vImage_Buffer(data: greenFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        blueF = vImage_Buffer(data: blueFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context = CGContext(data: argb8PremultipliedData, width: width, height: height, bitsPerComponent: chunkyBitsPerComponent, bytesPerRow: chunkyBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        //println("width:\(width) height:\(height) componentsPerPixel:\(componentsPerPixel) chunkyBytesPerComponent:\(chunkyBytesPerComponent) chunkyBitsPerComponent:\(chunkyBitsPerComponent) chunkyBytesPerPixel:\(chunkyBytesPerPixel) chunkyBytesPerRow:\(chunkyBytesPerRow) chunkyBytesCount:\(chunkyBytesCount)")

        //println("planarBytesPerComponent:\(planarBytesPerComponent) planarBytesPerRow:\(planarBytesPerRow) planarFloatsPerRow:\(planarFloatsPerRow) planarFloatsCount:\(planarFloatsCount)")
        
        //println("data:\(redF.data) height:\(redF.height) width:\(redF.width) rowBytes:\(redF.rowBytes)")
    }
    
    deinit {
        argb8Data.deallocate(capacity: Int(chunkyBytesCount))
        argb8PremultipliedData.deallocate(capacity: Int(chunkyBytesCount))
        alphaFData.deallocate(capacity: Int(planarFloatsCount))
        redFData.deallocate(capacity: Int(planarFloatsCount))
        greenFData.deallocate(capacity: Int(planarFloatsCount))
        blueFData.deallocate(capacity: Int(planarFloatsCount))
    }
    
    open var image: UIImage {
    get {
        if self._image == nil {
            var error = vImageConvert_PlanarFToARGB8888(&alphaF, &redF, &greenF, &blueF, &argb8, &maxPixelValues, &minPixelValues, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when converting canvas to chunky")
            error = vImagePremultiplyData_ARGB8888(&argb8, &argb8Premultiplied, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when premultiplying canvas")
            let cgImage = self.context.makeImage()
            self._image = UIImage(cgImage: cgImage!)
            assert(self._image != nil, "Error when converting")
        }
        return self._image!
    }
    }
    
    func invalidateImage() {
        self._image = nil
    }
    
    open func isValidPoint(_ p: Point) -> Bool {
        return p.x >= 0 && p.y >= 0 && p.x < Int(alphaF.width) && p.y < Int(alphaF.height)
    }
    
    open func clampPoint(_ p: Point) -> Point {
        return Point(x: min(max(p.x, minX), maxX), y: min(max(p.y, minY), maxY))
    }
    
    fileprivate func checkPoint(_ point: Point) {
        assert(point.x >= minX, "x must be >= 0")
        assert(point.y >= minY, "y must be >= 0")
        assert(point.x <= maxX, "x must be < width")
        assert(point.y <= maxY, "y must be < height")
    }
    
    fileprivate func offsetForPoint(_ point: Point) -> Int {
        return planarFloatsPerRow * point.y + point.x
    }
    
    open func setPoint(_ point: Point, toColor color: Color) {
        checkPoint(point)
        
        invalidateImage()
        
        let offset = offsetForPoint(point)
        alphaFData[offset] = Float(color.alpha)
        redFData[offset] = Float(color.red)
        greenFData[offset] = Float(color.green)
        blueFData[offset] = Float(color.blue)
    }
    
    open func colorAtPoint(_ point: Point) -> Color {
        checkPoint(point)

        let offset = offsetForPoint(point)
        return Color(red: Frac(redFData[offset]), green: Frac(greenFData[offset]), blue: Frac(blueFData[offset]), alpha: Frac(alphaFData[offset]))
    }
    
    open subscript(point: Point) -> Color {
        get {
            return colorAtPoint(point)
        }
        set {
            setPoint(point, toColor: newValue)
        }
    }
    
    open subscript(x: Int, y: Int) -> Color {
        get {
            return colorAtPoint(Point(x: x, y: y))
        }
        set {
            setPoint(Point(x: x, y: y), toColor: newValue)
        }
    }
    
    open func clearToColor(_ color: Color) {
        invalidateImage()
        
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.red), &redF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.green), &greenF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.blue), &blueF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.alpha), &alphaF, UInt32(kvImageNoFlags))
    }
    
    open func randomX() -> Int {
        return size.randomX()
    }
    
    open func randomY() -> Int {
        return size.randomY()
    }
    
    open func randomPoint() -> Point {
        return size.randomPoint()
    }
}
