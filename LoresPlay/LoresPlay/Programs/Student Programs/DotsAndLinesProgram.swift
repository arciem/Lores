import Lores

class DotsAndLinesProgram : Program {
    override func draw()  {
        let p = Point(x: 20, y: 15)
        let c = Color.gold

        canvas[p] = c
        canvas[10, 29] = .blueGreen
        canvas[5, 17] = .green
        canvas[14, 10] = .purple
        canvas[22, 9] = .red
        
        drawHorizontalLine(x1: 10, x2: 20, y: 3, toColor: .white)
        drawHorizontalLine(x1: 30, x2: 40, y: 25, toColor: .red)
        drawHorizontalLine(x1: 15, x2: 18, y: 3, toColor: .purple)
        drawHorizontalLine(x1: 2, x2: 39, y: 30, toColor: .random())
        drawHorizontalLine(x1: 5, x2: 33, y: 30, toColor: .orange)
        drawHorizontalLine(x1: 1, x2: 38, y: 1, toColor: .purple)
        
        drawVerticalLine(y1: 1, y2: 22, x: 37, toColor: .random())
        drawVerticalLine(y1: 1, y2: 5, x: 7, toColor: .yellow)

        canvas[37, 13] = .brown
        
        drawVerticalLine(y1: 3, y2: 21, x: 27, toColor: .magenta)
        drawVerticalLine(y1: 2, y2: 10, x: 27, toColor: .darkGreen)
        drawVerticalLine(y1: 5, y2: 30, x: 1, toColor: .deepBlue)
        drawVerticalLine(y1: 0, y2: 4, x: 1, toColor: .white)
    }
    
    func drawHorizontalLine(x1: Int, x2: Int, y: Int, toColor color: Color) {
        for x in x1...x2 {
            canvas[x, y] = color
        }
    }
    
    func drawVerticalLine(y1: Int, y2: Int, x: Int, toColor color: Color) {
        for y in y1...y2 {
            canvas[x, y] = color
        }
    }
}
