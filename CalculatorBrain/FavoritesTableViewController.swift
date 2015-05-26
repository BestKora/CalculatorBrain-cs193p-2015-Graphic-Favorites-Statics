//
//  FavoritesTableViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/13/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    typealias Delete = (FavoritesTableViewController, index:Int) -> ()
    typealias Finish = (FavoritesTableViewController, index:Int) -> ()
    typealias programDescription = (FavoritesTableViewController, index:Int) -> String?
    
    typealias PropertyList = AnyObject
    
    var didDelete: Delete?
    var didFinish: Finish?
    var descriptionProgram:programDescription?
    
    var programs = [PropertyList]()

    
    private struct Storyboard {
        static let CellReuseIdentifier = "Calculator Program Description"
        static let WidthPopover:CGFloat = 200

    }
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let descript = (self.descriptionProgram)?(self, index: indexPath.row) ?? ""
        cell.textLabel?.text = "y = " + descript
        return cell
    }
    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            (self.didFinish)?(self, index: indexPath.row)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
           programs.removeAtIndex(indexPath.row)
            (self.didDelete)?(self,  index: indexPath.row)
           tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                   }
    }
    
    override var preferredContentSize: CGSize {
        get {
            if programs.count > 0 && presentingViewController != nil {
                return tableView.sizeThatFits(CGSize(width:Storyboard.WidthPopover, height:presentingViewController!.view.bounds.size.height))
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
}
