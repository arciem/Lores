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

public class Canvas {
    public let size: Size
    public let minX: Int = 0
    public let minY: Int = 0
    public let maxX: Int
    public let maxY: Int
    public let midX: Int
    public let midY: Int
    
    private let chunkyBytesCount: Int
    private let planarFloatsCount: Int
    private let planarFloatsPerRow: Int
    
    private let argb8Data: UnsafeMutablePointer<UInt8>
    private let argb8PremultipliedData: UnsafeMutablePointer<UInt8>
    private let alphaFData: UnsafeMutablePointer<Float>
    private let redFData: UnsafeMutablePointer<Float>
    private let greenFData: UnsafeMutablePointer<Float>
    private let blueFData: UnsafeMutablePointer<Float>

    private var argb8: vImage_Buffer
    private var argb8Premultiplied: vImage_Buffer
    private var alphaF: vImage_Buffer
    private var redF: vImage_Buffer
    private var greenF: vImage_Buffer
    private var blueF: vImage_Buffer
    
    private var maxPixelValues: [Float] = [1, 1, 1, 1]
    private var minPixelValues: [Float] = [0, 0, 0, 0]
    private let context: CGContext
    private var _image: UIImage?
    
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
        let componentsPerPixel = Int(CGColorSpaceGetNumberOfComponents(colorSpace)) + 1 // alpha

        let chunkyBytesPerComponent = 1
        let chunkyBitsPerComponent = chunkyBytesPerComponent * 8
        let chunkyBytesPerPixel = componentsPerPixel * chunkyBytesPerComponent
        let chunkyBytesPerRow = Int(UInt(width * chunkyBytesPerPixel + 15) & ~UInt(0xf))
        chunkyBytesCount = height * chunkyBytesPerRow
        
        let planarBytesPerComponent = sizeof(Float)
        let planarBytesPerRow = Int(UInt(width * planarBytesPerComponent * componentsPerPixel + 15) & ~UInt(0xf))
        planarFloatsPerRow = planarBytesPerRow >> 2
        planarFloatsCount = height * planarFloatsPerRow

        argb8Data = UnsafeMutablePointer<UInt8>.alloc(chunkyBytesCount)
        argb8PremultipliedData = UnsafeMutablePointer<UInt8>.alloc(chunkyBytesCount)
        alphaFData = UnsafeMutablePointer<Float>.alloc(planarFloatsCount)
        redFData = UnsafeMutablePointer<Float>.alloc(planarFloatsCount)
        greenFData = UnsafeMutablePointer<Float>.alloc(planarFloatsCount)
        blueFData = UnsafeMutablePointer<Float>.alloc(planarFloatsCount)

        let uWidth = vImagePixelCount(width)
        let uHeight = vImagePixelCount(height)
        
//        argb8 = vImage_Buffer(data: argb8Data, height: uHeight, width: uWidth, rowBytes: chunkyBytesPerRow)
        argb8 = vImage_Buffer(data: argb8Data, height: vImagePixelCount(height), width: uWidth, rowBytes: chunkyBytesPerRow)
        argb8Premultiplied = vImage_Buffer(data: argb8PremultipliedData, height: uHeight, width: uWidth, rowBytes: chunkyBytesPerRow)
        alphaF = vImage_Buffer(data: alphaFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        redF = vImage_Buffer(data: redFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        greenF = vImage_Buffer(data: greenFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)
        blueF = vImage_Buffer(data: blueFData, height: uHeight, width: uWidth, rowBytes: planarBytesPerRow)

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        context = CGBitmapContextCreate(argb8PremultipliedData, width, height, chunkyBitsPerComponent, chunkyBytesPerRow, colorSpace, bitmapInfo.rawValue)!
        
        //println("width:\(width) height:\(height) componentsPerPixel:\(componentsPerPixel) chunkyBytesPerComponent:\(chunkyBytesPerComponent) chunkyBitsPerComponent:\(chunkyBitsPerComponent) chunkyBytesPerPixel:\(chunkyBytesPerPixel) chunkyBytesPerRow:\(chunkyBytesPerRow) chunkyBytesCount:\(chunkyBytesCount)")

        //println("planarBytesPerComponent:\(planarBytesPerComponent) planarBytesPerRow:\(planarBytesPerRow) planarFloatsPerRow:\(planarFloatsPerRow) planarFloatsCount:\(planarFloatsCount)")
        
        //println("data:\(redF.data) height:\(redF.height) width:\(redF.width) rowBytes:\(redF.rowBytes)")
    }
    
    deinit {
        argb8Data.dealloc(Int(chunkyBytesCount))
        argb8PremultipliedData.dealloc(Int(chunkyBytesCount))
        alphaFData.dealloc(Int(planarFloatsCount))
        redFData.dealloc(Int(planarFloatsCount))
        greenFData.dealloc(Int(planarFloatsCount))
        blueFData.dealloc(Int(planarFloatsCount))
    }
    
    public var image: UIImage {
    get {
        if self._image == nil {
            var error = vImageConvert_PlanarFToARGB8888(&alphaF, &redF, &greenF, &blueF, &argb8, &maxPixelValues, &minPixelValues, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when converting canvas to chunky")
            error = vImagePremultiplyData_ARGB8888(&argb8, &argb8Premultiplied, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when premultiplying canvas")
            let cgImage = CGBitmapContextCreateImage(self.context)
            self._image = UIImage(CGImage: cgImage!)
            assert(self._image != nil, "Error when converting")
        }
        return self._image!
    }
    }
    
    func invalidateImage() {
        self._image = nil
    }
    
    public func isValidPoint(p: Point) -> Bool {
        return p.x >= 0 && p.y >= 0 && p.x < Int(alphaF.width) && p.y < Int(alphaF.height)
    }
    
    public func clampPoint(p: Point) -> Point {
        return Point(x: min(max(p.x, minX), maxX), y: min(max(p.y, minY), maxY))
    }
    
    private func checkPoint(point: Point) {
        assert(point.x >= minX, "x must be >= 0")
        assert(point.y >= minY, "y must be >= 0")
        assert(point.x <= maxX, "x must be < width")
        assert(point.y <= maxY, "y must be < height")
    }
    
    private func offsetForPoint(point: Point) -> Int {
        return planarFloatsPerRow * point.y + point.x
    }
    
    public func setPoint(point: Point, toColor color: Color) {
        checkPoint(point)
        
        invalidateImage()
        
        let offset = offsetForPoint(point)
        alphaFData[offset] = Float(color.alpha)
        redFData[offset] = Float(color.red)
        greenFData[offset] = Float(color.green)
        blueFData[offset] = Float(color.blue)
    }
    
    public func colorAtPoint(point: Point) -> Color {
        checkPoint(point)

        let offset = offsetForPoint(point)
        return Color(red: Frac(redFData[offset]), green: Frac(greenFData[offset]), blue: Frac(blueFData[offset]), alpha: Frac(alphaFData[offset]))
    }
    
    public subscript(point: Point) -> Color {
        get {
            return colorAtPoint(point)
        }
        set {
            setPoint(point, toColor: newValue)
        }
    }
    
    public subscript(x: Int, y: Int) -> Color {
        get {
            return colorAtPoint(Point(x: x, y: y))
        }
        set {
            setPoint(Point(x: x, y: y), toColor: newValue)
        }
    }
    
    public func clearToColor(color: Color) {
        invalidateImage()
        
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.red), &redF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.green), &greenF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.blue), &blueF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(Float(color.alpha), &alphaF, UInt32(kvImageNoFlags))
    }
    
    public func randomX() -> Int {
        return size.randomX()
    }
    
    public func randomY() -> Int {
        return size.randomY()
    }
    
    public func randomPoint() -> Point {
        return size.randomPoint()
    }
}
