//
//  DashboardViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/30/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UIViewController {    
    
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var specialsLabel: UILabel!
    
    
    var imageFile = [PFFileObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsLabel.text = "44"
        specialsLabel.text = "8"
        
        
        let currentUser = PFUser.current()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {
                
                // The find succeeded.
                print("Dashboard retrieved \(objects.count) profile.")
                self.usersLabel.text = "\(objects.count)"
                
                for object in objects {
                    
                    if object.objectId == currentUser?.objectId {
                        
                        if object["admin"] as? Bool == true {
                            
                        } else {

                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        PFUser.logOut()
        
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

}
