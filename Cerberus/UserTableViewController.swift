//
//  UserTableViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    let userCellIdentifier = "UserCell"
    let currentUserCellIdentifier = "CurrentUserCell"
    
    var userController: UserController!
    var uiNotificationController: UINotificationController!
    var userDataSource: [CUser] = [CUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate = AppDelegate.getAppDelegate()
        
        userController = appDelegate.userController
        uiNotificationController = appDelegate.uiNotificationController
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUsers()
    }
    
    @IBAction func logout() {
        exit(0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = userDataSource[indexPath.row]
        let cell : UITableViewCell
        
        if(user.objectID == AppDelegate.getAppDelegate().loggedInUser.objectID) {
            cell = tableView.dequeueReusableCellWithIdentifier(currentUserCellIdentifier, forIndexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier, forIndexPath: indexPath)
        }

        cell.textLabel?.text = "\(user.name! as String)"
        if(user.objectID == AppDelegate.getAppDelegate().loggedInUser.objectID) {
            cell.detailTextLabel?.text = "CURRENT USER"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(userController.checkIfRootUser(AppDelegate.getAppDelegate().loggedInUser)) {
            //for root user only
            createNewUser()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    @IBAction func createNewUser() {
        if(userController.checkIfRootUser(AppDelegate.getAppDelegate().loggedInUser)) {
        //for root user only
            self.performSegueWithIdentifier("ShowUserDetails", sender: self)
        } else {
            uiNotificationController.showFailMessage("Access denied", subtitle: "You need to be a root user to access this functionality")
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(userController.checkIfRootUser(userDataSource[indexPath.row])
            || userDataSource[indexPath.row].objectID == AppDelegate.getAppDelegate().loggedInUser.objectID) {
            //restrict deletion of root user and current logged-in user
            return false
        } else if (userController.checkIfRootUser(AppDelegate.getAppDelegate().loggedInUser)) {
            //let edit for root user only
            return true
        } else {
            //other cases
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let user = userDataSource[indexPath.row]
            userDataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            userController.deleteUser(user)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowUserDetails") {
            
            let userDetailsViewController = segue.destinationViewController as! UserDetailsViewController;
            
            let selectedRow = tableView.indexPathForSelectedRow
            
            if(selectedRow != nil) {
                let user = userDataSource[(selectedRow?.row)!]
                tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)

                userDetailsViewController.selectedUserObjectID = user.objectID
            }
            
        }
    }
    
    func loadUsers() {

        self.userDataSource = self.userController.readAllUsers()
        self.tableView.reloadData()
        
        //TODO: add progress indicator
        //I failed to dismiss UIAlertControll from within dispatch_async
        //dunno why
    }
    
}