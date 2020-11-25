//
//  RegisterViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-27.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
             let allowedCharacters = CharacterSet.decimalDigits
             let characterSet = CharacterSet(charactersIn: string)
             return allowedCharacters.isSuperset(of: characterSet)
    }

    
    @IBAction func registerButtonPressed(_ sender: Any) {
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
           view.endEditing(true)
       }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            //successfully authenticated user (add more values later)
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                
                print("Saved user successfully into Firebase db")
                self.performSegue(withIdentifier: "successfulRegistration", sender: self)
            })
            
        })
        
        
    }

}
