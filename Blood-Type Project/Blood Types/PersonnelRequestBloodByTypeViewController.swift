//
//  PersonnelRequestBloodByTypeViewController.swift
//  Blood Types
//
//  Created by Rohan Jagtap on 2020-04-13.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import ContactsUI

class PersonnelRequestBloodByTypeViewController: UIViewController {

    @IBOutlet weak var bloodTypeTextField: UITextField!
    
    @IBOutlet weak var requestButton: UIButton!
    
    let possibleBloodTypes: [String] = ["O+","O-","B-","B+","A-","A+","AB-","AB+","Corona Antibodies"]
       
    var selectedBloodType: String?
    
    var donorCollectionReference: DocumentReference!
    
    var information: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bloodTypePicker()
        createToolBar()
        
    }
    
    @IBAction func requestButtonPressed(_ sender: Any) {
        donorCollectionReference = Firestore.firestore().collection("Donor").document(selectedBloodType!)
        donorCollectionReference.getDocument { (document, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            }else{
                let data = document?.data()
                let email = data?["Email"] as? [String] ?? [""]
                let fullname = data?["Name"] as? [String] ?? [""]
                let previousDonationDate = data?["Previous Donation Date"] as? [String] ?? [""]
                let bloodType = data?["Blood Type"] as? String ?? ""
               
                
                print(email.count)
                for i in 0..<email.count{
                    
                    self.requestViaEmail(email: email[i], bloodType: bloodType, fullName: fullname[i], previousdate: previousDonationDate[i])
                    
                }
            }
        }
        /*
        donorCollectionReference.getDocuments { (snapshot, error) in
            if error != nil{
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            }else{
                for document in snapshot!.documents{
                    print(document.data())
                }
            }
        }*/
        
        
    }
    func requestViaEmail(email: String, bloodType: String, fullName: String, previousdate: String){
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
        builder.header.to = [MCOAddress(displayName: fullName, mailbox: email)!]
        builder.header.from = MCOAddress(displayName: "Rohan Jagtap", mailbox: "rohjag18@gmail.com")
        builder.header.subject = "\(bloodType) Request"
        builder.htmlBody = "<p>Greetings \(fullName)\n\n</p> <p>Due to increasing needs for blood, we have found a lack of type \(bloodType). As you are of that type, please donate whenever possible. \n\n Your/Their last appointment was \(previousdate), if that was over 60 days in the past, we inivte you to come in.</p> <p> Sincerely, \n\n</p> <p>Blood Works Team</p>"
                            
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
                    if (error != nil) {
                        NSLog("Error sending email: \(String(describing: error?.localizedDescription))")
                        } else {
                        NSLog("Successfully sent email!")
            }
        }
    }
    
    
    func bloodTypePicker(){
        let bloodPicker = UIPickerView()
        bloodPicker.delegate = self
        bloodTypeTextField.inputView = bloodPicker
    }
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        bloodTypeTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PersonnelRequestBloodByTypeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleBloodTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleBloodTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBloodType = possibleBloodTypes[row]
        bloodTypeTextField.text = selectedBloodType
    }
     
}
