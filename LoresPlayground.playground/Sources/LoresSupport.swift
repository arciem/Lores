import Lores
import PlaygroundSupport

public func run(program: Program) {
    let programView = ProgramView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    programView.translatesAutoresizingMaskIntoConstraints = true
    programView.program = program
    programView.program.didDisplay = {
        programView.flush()
    }

    let currentPage = PlaygroundPage.current
    currentPage.liveView = programView
    currentPage.needsIndefiniteExecution = true
    programView.program.display()
}
