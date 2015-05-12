//
//  StatisticsGraphViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/12/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class StatisticsGraphViewController: GraphViewController, UIPopoverPresentationControllerDelegate {
    
    private struct StatisticsName {
        static let SegueIdentifier = "Show Statistics"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StatisticsName.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = graphView.statistics.description
                }
            default: break
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!,
                                  traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
          return UIModalPresentationStyle.None
    }
}
