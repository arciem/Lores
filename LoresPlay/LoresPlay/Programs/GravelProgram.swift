import Lores

class GravelProgram : Program {
    
    override func setup() {
        framesPerSecond = 20
    }
    
    override func draw()  {
        for _ in 1...50 {
            canvas.setPoint(canvas.randomPoint(), toColor: Color.randomColor())
        }
    }
    
}
