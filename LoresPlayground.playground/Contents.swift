import Lores
import XCPlayground

class PlaygroundProgram : Program {
    
    override func draw()  {
        let p = Point(x: 0, y: 0)
        let c = Color.Red
        canvas.setPoint(p, toColor: c)
    }
    
}


public func runProgram() {
    let programView = ProgramView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    programView.backgroundColor = UIColor.redColor()
    programView.program = PlaygroundProgram()
    programView.program.didDisplay = {
        programView.flush()
    }
    
    let currentPage = XCPlayground.XCPlaygroundPage.currentPage
    currentPage.liveView = programView
    currentPage.needsIndefiniteExecution = true
    programView.program.display()
}


runProgram()
