// Playground - noun: a place where people can play

import UIKit
import XCPlayground
import Arciem
import Lores

println("Hello!")

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
        println("Setup")
        framesPerSecond = 5
        canvasSize = Size(width: 20, height: 20)
    }
    
    override func draw()  {
        println("Drawing")
        for _ in 1...50 {
            canvas.setPoint(canvas.randomPoint(), toColor: Color.randomColor())
        }
    }
    
    override func update() {
        println("Update")
    }
}

//let program = GravelProgram()
//
//let programView = ProgramView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
//programView.backgroundColor = UIColor.blackColor()
//programView.program = program
//programView.program.didDisplay = {
//    programView.flush()
//}
//programView.program.display()
//XCPShowView("programView", programView)
//
//let s = Serializer(name: "playground")
//s.dispatch { println("dispatched") }
//s.dispatchOnMain { println("dispatched on main") }
//dispatch_sync(dispatch_get_main_queue()) {
//    println("dispatched on main")
//}
//XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
