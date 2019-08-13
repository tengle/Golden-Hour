//
//  DetailViewController.swift
//  WereDomain2
//
//  Created by Tyler Engle on 1/23/19.
//  Copyright © 2019 Tyler Engle. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblRecurringSpecial: UILabel!
    
    var image = UIImage()
    var name = ""
    var recurringSpecial = ""
    
    @IBAction func backToMain(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
        
        
        imgImage.image = image
        lblBusinessName.text = name
        lblRecurringSpecial.text = recurringSpecial
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is FeedTableViewController
        {
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    

}
