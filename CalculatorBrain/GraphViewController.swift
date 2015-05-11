//
//  GraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/6/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,
                action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView,
                action: "originMove:"))
            let tap = UITapGestureRecognizer(target: graphView, action: "origin:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
            
            graphView.scale = scale
            graphView.originRelativeToCenter = originRelative
            updateUI()
        }
    }
    
    
    typealias PropertyList = AnyObject
    var program: PropertyList? { didSet {
        brain.setVariable("M", value: 0)
        brain.program = program!
        cashData = [CGFloat : CGFloat]()
        updateUI()
        }
    }
    
    private var cashData = [CGFloat : CGFloat]()
    private var brain = CalculatorBrain()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private struct Keys {
        static let Scale = "GraphViewController.Scale"
        static let Origin = "GraphViewController.Origin"
    }

    
    func updateUI() {
        graphView?.setNeedsDisplay()
        title = brain.description != "?" ? brain.description : "График"
    }

    // dataSource метод протокола GraphViewDataSource
    func y(x: CGFloat) -> CGFloat? {
        if let yCash = cashData [x] {return yCash}
        
        brain.setVariable("M", value: Double (x))
        if let y = brain.evaluate() {
            cashData [x] = CGFloat(y)
            return CGFloat(y)
        }
        return nil
    }
    
    private var scale: CGFloat {
        get { return defaults.objectForKey(Keys.Scale) as? CGFloat ?? 50.0 }
        set { defaults.setObject(newValue, forKey: Keys.Scale) }
    }
    
    private var originRelative: CGPoint {
        get {
            var origin = CGPointZero
            if let originArray = defaults.objectForKey(Keys.Origin) as? [CGFloat] {
                origin.x = originArray.first!
                origin.y = originArray.last!
            }
            return origin
        }
        set {
                defaults.setObject([newValue.x, newValue.y], forKey: Keys.Origin)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        scale = graphView.scale
        originRelative = graphView.originRelativeToCenter
    }
    
}

