//
//  CAlertEvent.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CDoorAccessEvent: NSManagedObject {
    
    static let ENTITY_DOOR_ACCESS_EVENT : String = "DoorAccessEvent"
    static let ENTITY_KEY_TIMESTAMP : String = "timestamp"
    static let ENTITY_KEY_AUTHORIZED : String = "authorized"
    
    @NSManaged var timestamp: NSTimeInterval
    @NSManaged var authorized: Bool
    @NSManaged var door: CDoor?
    @NSManaged var user: CUser?
    
}