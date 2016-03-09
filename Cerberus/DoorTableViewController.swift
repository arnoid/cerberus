//
//  DoorTableViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 09/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import UIKit

class DoorTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    let doorCellIdentifier = "DoorTableCell"
    
    var doorController: DoorController!
    var doorDataSource: [CDoor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorController = AppDelegate.getAppDelegate().doorController
    }
    
    override func viewWillAppear(animated: Bool) {
        loadDoors()
    }
    
    @IBAction func logout() {
        exit(0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doorDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let door = doorDataSource[indexPath.row]
        let cell : UITableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier(doorCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(door.name! as String)"
        cell.detailTextLabel?.text = "\(door.details! as String)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let door : CDoor = doorDataSource[indexPath.row]
        print("\(door.objectID)")
        
        self.performSegueWithIdentifier("ShowDoorDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let door = doorDataSource[indexPath.row]
            doorDataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            doorController.deleteDoor(door)
        }
    }
    
    func loadDoors() {
        
        self.doorDataSource = self.doorController.readAllDoors()
        self.tableView.reloadData()
        
        //TODO: add progress indicator
        //I failed to dismiss UIAlertControll from within dispatch_async
        //dunno why
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowDoorDetails") {
            
            let doorDetailsViewController = segue.destinationViewController as! DoorDetailsViewController;
            
            let selectedRow = tableView.indexPathForSelectedRow
            
            if(selectedRow != nil) {
                let door = doorDataSource[(selectedRow?.row)!]
                tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
                
                doorDetailsViewController.selectedDoorObjectID = door.objectID
            }
            
        }
    }
}