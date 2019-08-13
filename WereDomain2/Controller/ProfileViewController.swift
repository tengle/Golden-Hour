//
//  ProfileViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/29/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var businessName: UITextView!
    @IBOutlet weak var recurringSpecial: UITextView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var accountSelectorView: UIView!
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    var selectedAccountFoodSpecial = String()
    var selectedAccountDrinkSpecial = ""
    var selectedAccountFromTime = ""
    var selectedAccountToTime = ""
    
    var pickerData: [String] = [String]()
    var numberOfAccounts = 0
    var selectedAccount = String()
    var selectedObjectID = ""
    var imageFile = [PFFileObject]()
    

    @IBAction func selectButtonClicked(_ sender: Any) {
        
        let query = PFQuery(className:"Profile")
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {
                
                print("Successfully retrieved \(objects.count) profile.")
                
                for object in objects {
                    
                    if object["businessname"] as? String == self.selectedAccount {
                        
                        self.selectedObjectID = object.objectId ?? "Error"
                        self.recurringSpecial.text = object["recurringspecial"] as? String
                        self.businessName.text = object["businessname"] as? String
                        self.imageFile.append(object["bannerimage"] as! PFFileObject)
                        self.imageFile[0].getDataInBackground { (data, error) in
                            
                            if let imageData = data {
                                
                                if let imageToDisplay = UIImage(data: imageData) {
                                    
                                    self.bannerImage.image = imageToDisplay
                                    
                                }
                            }
                            
                            
                            
                        }
                    }
                }
            }
        }

        accountSelectorView.isHidden = true
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        accountSelectorView.isHidden = true

        
    }
    
    func pickerView(_ accountPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedAccount = pickerData[row]
        print("picked " + selectedAccount)
        
    }
    
    func numberOfComponents(in accountPicker: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ accountPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return numberOfAccounts
    }
    
    func pickerView(_ accountPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        
        //Show picker
        self.accountSelectorView.isHidden = false
        
        let query = PFQuery(className:"Profile")
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {
                
                // The find succeeded.
                print("Selector retrieved \(objects.count) profiles.")
                // Do something with the found objects
                self.numberOfAccounts = objects.count
                
                for object in objects {
                    
                    self.pickerData.append(object["businessname"] as? String ?? "Error")
                    
                }
            }
            
            self.accountPicker.reloadAllComponents()
        }
        
        
        
    }
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func changeBannerImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            bannerImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        
        
        if let image = bannerImage.image {
            
            let profile = PFObject(className: "Profile")
            
            profile["userid"] = PFUser.current()?.objectId
            profile["businessname"] = businessName.text
            profile["recurringspecial"] = recurringSpecial.text
            
            if let imageData = image.pngData() {
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                
                activityIndicator.center = self.view.center
                
                activityIndicator.hidesWhenStopped = true
                
                activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
                
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageFile = PFFileObject(name: "image.png", data: imageData)
                
                profile["bannerimage"] = imageFile
                
                profile.saveInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if success {
                        
                        self.displayAlert(title: "Profile Updated!", message: "Your profile has been updated successfully")
                      
                    } else {
                        
                        self.displayAlert(title: "Update Failed", message: "Please try again later")
                        
                    }
                })
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        accountPicker.delegate = self
        accountPicker.dataSource = self
        
        self.accountSelectorView.isHidden = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let dailySpecialVC = segue.destination as? DailySpecialViewController
        
        if segue.destination is DailySpecialViewController
            
        {
            dailySpecialVC?.currentAccount = selectedObjectID
            print(selectedObjectID)
            
        }
    }

}
