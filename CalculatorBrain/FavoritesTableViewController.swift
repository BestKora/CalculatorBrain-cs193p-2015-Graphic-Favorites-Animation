//
//  FavoritesTableViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 5/13/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    typealias Select = (FavoritesTableViewController, index:Int) -> ()
    var didSelect: Select?
    
    typealias Delete = (FavoritesTableViewController, index:Int) -> ()
    var didDelete: Delete?
    
    typealias descriptionData = (FavoritesTableViewController, index:Int) -> String?
    var descriptionProgram:descriptionData?

    
    typealias PropertyList = AnyObject
    var programs = [PropertyList]()

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
                                                                                 -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier,
                                                       forIndexPath: indexPath) as! UITableViewCell
        
        let descript = (self.descriptionProgram)?(self, index: indexPath.row) ?? ""
        cell.textLabel?.text = "y = " + descript
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            (self.didSelect)?(self, index: indexPath.row)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                                        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.Delete {
                programs.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                (self.didDelete)?(self,  index: indexPath.row)
                
            }
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "Calculator Program Description"
        static let WidthPopover:CGFloat = 250
        
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
