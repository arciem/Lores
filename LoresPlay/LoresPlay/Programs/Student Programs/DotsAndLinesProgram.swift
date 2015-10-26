import Lores

class DotsAndLinesProgram : Program {
    override func draw()  {
        let p = Point(x: 20, y: 15)
        let c = Color.Gold
        
        canvas.setPoint(p, toColor: c)
        canvas.setPoint(Point(x: 10, y: 29), toColor: Color.BlueGreen)
        canvas.setPoint(Point(x: 5, y: 17), toColor: Color.Green)
        canvas.setPoint(Point(x: 14, y: 10), toColor: Color.Purple)
        canvas.setPoint(Point(x: 22, y: 9), toColor: Color.Red)
        
        drawHorizontalLine(x1: 10, x2: 20, y: 3, toColor: Color.White)
        drawHorizontalLine(x1: 30, x2: 40, y: 25, toColor: Color.Red)
        drawHorizontalLine(x1: 15, x2: 18, y: 3, toColor: Color.Purple)
        drawHorizontalLine(x1: 2, x2: 39, y: 30, toColor: Color.randomColor())
        drawHorizontalLine(x1: 5, x2: 33, y: 30, toColor: Color.Orange)
        drawHorizontalLine(x1: 1, x2: 38, y: 1, toColor: Color.Purple)
        
        drawVerticalLine(y1: 1, y2: 22, x: 37, toColor: Color.randomColor())
        drawVerticalLine(y1: 1, y2: 5, x: 7, toColor: Color.Yellow)
        canvas.setPoint(Point(x: 37, y: 13), toColor: Color.Brown)
        drawVerticalLine(y1: 3, y2: 21, x: 27, toColor: Color.Magenta)
        drawVerticalLine(y1: 2, y2: 10, x: 27, toColor: Color.DarkGreen)
        drawVerticalLine(y1: 5, y2: 30, x: 1, toColor: Color.DeepBlue)
        drawVerticalLine(y1: 0, y2: 4, x: 1, toColor: Color.White)
        
        
        
    }
    
    func drawHorizontalLine(x1 x1: Int, x2: Int, y: Int, toColor color: Color) {
        for x in x1...x2 {
            canvas.setPoint(Point(x: x, y: y), toColor: color)
        }
    }
    
    func drawVerticalLine(y1 y1: Int, y2: Int, x: Int, toColor color: Color) {
        for y in y1...y2 {
            canvas.setPoint(Point(x: x, y: y), toColor: color)
        }
    }
}
