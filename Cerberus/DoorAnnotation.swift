//
//  DoorAnnotation.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 09/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import MapKit

class DoorAnnotation: NSObject, MKAnnotation {
    var door: CDoor!
    
    var title: String? {
        get {
            return "\(door.name!)"
        }
    }
    var coordinate: CLLocationCoordinate2D
    var subtitle: String? {
        get {
            return "\(door.details!)"
        }
    }
    
    init(door: CDoor) {
        self.door = door
        self.coordinate = CLLocationCoordinate2D(latitude: door.latitude, longitude: door.longitude)
    }
}