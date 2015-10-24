import Lores

class MoveProgram : Program {
    var redPosition = Point(x: 0, y: 0)
    var bluePosition = Point(x: 0, y: 0)
    var redDirection = 1
    var blueDirection = 1

    override func setup() {
        framesPerSecond = 30
//        canvasSize = Size(width: 100, height: 100)
    }
    
    override func update() {
        let newx = redPosition.x + redDirection
        if newx == canvas.maxX {
            redDirection = -1
        } else if newx == 0 {
            redDirection = 1
        }
        redPosition = Point(x: newx, y: canvas.midY)

        let newy = bluePosition.y + blueDirection
        if newy == canvas.maxY {
            blueDirection = -1
        } else if newy == 0 {
            blueDirection = 1
        }
        bluePosition = Point(x: canvas.midX, y: newy)
    }
    
    override func draw()  {
        canvas.setPoint(redPosition, toColor: Color.Red)
        canvas.setPoint(bluePosition, toColor: Color.Blue)
    }
    
}