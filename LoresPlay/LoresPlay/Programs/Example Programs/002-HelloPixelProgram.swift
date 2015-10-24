import Lores

class HelloPixelProgram : Program {
    
    override func draw()  {
        let p = Point(x: 0, y: 0)
        let c = Color.Red
        canvas.setPoint(p, toColor: c)
    }

}
