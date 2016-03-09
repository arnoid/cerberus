//
//  CreateNewUserController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData

class UserDetailsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var txtUserName : UITextField!
    @IBOutlet var txtUserEmail : UITextField!
    @IBOutlet var txtUserPassword : UITextField!
    @IBOutlet var btnDone : UIBarButtonItem!
    
    @IBOutlet var doorsTableView : UITableView!
    
    var doorDataSource : [CDoor]!
    var selectedDoors = [CDoor]()
    
    var selectedUserObjectID : NSManagedObjectID!
    var user: CUser!
    var userController: UserController!
    var doorController: DoorController!
    var uiNotificationController: UINotificationController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let appDelegate = AppDelegate.getAppDelegate()
        
        userController = appDelegate.userController
        doorController = appDelegate.doorController
        uiNotificationController = appDelegate.uiNotificationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if(selectedUserObjectID != nil) {
            user = userController.readUserWith(selectedUserObjectID)
            
            if(user != nil) {
                txtUserName.text = user.name!
                txtUserEmail.text = user.email!
                txtUserPassword.text = user.password!
                
                //TODO: this should be a table view, because we dont know how many doors there can be
                // also we can bound table view cell directly to door instance
                if(user.accessibleDoors != nil) {
                    selectedDoors = Array(user.accessibleDoors!)
                } else {
                    selectedDoors = [CDoor]()
                }
                
            }
        }
        
        self.doorDataSource = self.doorController.readAllDoors()
        doorsTableView.reloadData()
    }
    
    @IBAction func doneNewUserCreationClick() {
        
        
        guard (TextFieldStringValidator.isEmailValid(txtUserEmail.text, errorMessageHandler: showErrorMessage)
            && TextFieldStringValidator.isPasswordValid(txtUserPassword.text, errorMessageHandler: showErrorMessage)
            && TextFieldStringValidator.isUserNameValid(txtUserName.text, errorMessageHandler: showErrorMessage)) else {
                return
        }
        
        if(user != nil) {
            user.name = txtUserName.text
            user.email = txtUserEmail.text
            user.password = txtUserPassword.text
            
            userController.updateUser(user)
        } else {
            user = userController.createUser(txtUserName.text!, email: txtUserEmail.text!, password: txtUserPassword.text!)
        }
        
        let selectedRows = doorsTableView.indexPathsForSelectedRows?.map{$0.row}
        var accessibleDoors : [CDoor] = [CDoor]()
        if(selectedRows != nil) {
            for selectedRow in selectedRows! {
                accessibleDoors.append(doorDataSource[selectedRow])
            }
        }
        
        user.accessibleDoors = Set(selectedDoors)
        userController.updateUser(user)
        
        if(AppDelegate.getAppDelegate().loggedInUser.objectID == user.objectID) {
            AppDelegate.getAppDelegate().loggedInUser = user
        }
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        
    }
    
    func findDoorInArray(doors: Set<CDoor>, name: String) -> [CDoor] {
        return doors.filter({$0.name == name})
    }
    
    func showErrorMessage(message: String!) -> Void {
        uiNotificationController.showFailMessage("Validation error", subtitle: (message))
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
        
        cell = tableView.dequeueReusableCellWithIdentifier("DoorTableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(door.name! as String)"
        cell.detailTextLabel?.text = "\(door.details! as String)"

        if selectedDoors.contains(door) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedDoor = doorDataSource[indexPath.row]
        let cellView = tableView.cellForRowAtIndexPath(indexPath)
        if(selectedDoors.contains(selectedDoor)) {
            selectedDoors = selectedDoors.filter({$0.objectID != selectedDoor.objectID})
            cellView?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            selectedDoors.append(selectedDoor)
            cellView?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}
