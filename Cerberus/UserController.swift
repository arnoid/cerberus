//
//  UserController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData

class UserController {
    
    func getManagedContext() -> NSManagedObjectContext {
        return AppDelegate.getAppDelegate().managedObjectContext
    }
    
    /*
    Creates new user with given name, email and password
    */
    func createUser(name: String , email: String, password: String) -> CUser {
        let managedContext = getManagedContext()
        
        let user = NSEntityDescription.insertNewObjectForEntityForName(CUser.ENTITY_USER, inManagedObjectContext: managedContext) as! CUser
        
        user.name = name
        user.email = email
        user.password = password
        
        do {
            try managedContext.save()
            
            print("User saved")
            return user
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil as CUser!
        
    }
    
    /*
    Retrieves a list of availableusers
    */
    func readAllUsers() -> [CUser] {
        
        let result : [CUser]
        
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(CUser.ENTITY_USER, inManagedObjectContext: managedContext)
        
        do {
            result = try managedContext.executeFetchRequest(fetchRequest) as! [CUser]
            
        } catch let fetchError as NSError {
            result = [CUser]()
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Retrieves user for given id
    */
    func readUserWith(objectID : NSManagedObjectID) -> CUser {
        
        let result : CUser
        
        let managedContext = getManagedContext()
        
        do {
            result = try managedContext.existingObjectWithID(objectID) as! CUser
        } catch let fetchError as NSError {
            result = nil as CUser!
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Retrieves user for given email and password if any
    */
    func readUserWith(email : String!, password: String!) -> CUser? {
        
        var result : CUser?
        
        let managedContext = getManagedContext()
        //TODO: Find if it is possible to create compound predicate out of single string format
        let userPredicates = [
            NSPredicate(format: "\(CUser.ENTITY_KEY_EMAIL) == %@", email, password),
            NSPredicate(format: "\(CUser.ENTITY_KEY_PASSWORD) == %@", password)
        ]
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: userPredicates)
        
        fetchRequest.entity = NSEntityDescription.entityForName(CUser.ENTITY_USER, inManagedObjectContext: managedContext)
        
        do {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchRequest) as! [CUser]

            if(fetchedEntities.count > 0) {
                //TODO: Because constraints for uniqueness are not implemented
                //we have to pick forst result
                result = fetchedEntities[0]
            }

        } catch let fetchError as NSError {
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Updates user
    */
    func updateUser(user : CUser) {
        let managedContext = getManagedContext()

        do {
            try managedContext.save()
        } catch let fetchError as NSError {
            print(fetchError)
        }
        
        return 
    }
    
    /*
    Delete user
    */
    func deleteUser(user : CUser) {
        getManagedContext().deleteObject(user)
    }
    
}