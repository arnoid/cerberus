//
//  UINotificationController.swift
//  Cerberus
//
//  Created by Sergii Arnaut on 08/03/16.
//  Copyright © 2016 Sergii Arnaut. All rights reserved.
//

import Foundation
import UIKit

class UINotificationController {
    
    static let COLOR_RED : String = "#FF5252FF"
    static let COLOR_LIGHT_GREEN : String = "#C8E6C9FF"
    static let COLOR_GREEN : String = "#4CAF50FF"
    static let COLOR_DARK_GREEN : String = "#388E3CFF"
 
    func showMessage(title: String, subtitle: String, backgroundColor: UIColor) {
        let banner = Banner(title: title, subtitle: subtitle, backgroundColor: backgroundColor)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    func showSuccessMessage(title: String, subtitle: String) {
        showMessage(title, subtitle: subtitle, backgroundColor: UIColor(rgba: UINotificationController.COLOR_GREEN))
    }
    
    func showFailMessage(title: String, subtitle: String) {
        showMessage(title, subtitle: subtitle, backgroundColor: UIColor(rgba: UINotificationController.COLOR_RED))
    }
}