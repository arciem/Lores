// Playground - noun: a place where people can play

//import UIKit
import XCPlayground
//import Arciem
import Lores

println("Hello!")
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

class HelloPixelProgram : Program {
    
    override func draw()  {
        let p = Point(x: canvas.midX, y: canvas.midY)
        let c = Color.Red
        canvas.setPoint(p, toColor: c)
    }
    
}

class PebblesProgram : Program {
    
    override func draw() {
        for _ in 1...50 {
            let p = canvas.randomPoint()
            let c = Color.randomColor()
            canvas.setPoint(p, toColor: c)
        }
    }
    
}

class GravelProgram : Program {
    
    override func setup() {
//        println("Setup")
        framesPerSecond = 30
        canvasSize = Size(width: 40, height: 40)
    }
    
    override func draw()  {
//        println("Drawing")
        for _ in 1...50 {
            canvas.setPoint(canvas.randomPoint(), toColor: Color.randomColor())
        }
    }
    
    override func update() {
//        println("Update")
    }
}

let program = GravelProgram()

let programView = ProgramView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
programView.backgroundColor = UIColor.blackColor()
programView.program = program
programView.program.didDisplay = {
    programView.flush()
}
XCPShowView("programView", programView)
