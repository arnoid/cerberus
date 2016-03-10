//
//  DoorDetailsViewController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 09/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class DoorDetailsViewController : UIViewController, MKMapViewDelegate {
    @IBOutlet var txtDoorName : UITextField!
    @IBOutlet var txtDoorDetails : UITextField!
    @IBOutlet var btnSave : UIBarButtonItem!
    @IBOutlet var mapView : MKMapView!
    
    var selectedDoorObjectID : NSManagedObjectID!
    
    var doorController: DoorController!
    var uiNotificationController : UINotificationController!
    var door: CDoor?

    //TODO: Reconfigure later
    let initialLocation = CLLocation(latitude: 52.371669433095313, longitude: 4.909041686425617)
    let regionRadius: CLLocationDistance = 50
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let appDelegate = AppDelegate.getAppDelegate()
        
        doorController = appDelegate.doorController
        uiNotificationController = appDelegate.uiNotificationController
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        
        let mapCenterLocation: CLLocation!
        
        if(selectedDoorObjectID != nil) {
            door = doorController.readDoorWith(selectedDoorObjectID)
            
            if(door != nil) {
                txtDoorName.text = door!.name!
                txtDoorDetails.text = door!.details!
            }
            
            let doorAnnotation = DoorAnnotation(door: door!)
            showAnnotationAtCoordinates(CLLocationCoordinate2D(latitude: door!.latitude, longitude: door!.longitude))
            
            mapView.addAnnotation(doorAnnotation)
            mapCenterLocation = CLLocation(latitude: door!.latitude, longitude: door!.longitude)
        } else {
            mapCenterLocation = initialLocation
        }
        

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapCenterLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

    }
    
    func handleLongPress(getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .Began { return }
        
        let touchPoint = getstureRecognizer.locationInView(self.mapView)
        showAnnotationAtCoordinates(mapView.convertPoint(touchPoint, toCoordinateFromView: mapView))
        
    }
    
    func showAnnotationAtCoordinates(coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func saveDoor() {
        
        guard !(txtDoorName.text!.isEmpty) else {
            uiNotificationController.showFailMessage("Validation error", subtitle: "Door name is empty")
            return
        }
        
        guard !(txtDoorDetails.text!.isEmpty) else {
            uiNotificationController.showFailMessage("Validation error", subtitle: "Door details are empty")
            return
        }
        
        guard mapView.annotations.count > 0 else {
            uiNotificationController.showFailMessage("Validation error", subtitle: "Select door location on map")
            return
        }

        let doorCoordinate = mapView.annotations[0].coordinate
        
        if(self.door == nil) {
            self.door = doorController.createDoor("\(txtDoorName!.text!)", details: "\(txtDoorDetails!.text!)", latitude: doorCoordinate.latitude, longitude: doorCoordinate.longitude)
        } else {
            self.door!.name = "\(txtDoorName!.text!)"
            self.door!.details = "\(txtDoorName!.text!)"
            self.door!.longitude = doorCoordinate.longitude
            self.door!.latitude = doorCoordinate.latitude
            
            doorController.updateDoor(self.door!)
        }
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
}