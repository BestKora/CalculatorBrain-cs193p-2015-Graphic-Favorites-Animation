//
//  Graph.swift
//  CalculatorBrain
//

import UIKit

@IBDesignable
class GraphView: UIView {
    typealias yFunctionX = ( x: Double) -> Double?
    var yForX: yFunctionX?

    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    var originRelativeToCenter:CGPoint = CGPointZero { didSet {setNeedsDisplay()}}
   
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    private var origin: CGPoint  {
        get {
            var origin = originRelativeToCenter
            origin.x += graphCenter.x
            origin.y += graphCenter.y
            return origin
        }
        set {
            var origin = newValue
            origin.x -= graphCenter.x
            origin.y -= graphCenter.y
            originRelativeToCenter = origin
        }
    }

    private let axesDrawer = AxesDrawer(color: UIColor.blueColor())
    
    override func drawRect(rect: CGRect) {
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        drawCurveInRect(bounds, origin: origin, pointsPerUnit: scale)}
    
    func drawCurveInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat){
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var point = CGPoint()
        var firstValue = true

        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
         
            point.x = CGFloat(i) / contentScaleFactor
            if let y = (self.yForX)?(x: Double ((point.x - origin.x) / scale)) {
                if !y.isNormal && !y.isZero {
                    firstValue = true
                    continue
                }
                point.y = origin.y - CGFloat(y) * scale
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            } else {
                firstValue = true
            }
        }
        path.stroke()
    }
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    func originMove(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            if translation != CGPointZero {
                origin.x += translation.x
                origin.y += translation.y
                gesture.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    func origin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
}
