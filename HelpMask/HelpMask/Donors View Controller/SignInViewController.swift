//
//  SignInViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-27.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
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
           
             
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
           view.endEditing(true)
       }
    
    @objc func handleLogin() {
        let ref = Database.database().reference()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            let userFirstChild = "user"
            
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
            self.performSegue(withIdentifier: "successfulLogin", sender: self)
            })
        
    

}
}
