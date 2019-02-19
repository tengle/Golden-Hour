//
//  LoginViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/29/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    var adminModeActive = false
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userSegment: UISegmentedControl!
    
    
    @IBAction func segmentSwitched(_ sender: Any) {
        
        if userSegment.isEnabledForSegment(at: 1) {
            
            adminModeActive = true
            
        } else {
            
            adminModeActive = false
            
        }
        
    }
    

    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logIn(_ sender: Any) {

        
        if email.text == "" || password.text == "" {
            
            displayAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
        
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()

            PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
            
            activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if user != nil {
                
                print("Login successful")
                
                if self.adminModeActive == true {
                    
                    self.performSegue(withIdentifier: "showAdmin", sender: self)
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showMainView", sender: self)
                }
                
            } else {
                
                var errorText = "Unknown error: please try again"
                
                if let error = error {
                    
                    errorText = error.localizedDescription
                    
                }
                self.displayAlert(title: "Could not log you in", message: errorText)
            }
        })
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
            
            displayAlert(title: "Error in form", message: "Please enter an email and password")
        
        } else {
            
        print("Signing up.... ")
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
        
        if self.adminModeActive == true {
            
            user["admin"] = true
            
        } else {
            
            user["admin"] = false
            
        }
        
        user.signUpInBackground { (success, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
            if let error = error {
                
                self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                
            } else {
                
                print("signed up!")
                
                if self.adminModeActive == true {
                    
                    self.performSegue(withIdentifier: "showAdmin", sender: self)
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showMainView", sender: self)
                }
                
            }
            
        }
        
    }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let currentUser = PFUser.current()
        
        if currentUser != nil {
            
        let query = PFUser.query()
        
        query?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {
                
                // The find succeeded.
                print("Successfully retrieved \(objects.count) profile.")
                // Do something with the found objects
                
                for object in objects {
                    
                    if object.objectId == currentUser?.objectId {
                    
                        if object["admin"] as? Bool == true {
                        
                            self.performSegue(withIdentifier: "showAdmin", sender: self)
                        
                        } else {
                            
                            self.performSegue(withIdentifier: "showMainView", sender: self)
                            
                        }
                    }
                }
            }
        }
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
