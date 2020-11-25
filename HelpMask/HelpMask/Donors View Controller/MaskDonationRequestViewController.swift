//
//  MaskDonationRequestViewController.swift
//  HelpMask
//
//  Created by Rohan Jagtap on 2020-03-26.
//  Copyright © 2020 Rohan Jagtap. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol passDonationInformationDelegate {
    func passThisInformation(hospitalCodeKey: String, Name: String, dateAndTime: String, maskDescription: String)
}

class MaskDonationRequestViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    
    
    @IBOutlet weak var maskPictureDisplau: UIImageView!
    
    @IBOutlet weak var hospitalCode: UITextField!
    
    @IBOutlet weak var nameOfUserTextFIeld: UITextField!
    
    @IBOutlet weak var maskDonationDateAndTime: UITextField!
    
    @IBOutlet weak var maskDescriptionTextView: UITextView!
    
    @IBOutlet weak var submitDonationButton: UIButton!
    
    @IBOutlet weak var pickAnImageButton: UIButton!
    
    var User_name: String?
    var imagePicker = UIImagePickerController()
    private var dateAndTimePicker: UIDatePicker?
    var HospitalKeyData = [String]()
    var delegate: passDonationInformationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
         dateAndTimePicker = UIDatePicker()
         dateAndTimePicker?.datePickerMode = .dateAndTime
         dateAndTimePicker?.addTarget(self, action: #selector(meetingTimeScheduleViewController.dateChanged(dateAndTimePicker: )), for: .valueChanged)
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
         view.addGestureRecognizer(tapGesture)
         maskDonationDateAndTime.inputView = dateAndTimePicker
        if Auth.auth().currentUser?.uid == nil { perform(#selector(handleLogout), with: nil, afterDelay: 0)}
    
            }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
               view.endEditing(true)
           }
    @objc func handleLogout() {
        
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "ASVC") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    

    @IBAction func pickAnImageButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
               
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            maskPictureDisplau.contentMode = .scaleAspectFit
            maskPictureDisplau.image = pickedImage
        }
     
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSendRequest(){
        guard let image = maskPictureDisplau.image, let data = image.jpegData(compressionQuality: 1.0) else{
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference(forURL: "https://maskhelp-ec4c5.firebaseio.com/")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let storageProfileRef = imageReference.child("Mask Donation Requests").child(Auth.auth().currentUser!.uid)
        storageProfileRef.putData(data, metadata: metadata) { (storageMetaData, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
        }
       
        
        let ref = Database.database().reference().child("Mask Donation Requests")
        let childRef = ref.childByAutoId()
        let values = ["Hospital Code" : hospitalCode.text!, "Name of Donator": nameOfUserTextFIeld.text!, "Donation Date and Time": maskDonationDateAndTime.text!, "Mask Description": maskDescriptionTextView.text!, "Image Data": imageName]
        childRef.updateChildValues(values)
        let userID = Auth.auth().currentUser?.uid
        let hospitalCodeReference = ref.root.child("Hospitals").child(userID!).child("Hospital Code").queryEqual(toValue: hospitalCode.text)
        hospitalCodeReference.observe(.value) { (snapshot) in
            print(snapshot)
           // guard let data = snapshot as? NSDictionary else {return}
            //let each_token = data[hospitalCodeReference] as? String
            //print("ALL CODE: \(each_token!)")
        }
        
    }
    
   
    @objc func dateChanged(dateAndTimePicker: UIDatePicker){
      let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    maskDonationDateAndTime.text = dateFormatter.string(from: dateAndTimePicker.date)
    
    }
    
    
    
    @IBAction func submitDonationButtonPressed(_ sender: Any) {
        handleSendRequest()
        delegate?.passThisInformation(hospitalCodeKey: hospitalCode.text!, Name: nameOfUserTextFIeld.text!, dateAndTime: maskDonationDateAndTime.text!, maskDescription: maskDescriptionTextView.text!)
        
    }
    
    
    
}

