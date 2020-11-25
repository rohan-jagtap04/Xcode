//
//  RegistrationViewController.swift
//  Blood Types
//
//  Created by Rohan Jagtap on 2020-04-13.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase
import PhoneNumberKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    //UI Elements (IB Actions)

    
    @IBOutlet weak var registerTypeSelecter: UISegmentedControl!
    
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bloodTypeTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBOutlet weak var previousDonationDate: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var coronaButton: UIButton!
    
    
    let possibleBloodTypes: [String] = ["O+","O-","B-","B+","A-","A+","AB-","AB+"]
    
    var selectedBloodType: String?
    
    var allEmails:[String] = []
    
    var coronaButtonSelected: String = "false"
    
    private var dateAndTimePicker: UIDatePicker?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateAndTimePicker = UIDatePicker()
        dateAndTimePicker?.datePickerMode = .date
        dateAndTimePicker?.addTarget(self, action: #selector(RegistrationViewController.dateChanged(dateAndTimePicker: )), for: .valueChanged)
        previousDonationDate.inputView = dateAndTimePicker
        let phoneNumberKit = PhoneNumberKit()
        phoneNumberTextField.delegate = self
        birthDateTextField.delegate = self
        bloodTypePicker()
        createToolBar()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "-+1234567890()"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        //Makes sure email isnt blank
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let bloodType = bloodTypeTextField.text else { return }
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let birthDate = birthDateTextField.text else { return }
        guard let previousDonation = previousDonationDate.text else { return }
        var hasCorona = coronaButtonSelected
        if email != "" && password != "" {
        
        if registerTypeSelecter.selectedSegmentIndex == 0{
            //Donator Selected
          
            Auth.auth().createUser(withEmail: email, password: password) { (AuthResult, error) in
                if error != nil{
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "donatorSignUpSuccessful", sender: self)
                    
                    db.collection("Donor").document(bloodType).getDocument { (document, error) in
                        
                        if error != nil{
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        }else{
                            let data = document?.data()
                            var oldemail = data?["Email"] as? [String] ?? [""]
                            var oldname = data?["Name"] as? [String] ?? [""]
                            var oldPhoneNumber = data?["Phone Number"] as? [String] ?? [""]
                            var oldAge = data?["Age"] as? [String] ?? [""]
                            var oldLastDonationDate = data?["Previous Donation Date"] as? [String] ?? [""]
                            var oldHasCoronaStatus = data?["Had Corona Virus"] as? [String] ?? [""]
                            
                            
                            oldemail.append(email)
                            oldname.append(fullname)
                            oldPhoneNumber.append(phoneNumber)
                            oldAge.append(birthDate)
                            oldLastDonationDate.append(previousDonation)
                            oldHasCoronaStatus.append(hasCorona)
                            
                            db.collection("Donor").document(bloodType).updateData(["Email" : oldemail, "Name" : oldname, "Blood Type": bloodType,"Phone Number": oldPhoneNumber, "Age": oldAge, "Previous Donation Date": oldLastDonationDate, "Had Corona Virus": oldHasCoronaStatus])
                            
                            if hasCorona == "true"{
                                
                                db.collection("Donor").document("Corona Antibodies").getDocument { (document, error) in
                                    if error != nil{
                                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                                    }else{
                                        
                                        let data = document?.data()
                                        var oldCoronaEmails = data?["Email"] as? [String] ?? [""]
                                        var oldCoronaName = data?["Name"] as? [String] ?? [""]
                                        var oldBloodTypes = data?["Blood Type"] as? [String] ?? [""]
                                        var oldPhoneNumber = data?["Phone Number"] as? [String] ?? [""]
                                        var oldAge = data?["Age"] as? [String] ?? [""]
                                        var oldLastDonationDate = data?["Previous Donation Date"] as? [String] ?? [""]
                                        var oldhasCoronaStatus = data?["Had Corona Virus"] as? [String] ?? [""]

                                        
                                        oldCoronaEmails.append(email)
                                        oldCoronaName.append(fullname)
                                        oldBloodTypes.append(self.bloodTypeTextField.text ?? "")
                                        oldPhoneNumber.append(phoneNumber)
                                        oldAge.append(birthDate)
                                        oldLastDonationDate.append(previousDonation)
                                        
                                        db.collection("Donor").document("Corona Antibodies").updateData(["Email" : oldemail, "Name" : oldname, "Blood Type": oldBloodTypes,"Phone Number": oldPhoneNumber, "Age": oldAge, "Previous Donation Date": oldLastDonationDate, "Had Corona Virus": oldhasCoronaStatus])
                                    }
                                }
                            }else if hasCorona == "false"{
                                
                                return
                                
                            }
                            
                        }
                    }
                     
                   //  db.collection("Donor").document(bloodType).updateData(["Email" : email, "Name" : fullname, "Blood Type": bloodType])
                   
                    
                    print("Successful Donor Registration")
                }
            }
        }
        else if registerTypeSelecter.selectedSegmentIndex == 1{
            //Personnel Selected
          
            Auth.auth().createUser(withEmail: email, password: password) { (AuthResult, error) in
                if error != nil{
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "personnelSignUpSuccessful", sender: self)
                    db.collection("Personnel").document(bloodType).updateData(["Email" : email, "Name" : fullname, "Blood Type": bloodType])
                    print("Successful Personnel Registration")
                }
            }
        }
    }
}
    func bloodTypePicker(){
        let bloodPicker = UIPickerView()
        bloodPicker.delegate = self
        bloodTypeTextField.inputView = bloodPicker
    }
    
    @objc func dateChanged(dateAndTimePicker: UIDatePicker){
      let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    previousDonationDate.text = dateFormatter.string(from: dateAndTimePicker.date)
    
    }
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        bloodTypeTextField.inputAccessoryView = toolBar
        previousDonationDate.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func coronaButtonPressed(_ sender: UIButton) {
        if sender.isSelected == true{
            coronaButton.setBackgroundImage(UIImage(named: "checkbox"), for: .normal)
            coronaButtonSelected = "true"
            sender.isSelected = false
        }else if sender.isSelected == false{
            coronaButton.setBackgroundImage(UIImage(named: "squarebox"), for: .normal)
            coronaButtonSelected = "false"
            sender.isSelected = true
        }
    }
  
        
}

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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
