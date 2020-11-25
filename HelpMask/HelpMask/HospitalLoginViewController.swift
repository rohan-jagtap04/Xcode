//
//  HospitalLoginViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-28.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase

class HospitalLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var docRef: DocumentReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
       
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
     @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
            view.endEditing(true)
        }
    
     @objc func handleLogin() {
            
       
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                print("Form is not valid")
                return
            }
        let numberCheck = Int(passwordTextField.text!)
       
        if numberCheck != nil{
            print("Your Password's Gotta Have Both Numbers & Letters")
            let alert = UIAlertController(title: "Error", message: "Password must contain Letters and Numbers.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    print(error)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                //successfully logged in our user
                self.dismiss(animated: true, completion: nil)
                print("Successfully Logged In")
                self.performSegue(withIdentifier: "successfulHospitalLogin", sender: self)
            })
            
        

    }
    

}
}
