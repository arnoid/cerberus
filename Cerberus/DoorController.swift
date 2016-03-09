//
//  DoorController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData

class DoorController {
    
    func getManagedContext() -> NSManagedObjectContext {
        return AppDelegate.getAppDelegate().managedObjectContext
    }
    
    func openDoor(door: CDoor, byUser: CUser, timestamp: Double) -> Bool {
        var result : Bool
        if((byUser.accessibleDoors!.contains(door))) {
            result = true
        } else {
            result = false
        }
        
        createDoorAccessEvent(byUser, door: door, authorized: result, timestamp: timestamp)
        
        return result
    }
    
    /*
    Creates new door with given name, email and password
    */
    func createDoor(name: String , details: String, latitude : Double, longitude: Double) -> CDoor {
        let managedContext = getManagedContext()
        
        let door = NSEntityDescription.insertNewObjectForEntityForName(CDoor.ENTITY_DOOR, inManagedObjectContext: managedContext) as! CDoor
        
        door.name = name
        door.details = details
        door.latitude = latitude
        door.longitude = longitude
        
        do {
            try managedContext.save()
            
            return door
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil as CDoor!
        
    }
    
    /*
    Retrieves a list of available doors
    */
    func readAllDoors() -> [CDoor] {
        
        let result : [CDoor]
        
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(CDoor.ENTITY_DOOR, inManagedObjectContext: managedContext)
        
        do {
            result = try managedContext.executeFetchRequest(fetchRequest) as! [CDoor]
            
        } catch let fetchError as NSError {
            result = [CDoor]()
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Retrieves door for given id
    */
    func readDoorWith(objectID : NSManagedObjectID) -> CDoor {
        
        let result : CDoor
        
        let managedContext = getManagedContext()
        
        do {
            result = try managedContext.existingObjectWithID(objectID) as! CDoor
        } catch let fetchError as NSError {
            result = nil as CDoor!
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Creates new door access event
    */
    func createDoorAccessEvent(user: CUser , door: CDoor, authorized : Bool, timestamp: Double) -> CDoorAccessEvent {
        let managedContext = getManagedContext()
        
        let doorAccessEvent = NSEntityDescription.insertNewObjectForEntityForName(CDoorAccessEvent.ENTITY_DOOR_ACCESS_EVENT, inManagedObjectContext: managedContext) as! CDoorAccessEvent
        
        doorAccessEvent.user = user
        doorAccessEvent.door = door
        doorAccessEvent.timestamp = timestamp
        doorAccessEvent.authorized = authorized
        
        do {
            try managedContext.save()
            
            return doorAccessEvent
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil as CDoorAccessEvent!
        
    }
    
    /*
    Retrieves a list of available doors access events
    */
    func readAllDoorsAccessEvents() -> [CDoorAccessEvent] {
        
        let result : [CDoorAccessEvent]
        
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: CDoorAccessEvent.ENTITY_KEY_TIMESTAMP, ascending: false)]
        
        fetchRequest.entity = NSEntityDescription.entityForName(CDoorAccessEvent.ENTITY_DOOR_ACCESS_EVENT, inManagedObjectContext: managedContext)
        
        do {
            result = try managedContext.executeFetchRequest(fetchRequest) as! [CDoorAccessEvent]
            
        } catch let fetchError as NSError {
            result = [CDoorAccessEvent]()
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Retrieves door access event for given id
    */
    func readDoorAccessEventWith(objectID : NSManagedObjectID) -> CDoorAccessEvent {
        
        let result : CDoorAccessEvent
        
        let managedContext = getManagedContext()
        
        do {
            result = try managedContext.existingObjectWithID(objectID) as! CDoorAccessEvent
        } catch let fetchError as NSError {
            result = nil as CDoorAccessEvent!
            print(fetchError)
        }
        
        return result
    }
    
    /*
    Delete door access event
    */
    func deleteDoorAccessEvent(doorAccessEvent : CDoorAccessEvent) {
        getManagedContext().deleteObject(doorAccessEvent)
    }
    
    /*
    Delete door
    */
    func deleteDoor(door : CDoor) {
        getManagedContext().deleteObject(door)
    }
    /*
    Updates door
    */
    func updateDoor(door : CDoor) {
        let managedContext = getManagedContext()
        
        do {
            try managedContext.save()
        } catch let fetchError as NSError {
            print(fetchError)
        }
        
        return
    }
}