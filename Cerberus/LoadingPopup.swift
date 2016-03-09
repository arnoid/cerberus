//
//  LoadingPopup.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 05/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//
import UIKit

class LoadingPopup {
    
    static func showPopup(message : String, ownerViewController: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        spinnerIndicator.center = CGPointMake(135.0, 65.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        ownerViewController.presentViewController(alertController, animated: false, completion: nil)
        
        return alertController
    }
}