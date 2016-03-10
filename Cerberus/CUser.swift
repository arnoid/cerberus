//
//  CUser.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 06/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CUser: NSManagedObject {
    
    static let ENTITY_USER : String = "User"
    static let ENTITY_KEY_NAME : String = "name"
    static let ENTITY_KEY_EMAIL : String = "email"
    static let ENTITY_KEY_PASSWORD : String = "password"
    static let ENTITY_KEY_ACCESSIBLE_DOORS : String = "accessible_doors"
    
    static let ROOT_USER_NAME : String = "RootUser"
    static let ROOT_USER_EMAIL : String = "root@root.root"
    static let ROOT_USER_PASSWORD : String = "root"
    
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var accessibleDoors: Set<CDoor>?
    
}