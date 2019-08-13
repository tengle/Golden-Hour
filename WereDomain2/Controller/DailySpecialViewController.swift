//
//  DailySpecialViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/30/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class DailySpecialViewController: UIViewController {

    @IBOutlet weak var specialDatePicker: UIDatePicker!
    @IBOutlet weak var fromTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var foodSpecialTextView: UITextView!
    @IBOutlet weak var drinkSpecialTextView: UITextView!
    

    
    var fromTimeFormatted = ""
    var toTimeFormatted = ""
    var currentAccount = ""
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func setFrom(_ sender: Any) {
        
        fromTime.text = DateFormatter.localizedString(from: specialDatePicker.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        fromTimeFormatted = formatter.string(from: specialDatePicker.date)
        
    }
    
    @IBAction func setTo(_ sender: Any) {
        
        toTime.text = DateFormatter.localizedString(from: specialDatePicker.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        toTimeFormatted = formatter.string(from: specialDatePicker.date)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(currentAccount)
        
        specialDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
      
    }
    
    
    
    @IBAction func saveSpecial(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let profile = PFObject(className: "Profile")
        
        let query = PFQuery(className:"Profile")
        
        query.getObjectInBackground(withId: currentAccount) { (profile: PFObject?, error: Error?) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else if let profile = profile {
                
                profile["fromtime"] = self.fromTimeFormatted
                profile["totime"] = self.toTimeFormatted
                profile["foodspecial"] = self.foodSpecialTextView.text
                profile["drinkspecial"] = self.drinkSpecialTextView.text
                
                profile.saveInBackground { (success: Bool, error: Error?) in
                    
                    activityIndicator.stopAnimating()
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if (success) {
                        
                        self.displayAlert(title: "Special Updated!", message: "Your Daily Special has been updated successfully")
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        print(error?.localizedDescription as Any)
                        
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
