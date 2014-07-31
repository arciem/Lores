//
//  Canvas.swift
//  Lores
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

import UIKit
import Accelerate
import Arciem

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
    
    private let argb8Data: UnsafePointer<UInt8>
    private let argb8PremultipliedData: UnsafePointer<UInt8>
    private let alphaFData: UnsafePointer<Float>
    private let redFData: UnsafePointer<Float>
    private let greenFData: UnsafePointer<Float>
    private let blueFData: UnsafePointer<Float>

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

        argb8Data = UnsafePointer<UInt8>.alloc(chunkyBytesCount)
        argb8PremultipliedData = UnsafePointer<UInt8>.alloc(chunkyBytesCount)
        alphaFData = UnsafePointer<Float>.alloc(planarFloatsCount)
        redFData = UnsafePointer<Float>.alloc(planarFloatsCount)
        greenFData = UnsafePointer<Float>.alloc(planarFloatsCount)
        blueFData = UnsafePointer<Float>.alloc(planarFloatsCount)

        argb8 = vImage_Buffer(data: argb8Data, height: UInt(height), width: UInt(width), rowBytes: UInt(chunkyBytesPerRow))
        argb8Premultiplied = vImage_Buffer(data: argb8PremultipliedData, height: UInt(height), width: UInt(width), rowBytes: UInt(chunkyBytesPerRow))
        alphaF = vImage_Buffer(data: alphaFData, height: UInt(height), width: UInt(width), rowBytes: UInt(planarBytesPerRow))
        redF = vImage_Buffer(data: redFData, height: UInt(height), width: UInt(width), rowBytes: UInt(planarBytesPerRow))
        greenF = vImage_Buffer(data: greenFData, height: UInt(height), width: UInt(width), rowBytes: UInt(planarBytesPerRow))
        blueF = vImage_Buffer(data: blueFData, height: UInt(height), width: UInt(width), rowBytes: UInt(planarBytesPerRow))

        let bitmapInfo = CGBitmapInfo.fromRaw(CGImageAlphaInfo.PremultipliedFirst.toRaw())!
        context = CGBitmapContextCreate(argb8PremultipliedData, UInt(width), UInt(height), UInt(chunkyBitsPerComponent), UInt(chunkyBytesPerRow), colorSpace, bitmapInfo)
        
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
        if !self._image {
            var error = vImageConvert_PlanarFToARGB8888(&alphaF, &redF, &greenF, &blueF, &argb8, &maxPixelValues, &minPixelValues, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when converting canvas to chunky")
            error = vImagePremultiplyData_ARGB8888(&argb8, &argb8Premultiplied, UInt32(kvImageNoFlags))
            assert(error == kvImageNoError, "Error when premultiplying canvas")
            let cgImage = CGBitmapContextCreateImage(self.context)
            self._image = UIImage(CGImage: cgImage)
            assert(self._image, "Error when converting")
        }
        return self._image!
    }
    }
    
    func invalidateImage() {
        self._image = nil
    }
    
    private func checkPoint(point: Point) {
        assert(point.x >= 0, "x must be >= 0")
        assert(point.y >= 0, "y must be >= 0")
        assert(point.x < Int(alphaF.width), "x must be < width")
        assert(point.y < Int(alphaF.height), "y must be < height")
    }
    
    private func offsetForPoint(point: Point) -> Int {
        return planarFloatsPerRow * point.y + point.x
    }
    
    public func setPoint(point: Point, toColor color: Color) {
        checkPoint(point)
        
        invalidateImage()
        
        let offset = offsetForPoint(point)
        alphaFData[offset] = color.alpha
        redFData[offset] = color.red
        greenFData[offset] = color.green
        blueFData[offset] = color.blue
    }
    
    public func colorAtPoint(point: Point) -> Color {
        checkPoint(point)

        let offset = offsetForPoint(point)
        return Color(red: redFData[offset], green: greenFData[offset], blue: blueFData[offset], alpha: alphaFData[offset])
    }
    
    public func clearToColor(color: Color) {
        invalidateImage()
        
        vImageOverwriteChannelsWithScalar_PlanarF(color.red, &redF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(color.green, &greenF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(color.blue, &blueF, UInt32(kvImageNoFlags))
        vImageOverwriteChannelsWithScalar_PlanarF(color.alpha, &alphaF, UInt32(kvImageNoFlags))
    }
    
    public func randomX() -> Int {
        return random.randomInt(min: 0, max: size.width)
    }
    
    public func randomY() -> Int {
        return random.randomInt(min: 0, max: size.height)
    }
    
    public func randomPoint() -> Point {
        return Point(x: randomX(), y: randomY())
    }
}
