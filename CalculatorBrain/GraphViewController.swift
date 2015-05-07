//
//  GraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/6/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView! { didSet {
        
        graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView,
                                                                action: "scale:"))
        graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView,
                                                              action: "originMove:"))
        let tap = UITapGestureRecognizer(target: graphView, action: "origin:")
        tap.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tap)
        }
    }
}

