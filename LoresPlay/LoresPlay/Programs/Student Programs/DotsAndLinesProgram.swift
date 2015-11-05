import Lores

class DotsAndLinesProgram : Program {
    override func draw()  {
        let p = Point(x: 20, y: 15)
        let c = Color.Gold

        canvas[p] = c
        canvas[10, 29] = .BlueGreen
        canvas[5, 17] = .Green
        canvas[14, 10] = .Purple
        canvas[22, 9] = .Red
        
        drawHorizontalLine(x1: 10, x2: 20, y: 3, toColor: .White)
        drawHorizontalLine(x1: 30, x2: 40, y: 25, toColor: .Red)
        drawHorizontalLine(x1: 15, x2: 18, y: 3, toColor: .Purple)
        drawHorizontalLine(x1: 2, x2: 39, y: 30, toColor: .randomColor())
        drawHorizontalLine(x1: 5, x2: 33, y: 30, toColor: .Orange)
        drawHorizontalLine(x1: 1, x2: 38, y: 1, toColor: .Purple)
        
        drawVerticalLine(y1: 1, y2: 22, x: 37, toColor: .randomColor())
        drawVerticalLine(y1: 1, y2: 5, x: 7, toColor: .Yellow)

        canvas[37, 13] = .Brown
        
        drawVerticalLine(y1: 3, y2: 21, x: 27, toColor: .Magenta)
        drawVerticalLine(y1: 2, y2: 10, x: 27, toColor: .DarkGreen)
        drawVerticalLine(y1: 5, y2: 30, x: 1, toColor: .DeepBlue)
        drawVerticalLine(y1: 0, y2: 4, x: 1, toColor: .White)
        
        
        
    }
    
    func drawHorizontalLine(x1 x1: Int, x2: Int, y: Int, toColor color: Color) {
        for x in x1...x2 {
            canvas[x, y] = color
        }
    }
    
    func drawVerticalLine(y1 y1: Int, y2: Int, x: Int, toColor color: Color) {
        for y in y1...y2 {
            canvas[x, y] = color
        }
    }
}
