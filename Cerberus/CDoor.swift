//
//  CDoor.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CDoor: NSManagedObject {
    
    static let DOOR_INNER = "Inner door"
    static let DOOR_OUTER = "Outer door"
    
    static let ENTITY_DOOR : String = "Door"
    static let ENTITY_KEY_DETAILS : String = "details"
    static let ENTITY_KEY_NAME : String = "name"

    @NSManaged var details: String?
    @NSManaged var name: String?
    @NSManaged var longitude: Double
    @NSManaged var latitude: Double
    
}
