import Lores

class MoveProgram : Program {
    var p = Point(x: 0, y: 0)

    override func setup() {
        framesPerSecond = 30
    }
    
    override func update() {
        let oldp = p
        var newx = oldp.x + 1
        if newx > canvas.maxX {
            newx = 0
        }
        p = Point(x: newx, y: canvas.midY)
    }
    
    override func draw()  {
        let c = Color.Red
        canvas.setPoint(p, toColor: c)
    }
    
}