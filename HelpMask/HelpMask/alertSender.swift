//
//  alertSender.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-27.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//


import Foundation
import UIKit

class createAlerts {
func createAlert(title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //Create OK Button
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        alert.dismiss(animated: true, completion: nil)
        print("Alert Acknowledged")
    }))
}
}
