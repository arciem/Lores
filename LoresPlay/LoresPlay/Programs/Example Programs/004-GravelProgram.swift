import Lores

class GravelProgram : Program {
    
    override func setup() {
        framesPerSecond = 20
//        canvasSize = Size(width: 100, height: 100)
    }
    
    override func draw()  {
        for _ in 1...50 {
            canvas.setPoint(canvas.randomPoint(), toColor: Color.randomColor())
        }
    }
    
}
