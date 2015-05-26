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
        static let SegueIdentifierStatistics = "Show Statistics"
        static let SegueIdentifierFavorite = "Show Favorites"
        static let DefaultsKey = "StatisticsGraphViewController.Favorites"
    }
    
    var favoritePrograms: [PropertyList] {
        get { return defaults.objectForKey(StatisticsName.DefaultsKey) as? [PropertyList] ?? [] }
        set { defaults.setObject(newValue, forKey: StatisticsName.DefaultsKey) }
    }

    @IBAction func addFavorite() {
        if let favoriteProgram: PropertyList = program {
            favoritePrograms += [favoriteProgram]
        }
    }
   

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StatisticsName.SegueIdentifierStatistics:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = graphView.statistics.description
                }
            case StatisticsName.SegueIdentifierFavorite:
                if let ftvc = segue.destinationViewController as? FavoritesTableViewController {
                    if let ppc = ftvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    ftvc.programs = favoritePrograms
       
                    // finish closure
                    ftvc.didFinish = { [unowned self] controller, index in
                        // hide favorite scene
                        controller.dismissViewControllerAnimated(true, completion: nil)
                        self.program = self.favoritePrograms [index]
                    }
                    ftvc.didDelete = { [unowned self] (controller, index) in
                         self.favoritePrograms.removeAtIndex(index)
                    }
                    ftvc.descriptionProgram = { [unowned self] (controller, index) in
                        self.brain.program =  self.favoritePrograms[index]
                        self.brain.setVariable("M", value: 0)
                        return self.brain.description.componentsSeparatedByString(",").last ?? ""
                        
                    }

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

