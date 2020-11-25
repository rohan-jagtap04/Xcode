//
//  meetingTimeScheduleViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-28.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import PhoneNumberKit
import ContactsUI
import Firebase
import MessageUI

class meetingTimeScheduleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var hospitalCodeTextField: PhoneNumberTextField!
    
    @IBOutlet weak var meetingDateTextField: UITextField!
    
    @IBOutlet weak var dateRegisterButton: UIButton!
    
    @IBOutlet weak var alphanumericTextField: UITextField!
    
    let alphanumericKey = String.random()
    var User_name: String?
    
    private var dateAndTimePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alphanumericTextField.delegate = self as? UITextFieldDelegate
        alphanumericTextField.isHidden = true
        let phoneNumberKit = PhoneNumberKit()
        dateAndTimePicker = UIDatePicker()
        dateAndTimePicker?.datePickerMode = .dateAndTime
        dateAndTimePicker?.addTarget(self, action: #selector(meetingTimeScheduleViewController.dateChanged(dateAndTimePicker: )), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        meetingDateTextField.inputView = dateAndTimePicker
        
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
                textField.deleteBackward()
            }
    }
    
    // End Editing When User Taps Outside of Textfield Box & Selector
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    //Setting meetingDateTextField as the date that the user selected
   @objc func dateChanged(dateAndTimePicker: UIDatePicker){
      let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    meetingDateTextField.text = dateFormatter.string(from: dateAndTimePicker.date)
    
    }
    
    @IBAction func alphanumericTextFieldEditingDidChange(_ sender: Any) {
        // Checks if user input in text without spaces matches the random generated alphanumeric
        print("textfield: \(String(describing: alphanumericTextField.text))")
        if validateAlphanumericKey(text: alphanumericTextField.text!){
            //This is the correct password
            handleRegister()
            
        }
        
    }
    
    @IBAction func meetingDateSelectionBegan(_ sender: Any) {
        hospitalCodeTextField.text = String(phoneNumberTextField.text!.suffix(4))
    }
    
    @IBAction func dateRegisterButtonPressed(_ sender: Any) {
        //shoots of email with randomly generated alphanumeric code and shows the verification code textfield
        dateRegisterButton.addTarget(self, action: #selector(showMailComposer), for: .touchUpInside)
        alphanumericTextField.isHidden = false
        checkMaxLength(textField: hospitalCodeTextField, maxLength: 4)
        }
    
    
    
    func validateAlphanumericKey(text: String) -> Bool{
        //function for validating alphanumeric key code
        var result = false
        if text.trimmingCharacters(in: .whitespacesAndNewlines) == alphanumericKey{
            result = true
        }
        return result
    }
    
    @objc func handleRegister(){
        //Function for handling registration of Hospital accounts
        guard let email = emailTextField.text,let password = passwordTextField.text, let phoneNumber = phoneNumberTextField.text, let dateAndTime = meetingDateTextField.text, let hospitalCode = hospitalCodeTextField.text ,  let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        let numberCheck = Int(passwordTextField.text!)
         if numberCheck != nil{
             print("Your Password's Gotta Have Both Numbers & Letters")
            let alert = UIAlertController(title: "Error", message: "Password must contain Letters and Numbers.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
             return
         }else{
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            if let error = error {
                print(error)
                return
           }
            guard let uid = res?.user.uid else {
                return
            }
            Auth.auth().currentUser?.reload(completion: { (error) in
                    //successfully authenticated user (add more values later)
                    let ref = Database.database().reference()
                    let usersReference = ref.child("Hospitals").child(uid)
                let values = ["name": name, "email": email, "Phone Number": phoneNumber, "Date & Time": dateAndTime, "Hospital Code": hospitalCode]
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                            print(err)
                            return
                        }
                        print("Saved hospital successfully into Firebase db")
                        self.performSegue(withIdentifier: "successfulRegistration", sender: self)
                                                })
                                            }
              
                                    )
               
                            })
                    }
        }

    @objc func showMailComposer(){
                    // Shoots of mail containing alphanumeric key to rohjag18@gmail.com
                    let smtpSession = MCOSMTPSession()
                        smtpSession.hostname = "smtp.gmail.com"
                        smtpSession.username = "rohjag18@gmail.com"
                        smtpSession.password = "Sonicsir2017"
                        smtpSession.port = 465
                        smtpSession.authType = MCOAuthType.saslPlain
                        smtpSession.connectionType = MCOConnectionType.TLS
                        smtpSession.connectionLogger = {(connectionID, type, data) in
                            if data != nil {
                                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                                    NSLog("Connectionlogger: \(string)")
                                }
                            }
                        }
                        let builder = MCOMessageBuilder()
                    builder.header.to = [MCOAddress(displayName: "Rohan", mailbox: "rohjag18@gmail.com")!]
                        builder.header.from = MCOAddress(displayName: "Jagtap", mailbox: "rohjag18@gmail.com")
                        builder.header.subject = "Hospital Account Verification Key"
        builder.htmlBody = "<p>The alphanumeric key for this HOSPITAL account is: \(alphanumericKey).</p>\n <p>The name of the creator of this account who would like to meet you is:  \(String(describing: nameTextField.text!))</p> \n <p>The email of \(String(describing: nameTextField.text!)) is: \(String(describing: emailTextField.text!))</p> \n <p>The phone number of \(String(describing: nameTextField.text!)) is: \(String(describing: phoneNumberTextField.text!))</p> \n <p>The Hospital code is: \(String(describing: hospitalCodeTextField.text!))</p> \n <p>The meeting date is: \(String(describing: meetingDateTextField.text!))</p>"
                        
                        let rfc822Data = builder.data()
                        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
                        sendOperation?.start { (error) -> Void in
                            if (error != nil) {
                                NSLog("Error sending email: \(String(describing: error))")
                                
                                
                            } else {
                                NSLog("Successfully sent email!")
                                
                                
                            }
                    
                    }
                    

                    
                }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension meetingTimeScheduleViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error{
            controller.dismiss(animated: true)
            return
        }
        
        switch result{
        case .cancelled:
           print("Cancelled")
        break
        case .failed:
            print("Failed to Send")
            break
        case .saved:
            print("Saved")
            break
        case .sent:
            print("Email Sent")
            break
        default:
        break
        }
        controller.dismiss(animated: true)
    }
    
}
extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
