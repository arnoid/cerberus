//
//  DoorLocationViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 07/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import BRYXBanner

class DoorLocationViewController : UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblDoorLabel: UILabel!
    @IBOutlet var prgrLoadingProgress: UIProgressView!
    
    var userController : UserController!
    var doorController : DoorController!
    var uiNotificationController : UINotificationController!
    
    let regionRadius: CLLocationDistance = 50

    let initialLocation = CLLocation(latitude: 52.371669433095313, longitude: 4.909041686425617)
    
    let COUNTER_MAX_VALUE = 1000
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / Float(COUNTER_MAX_VALUE)
            let animated = counter != 0
            
            prgrLoadingProgress.setProgress(fractionalProgress, animated: animated)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let appDelegate = AppDelegate.getAppDelegate()
        
        userController = appDelegate.userController
        doorController = appDelegate.doorController
        uiNotificationController = appDelegate.uiNotificationController
    }
    
    override func viewWillAppear(animated: Bool) {
        let doors = doorController.readAllDoors()
        
        for door in doors {
            let doorAnnotation = DoorAnnotation(door: door)
            mapView.addAnnotation(doorAnnotation)
        }
        
        mapView.delegate = self
        
        let selectedDoor = getDoorForSelectedAnnotation()
        
        if selectedDoor != nil {
            updateDoorOpenerFor(selectedDoor!)
        }
        
    }
    
    func getDoorForSelectedAnnotation() -> CDoor? {
        var result: CDoor?
        
        if mapView.selectedAnnotations.count > 0 {
            result = (mapView.selectedAnnotations[0] as! DoorAnnotation).door
        }
        
        return result
    }
    
    override func viewDidAppear(animated: Bool) {
        centerMapOnLocation(initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        updateDoorOpenerFor(getDoorForSelectedAnnotation()!)
    }
    
    func updateDoorOpenerFor(door: CDoor) {
        lblDoorLabel.text = door.name!
    }
    
    @IBAction func openDoorButtonClick() {
        let door: CDoor? = getDoorForSelectedAnnotation()
        
        if(door == nil) {
            uiNotificationController.showFailMessage("Select door first", subtitle: "Tap on map pin to select door")
        } else {
            let doorOpened = doorController.openDoor(door!, byUser: AppDelegate.getAppDelegate().loggedInUser, timestamp: NSDate().timeIntervalSince1970)
            
            if(doorOpened) {
                
                self.counter = 0
                for _ in 0..<COUNTER_MAX_VALUE {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        sleep(1)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.counter++
                            if(self.counter == self.COUNTER_MAX_VALUE) {
                                self.counter = 0
                                self.uiNotificationController.showSuccessMessage("\(door!.name!)", subtitle: "Door is opened")
                            }
                            return
                        })
                    })
                }
            } else {
                //For now the only case for failed opening door is - user restricted to open that door
                uiNotificationController.showFailMessage("\(door!.name!)", subtitle: "Access restricted!!!")
            }
        }
    }
    
    @IBAction func openDoorsList() {
        self.performSegueWithIdentifier("ShowDoorsList", sender: self)
    }
    
}