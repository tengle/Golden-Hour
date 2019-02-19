//
//  ViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/23/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var profileCount = 0
    var usernames = [String]()
    var imageFiles = [PFFileObject]()
    var activeCell = 0
    
    var imageArray = [UIImage]() /*[UIImage(named: "77.jpg"), UIImage(named: "Jack.jpg"), UIImage(named: "St.jpg"), UIImage(named: "Rose.jpg"), UIImage(named: "Kung.jpg"), UIImage(named: "Dog.jpg")]*/
    
    var nameArray = [String]()/*["77", "Jack", "St.Gen", "Rose Room", "Kung Fu", "Dogwood" ]*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let profileQuery = PFQuery(className:"Profile")
        
        profileQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                
                // Log details of the failure
                print(error.localizedDescription)
                
            } else if let objects = objects {

                // The find succeeded.
                self.profileCount = objects.count
                print("Successfully retrieved \(objects.count) profile.")
                
                // Do something with the found objects
                
                for object in objects {
                    
                    self.imageFiles.append(object["bannerimage"] as! PFFileObject)
                    self.nameArray.append(object["businessname"] as! String)
                    
                    self.imageFiles[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.imageArray.append(imageToDisplay)
                                
                                print(self.imageArray.count)
                            }
                        }
                    }
                }
            }
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.profileCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        // Configure the cell...
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    cell.postedImage.image = imageToDisplay
                    
                }
                
            }
            
        }
        
        cell.businessName.text! = nameArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let desViewC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let webViewC = mainStoryboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        desViewC.image = imageArray[indexPath.row]
        desViewC.name = nameArray[indexPath.row]
        
        print(indexPath.row)
        
        self.navigationController?.pushViewController(desViewC, animated: true)
        
    }
}

