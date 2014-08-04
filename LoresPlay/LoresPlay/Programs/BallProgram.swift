//  Created by Bevan Essman on 8/3/14.

import Lores

class BallProgram : Program {
//    var ball = Ball(location: Point(x: 0, y: 0), direction: Offset(dx: 1, dy: 1), color: Color.Red)
    var balls = [Ball]()
    
    override func setup() {
        framesPerSecond = 20
        
        for _ in 1...20  {
            let dx = Random.randomBoolean() ? 1 : -1
            let dy = Random.randomBoolean() ? 1 : -1

            var ball = BallProgram.Ball(location: canvas.randomPoint(), direction: Offset(dx: dx, dy: dy), color: Color.randomColor())
            balls.append(ball)
        }
    }
    
    override func update() {
        for ball in balls {
            ball.update(canvas)
        }
    }
    
    override func draw() {
        for ball in balls {
            ball.draw(canvas)
        }
    }
    
    class Ball {
        var location: Point
        var direction: Offset
        let color: Color
        
        init(location: Point, direction: Offset, color: Color) {
            self.location = location
            self.direction = direction
            self.color = color
        }
        
        func update(canvas: Canvas) {
            var newDX = direction.dx
            var newDY = direction.dy
            
            if location.y + newDY > canvas.maxY {
                newDY = -1
            }
            if location.y + newDY < canvas.minY {
                newDY = 1
            }
            
            
            if location.x + newDX > canvas.maxX {
                newDX = -1
            }
            if location.x + newDX < canvas.minX {
                newDX = 1
            }
            
            
            let newX = location.x + newDX
            let newY = location.y + newDY
            
            location = Point(x: newX, y: newY)
            direction = Offset(dx: newDX, dy: newDY)
        }
        
        func draw(canvas: Canvas) {
            canvas.setPoint(location, toColor: color)
        }
    }
}
