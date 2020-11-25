//
//  InformationExtractionHelperViewController.swift
//  Blood Types
//
//  Created by Rohan Jagtap on 2020-04-13.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit

class InformationExtractionHelperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    init?(email: String, name: String, bloodType: String, something: NSCoder) {
        super.init(coder: something)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
