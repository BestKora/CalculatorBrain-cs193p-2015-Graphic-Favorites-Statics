//
//  Graph.swift
//  CalculatorBrain
//

import UIKit

@IBDesignable

class GraphView: UIView {
    let axesDrawer = AxesDrawer(color: UIColor.blueColor())
    
    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }

    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var origin: CGPoint? { didSet { setNeedsDisplay() }}
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }

    
    override func drawRect(rect: CGRect) {
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: origin ?? graphCenter,
                                   pointsPerUnit: scale)
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
                origin?.x += translation.x
                origin?.y += translation.y
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
