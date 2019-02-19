//
//  ProfileViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/29/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var businessName: UITextView!
    @IBOutlet weak var recurringSpecial: UITextView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var menuURL: UITextField!
    
    var imageFile = [PFFileObject]()
    
    
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
            profile["menuurl"] = menuURL.text
            
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
                        
                        //self.imageToPost.image = nil
                        
                        
                    } else {
                        
                        self.displayAlert(title: "Update Failed", message: "Please try again later")
                        
                    }
                })
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        let query = PFQuery(className:"Profile")
        
        let currentUser = PFUser.current()
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {
                
                // The find succeeded.
                print("Successfully retrieved \(objects.count) profile.")
                // Do something with the found objects
                
                for object in objects {

                    if object["userid"] as? String == currentUser?.objectId {
                        
                        self.recurringSpecial.text = object["recurringspecial"] as? String
                        self.businessName.text = object["businessname"] as? String
                        self.imageFile.append(object["bannerimage"] as! PFFileObject)
                        self.menuURL.placeholder = object["menuurl"] as? String
                    
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
        
        
        
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
