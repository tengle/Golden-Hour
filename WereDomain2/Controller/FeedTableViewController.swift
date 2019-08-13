//
//  FeedTableViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 2/2/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var profileCount = 0
    var usernames = [String]()
    var imageFiles = [PFFileObject]()
    var activeCell = 0
    
    var imageArray = [UIImage]()
    var nameArray = [String]()
    var idArray = [String]()
    var eventArray = [String]()
    var fromtimeArray = [String]()
    var totimeArray = [String]()
    var drinkSpecialArray = [String]()
    var foodSpecialArray = [String]()

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
                
                print("Successfully retrieved \(objects.count) profiles.")
                
                // Do something with the found objects
                
                for object in objects {
                    
                        self.nameArray.append(object["businessname"] as! String)
                    
                        self.eventArray.append(object["recurringspecial"] as! String)
                    
                        self.imageFiles.append(object["bannerimage"] as! PFFileObject)
                    
                        self.fromtimeArray.append(object["fromtime"] as! String)
                    
                        self.totimeArray.append(object["totime"] as! String)
                    
                        self.drinkSpecialArray.append(object["foodspecial"] as! String)
                    
                        self.foodSpecialArray.append(object["drinkspecial"] as! String)
                    
                    
                        }

                    }
            
                    self.tableView.reloadData() //This may be updating too much
            
                }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.profileCount
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        // Configure the cell...
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    cell.postedImage.image = imageToDisplay
                    self.imageArray.append(imageToDisplay)
                    
                }
                
            }
            
            
        }
        
        cell.businessName.text! = nameArray[indexPath.row]
        
        cell.specialTimeLabel.text = (fromtimeArray[indexPath.row] + " - " + totimeArray[indexPath.row])
        
        cell.specialDetailsLabel.text = ("Food Specials: \n " + foodSpecialArray[indexPath.row] + "\n Drink Specials: \n" + drinkSpecialArray[indexPath.row])
        
        cell.badgeImage.image = UIImage(named: "timerred")


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeCell = indexPath.row
        
        self.performSegue(withIdentifier: "showDetailView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let detailVC = segue.destination as? DetailViewController
        
        if segue.destination is DetailViewController
        {
            
            detailVC?.image = imageArray[activeCell]
            detailVC?.name = nameArray[activeCell]
            detailVC?.foodSpecial = foodSpecialArray[activeCell]
       
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        PFUser.logOut()
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
