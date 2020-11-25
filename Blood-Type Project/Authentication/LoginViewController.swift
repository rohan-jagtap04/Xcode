//
//  LoginViewController.swift
//  Blood Types
//
//  Created by Rohan Jagtap on 2020-04-13.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //UI Elements (IB Actions)
    @IBOutlet weak var loginTypeSelecter: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        //Makes sure email isnt blank
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email != "" && password != ""{
            if loginTypeSelecter.selectedSegmentIndex == 0 {
                //Donator
                Auth.auth().signIn(withEmail: email, password: password) { (AuthResult, error) in
                    if error != nil{
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        self.performSegue(withIdentifier: "donatorLoginSuccessful", sender: self)
                        print("Successful Donator Sign In")
                    }
                }
                
            }else if loginTypeSelecter.selectedSegmentIndex == 1{
                //Personnel
                Auth.auth().signIn(withEmail: email, password: password) { (AuthResult, error) in
                    if error != nil{
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        self.performSegue(withIdentifier: "personnelLoginSuccessful", sender: self)
                        print("Successful Personnel Sign In")
                    }
                }
            }
            
        }else{
            displayAlert(title: "Error", message: "Please fill in all fields.")
        }
        
        
        
    }
    
   
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
