//
//  DoorAccessEventsTableViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 08/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import UIKit

class DoorAccessEventsTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    let doorAccessEventCellIdentifier = "DoorAccessEventCell"
    
    var doorController: DoorController!
    var doorAccessEventDataSource: [CDoorAccessEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorController = AppDelegate.getAppDelegate().doorController
    }
    
    override func viewWillAppear(animated: Bool) {
        loadDoorAccessEvents()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doorAccessEventDataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let doorAccessEvent = doorAccessEventDataSource[indexPath.row]
        let cell : CDoorAccessEventTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier(doorAccessEventCellIdentifier, forIndexPath: indexPath) as! CDoorAccessEventTableViewCell
        
        cell.lblDoorName.text = "\(doorAccessEvent.door!.name!)"
        cell.lblUser.text = "by \(doorAccessEvent.user!.name!)"
        if(doorAccessEvent.authorized) {
            cell.lblValidityOfAccess.text = "AUTHORIZED"
            cell.backgroundColor = UIColor(rgba: UINotificationController.COLOR_GREEN)
        } else {
            cell.lblValidityOfAccess.text = "NOT AUTHORIZED"
            cell.backgroundColor = UIColor(rgba: UINotificationController.COLOR_RED)
        }
        
        let date = NSDate(timeIntervalSince1970: doorAccessEvent.timestamp)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format
        
        cell.lblDoorAccessTime.text = "\(dateFormatter.stringFromDate(date))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
        
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let doorAccessEvent = doorAccessEventDataSource[indexPath.row]
            doorAccessEventDataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            doorController.deleteDoorAccessEvent(doorAccessEvent)
        }
    }
    
    func loadDoorAccessEvents() {
        
        doorAccessEventDataSource = self.doorController.readAllDoorsAccessEvents()
        tableView.reloadData()
        
        //TODO: add progress indicator
        //I failed to dismiss UIAlertControll from within dispatch_async
        //dunno why
    }
    
}