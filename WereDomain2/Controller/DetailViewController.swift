//
//  DetailViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/23/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblBusinessName: UILabel!
    
    var image = UIImage()
    var name = ""
    var recurringSpecial = ""
    var foodSpecial = ""
    var drinkSpecial = ""
    

    override func viewDidLoad() {
        
        
        imgImage.image = image
        lblBusinessName.text = name
         
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        
        cell.specialLabel.text = "Food Special"
        cell.detailLabel.text = foodSpecial
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is FeedTableViewController
        {
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }

}
