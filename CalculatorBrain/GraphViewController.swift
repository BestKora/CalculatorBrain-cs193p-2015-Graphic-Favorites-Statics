//
//  GraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/6/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    @IBOutlet weak var graphView: GraphView! { didSet {
        
        graphView.dataSource = self
        
        graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,
                                                                action: "scale:"))
        graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView,
                                                              action: "originMove:"))
        let tap = UITapGestureRecognizer(target: graphView, action: "origin:")
        tap.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tap)
        updateUI()
        }
    }
    
    private var cashData = [CGFloat : CGFloat]() 
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList? { didSet {
        brain.setVariable("M", value: 0)
        brain.program = program!
        cashData = [CGFloat : CGFloat]()
        updateUI()
        }
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
/*
    func y(x: CGFloat) -> CGFloat? {
          return cos (1.0/x ) * x
    }
*/
}

