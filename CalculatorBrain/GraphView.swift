//
//  Graph.swift
//  CalculatorBrain
//

import UIKit

struct Statistics:Printable {
    var description :String {
        formatter.maximumFractionDigits = 5
        let minString =  " \n min = " + formatter.stringFromNumber(min)!
        let maxString =  " \n max = " + formatter.stringFromNumber(max)!
        let avgString =  " \n avg = " + formatter.stringFromNumber(avg)!
        let string = "num = \(num)" +
                            minString +
                            maxString +
                            avgString + " \n"
        formatter.maximumFractionDigits = 10
        return string
    }
    
    var num: Int = 0
    var avg: CGFloat = 0
    var min: CGFloat = 0
    var max: CGFloat = 0
    
    mutating func calculate (y:CGFloat) {
        if num == 0 {
            min = y
            max = y
        }
        num++
        avg = avg + (y - avg) / CGFloat(num)
        if y < min {min = y}
        if y > max {max = y}
    }
}

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    weak var dataSource: GraphViewDataSource?

    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    var originRelativeToCenter:CGPoint = CGPointZero { didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    var statistics:Statistics = Statistics ()
    
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
    private var lightAxes:Bool = false // рисуем и оцифровываем засечки на осях
    private var lightCurve:Bool = false // рисуем график

    private var snapshot:UIView?
   
    
    override func drawRect(rect: CGRect) {
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale,
                                                                  light: lightAxes)
        if !lightCurve {
            drawCurveInRect(bounds, origin: origin, pointsPerUnit: scale)}
    }
    
    func drawCurveInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat){
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var point = CGPoint()
        var firstValue = true
        // --- обнуление statistics
        statistics = Statistics ()

        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
         
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    firstValue = true
                    continue
                }
                //------- расчет statistics
                statistics.calculate(y)
 
                point.y = origin.y - y * scale
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
         switch gesture.state {
        case .Began:
           lightAxes = true
        case .Changed:
            scale *= gesture.scale
            gesture.scale = 1.0
         case .Ended:
            lightAxes = false
            setNeedsDisplay()
         default: break
        }
    }
    
    func originMove1(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            lightAxes = true
        case .Changed:
            let translation = gesture.translationInView(self)
            origin.x += translation.x
            origin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        case .Ended:
            lightAxes = false
            setNeedsDisplay()
        default: break
        }
    }
    
    func scale2(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Began:
            snapshot = self.snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.8
            self.addSubview(snapshot!)
        case .Changed:
            let touch = gesture.locationInView(self)
            snapshot!.frame.size.height *= gesture.scale
            snapshot!.frame.size.width *= gesture.scale
            snapshot!.frame.origin.x = snapshot!.frame.origin.x * gesture.scale + (1 - gesture.scale) * touch.x
            snapshot!.frame.origin.y = snapshot!.frame.origin.y * gesture.scale + (1 - gesture.scale) * touch.y
            gesture.scale = 1.0
        case .Ended:
            let changedScale = snapshot!.frame.height / self.frame.height
            scale *= changedScale
            origin.x = origin.x * changedScale + snapshot!.frame.origin.x
            origin.y = origin.y * changedScale + snapshot!.frame.origin.y
            snapshot!.removeFromSuperview()
            snapshot = nil
            setNeedsDisplay()
        default: break
        }
    }

    func originMove(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            lightAxes = true
            lightCurve = true
            snapshot = self.snapshotViewAfterScreenUpdates(false)
            snapshot!.alpha = 0.4
            self.addSubview(snapshot!)
        case .Changed:
            let translation = gesture.translationInView(self)
            if translation != CGPointZero {
                origin.x += translation.x
                origin.y += translation.y
                gesture.setTranslation(CGPointZero, inView: self)
            }
        case .Ended:
               snapshot!.removeFromSuperview()
               snapshot = nil
               lightAxes = false
               lightCurve = false
               setNeedsDisplay()
        default: break
        }
    }
    

    
    func origin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }

}
