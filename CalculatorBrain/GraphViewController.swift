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
    
    // Свойство, запоминающее результаты оценки стэка,
    // сделанные в Моделе CalculatorBrain
    // Его тип Result определен как перечисление enum
    // в Моделе CalculatorBrain
    
    var displayResult: CalculatorBrain.Result  = .Value(0.0)
    
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    var program: PropertyList? { didSet {
        brain.setVariable("M", value: 0)
        brain.program = program!
        title = brain.description == "" ? "Graph" : brain.description
        updateUI()
        }
    }
    
    func updateUI() {
        graphView?.setNeedsDisplay()
    }

// dataSource метод протокола GraphViewDataSource
    func y(x: CGFloat) -> CGFloat? {
        brain.setVariable("M", value: Double(x))
        displayResult = brain.evaluateAndReportErrors()
        switch displayResult {
        case .Value(let y): return CGFloat(y)
        case .Error: return nil
        }
    }
/*
    func y(x: CGFloat) -> CGFloat? {
          return cos (1.0/x ) * x
    }
*/
}

