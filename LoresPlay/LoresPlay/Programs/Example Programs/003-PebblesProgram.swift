import Lores

class PebblesProgram: Program {

    override func draw() {
        for _ in 1...50 {
            let p = canvas.randomPoint()
            let c = Color.random()
            canvas[p] = c
        }
    }
    
}
