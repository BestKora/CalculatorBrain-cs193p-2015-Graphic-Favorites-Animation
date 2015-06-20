//: Playground - noun: a place where people can play

import UIKit

class CalculatorFormatter: NSNumberFormatter {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.locale = NSLocale.currentLocale()
        self.numberStyle = .DecimalStyle
        self.maximumFractionDigits = 10
        self.notANumberSymbol = "Error"
        self.groupingSeparator = " "
        
    }
    
    // Swift 1.2 or above
    static let sharedInstance = CalculatorFormatter()
    
    /*    class var sharedInstance: CalculatorFormatter {
    struct Static {
    static let instance = CalculatorFormatter()
    }
    return Static.instance
    }*/
}

println(CalculatorFormatter.sharedInstance)

println(CalculatorFormatter.sharedInstance)

println(CalculatorFormatter.sharedInstance.stringFromNumber(20.00) ?? "")
println(CalculatorFormatter.sharedInstance.stringFromNumber(55550) ?? "")

class CalculatorBrain
{
    
    enum Result: Printable {
        case Value(Double)
        case Error(String)
        
        var description: String {
            switch self {
            case .Value(let value):
                return  CalculatorFormatter.sharedInstance.stringFromNumber(value) ?? ""
            case .Error(let errorMessage):
                return errorMessage
            }
        }
    }
}

// ГЛОБАЛЬНАЯ КОНСТАНТА

let formatter = CalculatorFormatter()
println(formatter)
println(formatter)
println(formatter.stringFromNumber(20.00) ?? "")
println(formatter.stringFromNumber(55550) ?? "")

func RandomShape(size : CGSize) -> UIBezierPath {
    func RandomFloat() -> CGFloat {return CGFloat(arc4random()) / CGFloat(UINT32_MAX)}
    func RandomPoint() -> CGPoint {return CGPointMake(size.width * RandomFloat(), size.height * RandomFloat())}
    let path = UIBezierPath(); path.moveToPoint(RandomPoint())
    for _ in 0..<(3 + Int(arc4random_uniform(numericCast(10)))) {
        switch (random() % 3) {
        case 0: path.addLineToPoint(RandomPoint())
        case 1: path.addQuadCurveToPoint(RandomPoint(), controlPoint: RandomPoint())
        case 2: path.addCurveToPoint(RandomPoint(), controlPoint1: RandomPoint(), controlPoint2: RandomPoint())
        default: break;
        }
    }
    path.closePath()
    return path
}
let mySize = CGSize (width: 150, height: 150)
RandomShape(mySize)
var alphabet = (65..<65 + 26).map{String(UnicodeScalar($0))}
println("\(alphabet)")
