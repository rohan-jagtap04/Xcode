//
//  SelectorViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-04-03.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit

class SelectorViewController: UIViewController {

    
    let hospitalSelection: UIButton = {
          
          let button = UIButton(type: .system)
          button.setTitle("Hospital", for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
          button.backgroundColor = .blue
          button.setTitleColor(.grey, for: .normal)
          button.heightAnchor.constraint(equalToConstant: 275).isActive = true
          button.layer.cornerRadius = 16
          button.clipsToBounds = true
          button.addTarget(self, action: #selector(segueToLoginOrRegister), for: .touchUpInside)
          button.imageView?.contentMode = .scaleAspectFill
          return button
      }()
    
    let Selection: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Hospital", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .blue
        button.setTitleColor(.grey, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(segueToLoginOrRegister), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @objc func segueToLoginOrRegister(){
        
    }

}
